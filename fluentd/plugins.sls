{% for plugin in salt.pillar.get('fluentd:plugins') %}
fluentd_install_{{ plugin.name }}:
  cmd.run:
    - name: /usr/local/bin/fluentd-plugin install {{ plugin.name }}
{% endfor %}
