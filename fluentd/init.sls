{% from "fluentd/map.jinja" import fluentd with context %}

include:
  - .install
  - .plugins

configure_fluentd:
  file.managed:
    - name: {{ fluentd.conf_file }}
    - source: salt://fluentd/templates/fluent.conf
    - makedirs: True
    - template: jinja
    - context:
        log_level: {{ fluentd.global_log_level }}
    - watch_in:
        service: fluentd-service

{% for config in salt.pillar.get('fluentd:configs', []) %}
add_fluent_{{ config.name }}_config:
  file.managed:
    - name: {{ fluentd.conf_dir }}/{{ config.name }}.conf
    - source: salt://fluentd/templates/fluent-config-template.conf
    - template: jinja
    - context:
        settings: {{ config.settings }}
    - watch_in:
        service: fluentd-service
{% endfor %}

fluentd-service:
  service.running:
    - name: {{ fluentd.service }}
    - enable: True
{% if salt['pillar.get']('fluentd:use_gem', False) %}
{% else %}
    - require:
      - pkg: install-fluentd
{% endif %}
