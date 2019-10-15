import pytest

"""Use testinfra and py.test to verify formula works properly"""

def test_ruby_installed(host):
    pkg = host.package('ruby')
    assert pkg.is_installed


def test_fluentd_gem_installed(RubyGem):
    assert RubyGem('fluentd').is_installed


def test_control_script_exists(host):
    script = host.file('/usr/local/bin/fluentd.sh')
    assert script.exists
    assert script.mode == 0o755


def test_service_file_exists(host):
    has_systemd = host.run_expect([0], 'which systemctl')
    if has_systemd:
        service_definition = host.file('/etc/systemd/system/fluentd.service')
    else:
        service_definition = host.file('/etc/init/fluentd.conf')
    assert service_definition.exists
    assert host.file('/usr/local/bin/fluentd.sh').exists
    assert host.file('/usr/local/bin/fluentd.sh').mode == 0o755


def test_fluentd_service(host):
    assert host.service('fluentd').is_running
    assert host.service('fluentd').is_enabled


def test_fluentd_config(host):
    assert host.file('/etc/fluent/fluent.conf').exists
    assert host.file('/etc/fluent/fluent.conf').contains(r'\@include fluent.d\/\*\.conf')
    assert host.file('/etc/fluent/fluent.d').is_directory
