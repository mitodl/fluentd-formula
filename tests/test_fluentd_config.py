def test_config_file(host):
    config = host.file('/etc/fluent/fluent.d/elasticsearch.conf')
    assert config.exists
    assert config.contains('@type syslog')
    assert config.contains('match syslog\.\*')
    assert config.contains('@type elasticsearch')
