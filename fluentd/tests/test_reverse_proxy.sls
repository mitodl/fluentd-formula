{% from "fluentd/map.jinja" import fluentd with context %}

test_nginx_is_installed:
  testinfra.package:
    - name: nginx
    - is_installed: True

test_ssl_directory:
  testinfra.file:
    - name: {{ fluentd.ssl_directory }}/certs
    - exists: True
    - is_directory: True

test_ssl_certificate_present:
  testinfra.file:
    - name: {{ fluentd.ssl_directory }}/certs/{{ fluentd.nginx_config.cert_file }}
    - exists: True
    - is_file: True

test_ssl_key_present:
  testinfra.file:
    - name: {{ fluentd.ssl_directory }}/certs/{{ fluentd.nginx_config.key_file }}
    - exists: True
    - is_file: True

test_nginx_running:
  testinfra.service:
    - name: nginx
    - is_running: True
    - is_enabled: True

test_nginx_site_configured:
  testinfra.file:
    - name: {{ fluentd.nginx_site_path }}/fluentd
    - exists: True
    - is_file: True

test_nginx_listening_http:
  testinfra.socket:
    - name: tcp://0.0.0.0:80
    - is_listening: True

test_nginx_listening_https:
  testinfra.socket:
    - name: tcp://0.0.0.0:443
    - is_listening: True
