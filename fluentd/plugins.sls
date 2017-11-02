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

{% set git_plugins = salt.pillar.get('fluentd:git_plugins') %}
{% if git_plugins %}
ensure_git_is_installed_for_fluent_git_plugins:
  pkg.installed:
    - name: git

{% for plugin in git_plugins %}
clone_{{ plugin.name }}_for_gem_install:
  git.latest:
    - name: {{ plugin.url }}
    - target: /tmp/{{ plugin.name }}
    - rev: {{ plugin.get('rev', 'master') }}

install_{{ plugin.name }}_gem:
  gem.installed:
    - name: /tmp/{{ plugin.name }}
{% endfor %}
{% endif %}
