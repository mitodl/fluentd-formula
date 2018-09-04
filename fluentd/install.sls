{% from "fluentd/map.jinja" import fluentd, fluentd_service with context %}

install_fluentd_dependencies:
  pkg.installed:
    - pkgs: {{ fluentd.pkgs }}
    - update: True

install_fluentd_gem:
  gem.installed:
    - name: fluentd
    {% if fluentd.version %}
    - version: {{ fluentd.version }}
    {% endif %}

create_fluentd_user:
  user.present:
    - name: {{ fluentd.user }}
    - createhome: False
    - system: True

create_fluentd_group:
  group.present:
    - name: {{ fluentd.group }}
    - addusers:
        - {{ fluentd.user }}
    - system: True

configure_fluentd:
  file.managed:
    - name: /etc/fluent/fluent.conf
    - source: salt://fluentd/templates/fluent.conf
    - makedirs: True
    - user: {{ fluentd.user }}
    - group: {{ fluentd.group }}
    - template: jinja
    - context:
        log_level: {{ fluentd.global_log_level }}

make_fluent_config_directory:
  file.directory:
    - name: /etc/fluent/fluent.d/
    - makedirs: True
    - user: {{ fluentd.user }}
    - group: {{ fluentd.group }}
    - recurse:
      - user
      - group

fluentd_control_script:
  file.managed:
    - name: /usr/local/bin/fluentd.sh
    - source: salt://fluentd/files/fluentd.sh
    - mode: 0755
    - user: {{ fluentd.user }}
    - group: {{ fluentd.group }}

configure_fluentd_service:
  file.managed:
    - name: {{ fluentd_service.destination_path }}
    - source: salt://fluentd/files/{{ fluentd_service.source_path }}
    - context:
        user: {{ fluentd.user }}
        group: {{ fluentd. group }}

start_fluentd_service:
  service.running:
    - name: fluentd
    - enable: True
    - require:
        - file: configure_fluentd_service
    - watch:
        - file: configure_fluentd
