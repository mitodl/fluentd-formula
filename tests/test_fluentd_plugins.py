def test_dependencies_installed(Package):
    assert Package('libpq-dev').is_installed


def test_plugins_installed(RubyGem):
    assert RubyGem('fluent-plugin-elasticsearch').is_installed
    assert RubyGem('fluent-plugin-postgres').is_installed
