def test_dependencies_installed(host):
    assert (host.package('libpq-dev').is_installed or
            host.package('libpqxx-devel').is_installed)


def test_plugins_installed(RubyGem):
    assert RubyGem('fluent-plugin-elasticsearch').is_installed
    assert RubyGem('fluent-plugin-postgres').is_installed
