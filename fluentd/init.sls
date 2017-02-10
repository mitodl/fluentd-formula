{% from "fluentd/map.jinja" import fluentd, fluentd_service with context %}

{% if salt.grains.get('osfullname').lower() == 'ubuntu' and salt.grains.get('osmajorrelease')|int < 16 %}
add_brightbox_ruby_ppa:
  pkgrepo.managed:
    - name: brightbox-ruby
    - humanname: BrightBox Ruby PPA
    - ppa: brightbox/ruby-ng

install_ruby_deps:
  pkg.installed:
    - pkgs:
        - ruby2.3
        - ruby2.3-dev
        - build-essential
    - update: True
    - require:
        - pkgrepo: add_brightbox_ruby_ppa
{% else %}
install_fluentd_dependencies:
  pkg.installed:
    - pkgs: {{ fluentd.pkgs }}
    - update: True
{% endif %}

install_fluentd_gem:
  gem.installed:
    - name: fluentd
    {% if fluentd.version %}
    - version: {{ fluentd.version }}
    {% endif %}

configure_fluentd:
  file.managed:
    - name: /etc/fluent/fluent.conf
    - source: salt://fluentd/templates/fluent.conf
    - makedirs: True
    - template: jinja
    - context:
        log_level: {{ fluentd.global_log_level }}

make_fluent_config_directory:
  file.directory:
    - name: /etc/fluent/fluent.d/
    - makedirs: True

fluentd_control_script:
  file.managed:
    - name: /usr/local/bin/fluentd.sh
    - source: salt://fluentd/files/fluentd.sh
    - mode: 0755

configure_fluentd_service:
  file.managed:
    - name: {{ fluentd_service.destination_path }}
    - source: salt://fluentd/files/{{ fluentd_service.source_path }}

start_fluentd_service:
  service.running:
    - name: fluentd
    - enable: True
    - require:
        - file: configure_fluentd_service
    - watch:
        - file: configure_fluentd
