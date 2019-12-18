{% from "fluentd/map.jinja" import fluentd with context %}
{% for config in salt.pillar.get('fluentd:configs', []) %}

add_fluent_{{ config.name }}_config:
  file.managed:
    - name: /etc/fluent/fluent.d/{{ config.name }}.conf
    - source: salt://fluentd/templates/fluent-config-template.conf
    - template: jinja
    - context:
        settings: {{ config.settings | tojson }}
    - watch_in:
      - service: reload_fluentd_service
{% endfor %}

{% for name, path in salt.pillar.get('fluentd:persistent_directories', {}).items() %}
create_directory_for_{{ name }}_logs:
  file.directory:
   - name: {{ path }}
   - makedirs: True
   - user: {{ fluentd.user }}
   - group: {{ fluentd.group }}
   - recurse:
     - user
     - group
{% endfor %}

{% for cert, details in salt.pillar.get('fluentd:cert', {}).items() %}
create_{{ cert }}_file:
  file.managed:
    - name: {{ details['path'] }}
    - contents: |
        {{ details['content']|indent(8) }}
    - user: {{ fluentd.user }}
    - group: {{ fluentd.group }}
    - mode: '0400'
{% endfor %}

reload_fluentd_service:
  service.running:
    - name: fluentd
    - enable: True
    - init_delay: 20
    - reload: True
