{% from "fluentd/map.jinja" import fluentd, fluentd_service with context %}

{% if salt['pillar.get']('fluentd:use_gem', False) %}
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

fluentd_control_script:
  file.managed:
    - name: /usr/local/bin/fluentd.sh
    - source: salt://fluentd/files/fluentd.sh
    - mode: 0755

configure_fluentd_service:
  file.managed:
    - name: {{ fluentd_service.destination_path }}
    - source: salt://fluentd/files/{{ fluentd_service.source_path }}

{% else  %}
fluentd-repo:
  pkgrepo.managed:
    - humanname: Fluentd Repository
{% if grains['os_family'] == 'Debian' %}
    - name: deb http://packages.treasuredata.com/2/{{ grains['os'].lower() }}/{{ grains['oscodename'] }}/ {{ grains['oscodename'] }} contrib
    - file: /etc/apt/sources.list.d/fluentd.list
    - key_url: https://packages.treasuredata.com/GPG-KEY-td-agent
{% elif grains['os_family'] == 'RedHat' %}
    - baseurl: http://packages.treasuredata.com/2/redhat/{{ grains['osrelease'] }}/{{ grains['cpuarch'] }}
    - gpgcheck: 1
    - gpgkey: https://packages.treasuredata.com/GPG-KEY-td-agent
{% endif %}

install-fluentd:
  pkg.installed:
    - name: td-agent
    - require:
      - pkgrepo: fluentd-repo
{% endif %}

make_fluent_config_directory:
  file.directory:
    - name: {{ fluentd.conf_dir }}
    - makedirs: True 
    - require:
{% if salt['pillar.get']('fluentd:use_gem', False) %}
      - gem: install_fluentd_gem
{% else %}
      - pkg: install-fluentd
{% endif %}
