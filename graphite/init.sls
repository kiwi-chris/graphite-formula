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

graphite_web_config:
  file.managed:
    - name: {{ map.web_conf_file }}
    - source: salt://graphite/files/local_settings_py.jinja
    - template: jinja

