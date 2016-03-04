"""Use testinfra and py.test to verify formula works properly"""

def test_ruby_installed(Package):
    assert Package('ruby').is_installed


def test_fluentd_gem_installed(RubyGem):
    assert RubyGem('fluentd').is_installed


def test_control_script_exists(File):
    script = File('/usr/local/bin/fluentd.sh')
    assert script.exists
    assert script.mode == 0o755


def test_service_file_exists(File, Command):
    has_systemd = Command.check_output('which systemctl')
    if has_systemd:
        service_definition = File('/etc/systemd/system/fluentd.service')
    else:
        service_definition = File('/etc/init/fluentd')
    assert service_definition.exists
    assert File('/usr/local/bin/fluentd.sh').exists
    assert File('/usr/local/bin/fluentd.sh').mode == 0o755


def test_fluentd_service(Service):
    assert Service('fluentd').is_running
    assert Service('fluentd').is_enabled


def test_fluentd_config(File):
    assert File('/etc/fluent/fluent.conf').exists
    assert File('/etc/fluent/fluent.conf').contains(r'\@include fluent.d\/\*\.conf')
    assert File('/etc/fluent/fluent.d').is_directory
