{% from "fluentd/map.jinja" import fluentd, fluentd_config with context %}

include:
  - fluentd

fluentd-config:
  file.managed:
    - name: {{ fluentd.conf_file }}
    - source: salt://fluentd/templates/conf.jinja
    - template: jinja
    - context:
      config: {{ fluentd_config }}
    - watch_in:
      - service: fluentd
