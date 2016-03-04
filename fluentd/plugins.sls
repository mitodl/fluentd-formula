{% if salt.pillar.get('fluentd:plugin_dependencies') %}
install_fluentd_plugin_dependencies:
  pkg.installed:
    - pkgs: {{ salt.pillar.get('fluentd:plugin_dependencies') }}
    - refresh: True
    - require_in:
        - gem: install_fluentd_plugins
{% endif %}

install_fluentd_plugins:
  gem.installed:
    - names: {{ salt.pillar.get('fluentd:plugins') }}
