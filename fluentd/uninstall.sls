{% from "fluentd/map.jinja" import fluentd, fluentd_service with context %}

stop_service:
  service.dead:
    - name: fluentd
    - enable: false

remove_service_config:
  file.absent:
    - name: {{ fluentd_service.destination_path }}

remove_control_script:
  file.absent:
    - name: /usr/local/bin/fluentd.sh

remove_pos_file_directory:
  file.absent:
    - name: /var/lib/fluentd

remove_pidfile_directory:
  file.absent:
    - name: /var/run/fluentd

remove_config_directory:
  file.absent:
    - name: /etc/fluent

remove_gem:
  gem.removed:
    - name: fluentd

remove_group:
  group.absent:
    - name: {{ fluentd.group }}

remove_user:
  user.absent:
    - name: {{ fluentd.user }}
