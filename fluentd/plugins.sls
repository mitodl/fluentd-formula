{% if salt.pillar.get('fluentd:plugin_dependencies') %}
install_fluentd_plugin_dependencies:
  pkg.installed:
    - pkgs: {{ salt.pillar.get('fluentd:plugin_dependencies') | tojson }}
    - refresh: True
    - require_in:
        - gem: install_fluentd_plugins
{% endif %}

install_fluentd_plugins:
  gem.installed:
    - names: {{ salt.pillar.get('fluentd:plugins') | tojson }}

{% set http_plugins = salt.pillar.get('fluentd:http_plugins') %}
{% for plugin in http_plugins %}
download_{{ plugin.name }}_for_gem_install:
  file.managed:
    - name: /tmp/{{ plugin.name }}.gem
    - source: {{ plugin.url }}
    - source_hash: {{ plugin.source_hash }}

install_{{ plugin.name }}_gem:
  cmd.run:
    - name: gem install --local /tmp/{{ plugin.name }}.gem
    - onchanges:
        - file: download_{{ plugin.name }}_for_gem_install
{% endfor %}
