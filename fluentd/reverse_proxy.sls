{% from "fluentd/map.jinja" import fluentd with context %}

fluentd_install_nginx:
  pkg.installed:
    - name: nginx
    - refresh: True

ensure_fluentd_ssl_directory:
  file.directory:
    - name: {{ fluentd.ssl_directory }}/certs
    - makedirs: True

{% if fluentd.nginx_config.get('cert_source') or fluentd.nginx_config.get('cert_contents') %}
setup_fluentd_ssl_cert:
  file.managed:
    - name: {{fluentd.ssl_directory}}/certs/{{ fluentd.nginx_config.cert_file }}
    {% if fluentd.nginx_config.cert_source %}
    - source: {{ fluentd.nginx_config.cert_source }}
    {% elif fluentd.nginx_config.cert_contents %}
    - contents: |
        {{ fluentd.nginx_config.cert_contents | indent(8) }}
    {% endif %}
    - makedirs: True

setup_fluentd_ssl_key:
  file.managed:
    - name: {{fluentd.ssl_directory}}/certs/{{ fluentd.nginx_config.key_file }}
    {% if fluentd.nginx_config.key_source %}
    - source: {{ fluentd.nginx_config.key_source }}
    {% elif fluentd.nginx_config.key_contents %}
    - contents: |
        {{ fluentd.nginx_config.key_contents | indent(8) }}
    {% endif %}
    - makedirs: True
{% else %}
setup_fluentd_ssl_cert:
  module.run:
    - name: tls.create_self_signed_cert
    - tls_dir: ''
    - cacert_path: {{ fluentd.ssl_directory }}
    - makedirs: True
    {% for arg, val in salt.pillar.get('fluentd:ssl:cert_params', {}).items() -%}
    - {{ arg }}: {{ val }}
    {% endfor -%}
{% endif %}

generate_nginx_dhparam:
  cmd.run:
    - name: openssl dhparam -out dhparam.pem 2048
    - cwd: {{ fluentd.ssl_directory }}/certs
    - unless: "[ -e {{ fluentd.ssl_directory }}/dhparam.pem ]"
    - require:
        - file: ensure_fluentd_ssl_directory

configure_fluentd_nginx:
  file.managed:
    - name: {{ fluentd.nginx_site_path }}/fluentd
    - source: salt://fluentd/templates/nginx_proxy.conf
    - template: jinja
    - makedirs: True
    - context:
        config: {{ fluentd.nginx_config }}
        ssl_directory: {{ fluentd.ssl_directory }}/certs
        plugins: {{ salt.pillar.get('proxied_plugins', []) }}

remove_default_nginx_config:
  file.absent:
    - name: {{ fluentd.nginx_site_path }}/default

nginx_service_running:
  service.running:
    - name: nginx
    - enable: True
    - watch:
        - file: configure_fluentd_nginx
