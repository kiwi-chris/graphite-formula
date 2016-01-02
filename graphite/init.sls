{% from "graphite/map.jinja" import map with context %}

graphite:
  pkg.installed:
    - pkgs: {{ map.pkgs|json }}

  service.running:
    - name: {{ map.service }}
    - require:
      - pkg: graphite
    - watch:
      - file: graphite_carbon_config
      - file: carbon_storage_conf

graphite_default_config:
  file.managed:
    - name: {{ map.carbon_default_file }}
    - source: salt://graphite/files/graphite-carbon.jinja
    - template: jinja

graphite_carbon_config:
  file.managed:
    - name: {{ map.carbon_conf_file }}
    - source: salt://graphite/files/carbon_conf.jinja
    - template: jinja

carbon_storage_conf:
  file.managed:
    - name: {{ map.carbon_storage_conf }}
    - source: salt://graphite/files/storage-schemas_conf.jinja
    - template: jinja

carbon_storage_aggregation:
  file.managed:
    - name: {{ map.carbon_storage_aggregation }}
    - source: salt://graphite/files/storage-aggregation.conf
    - template: jinja

graphite_web_config:
  file.managed:
    - name: {{ map.web_conf_file }}
    - source: salt://graphite/files/local_settings_py.jinja
    - template: jinja

#initial_data.yaml:
#  file.managed:
#    - name: {{ map.initial_data_django }}
#    - source: salt://graphite/files/initial_data.yaml
#    - template: jinja
#    - require:
#      - pkg: graphite

initialise_backend:
  cmd.run:
    - cwd: /var/lib/graphite
    - name: graphite-manage syncdb --noinput
    - require:
      - pkg: graphite
#      - file: initial_data.yaml
    - unless: test -e /var/lib/graphite/graphite.db

wsgi_symlink:
  file.symlink:
    - name: /usr/share/graphite-web/wsgi.py
    - target: /usr/share/graphite-web/graphite.wsgi
    - pkg: graphite-web

db_owner:
  file.managed:
    - name: /var/lib/graphite/graphite.db
    - user: _graphite
    - group: _graphite
    - require:
      - pkg: graphite
    - onlyif: test -e /var/lib/graphite/graphite.db
