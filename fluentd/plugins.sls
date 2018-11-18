{% if salt.pillar.get('fluentd:plugin_dependencies') %}
install_fluentd_plugin_dependencies:
  pkg.installed:
    - pkgs: {{ salt.pillar.get('fluentd:plugin_dependencies') }}
    - refresh: True
    - require_in:
        - gem: install_fluentd_plugins
{% endif %}

{% if salt['pillar.get']('fluentd:use_gem', False) %}
install_fluentd_plugins:
  gem.installed:
    - names: {{ salt.pillar.get('fluentd:plugins') }}
    - require:
      - file: configure_fluentd
    - watch_in:
        service: fluentd-service
{% else %}
{% for plugin in salt['pillar.get']('fluentd:plugins', {}) %}
install_fluentd_plugin_{{ plugin }}:
  cmd.run:
    - name: td-agent-gem install {{ plugin }}
    - unless: td-agent-gem list {{ plugin }} -i
    - require:
      - file: configure_fluentd
    - watch_in:
        service: fluentd-service
{% endfor %}
{% endif %}

