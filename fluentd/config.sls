{% for config in salt.pillar.get('fluentd:configs', []) %}
add_fluent_{{ config.name }}_config:
  file.managed:
    - name: /etc/fluent/fluent.d/{{ config.name }}.conf
    - source: salt://fluentd/templates/fluent-config-template.conf
    - template: jinja
    - context:
        settings: {{ config.settings }}
    - watch_in:
        - service: reload_fluentd_service
{% endfor %}

reload_fluentd_service:
  service.running:
    - name: fluentd
    - enable: True
    - reload: True
