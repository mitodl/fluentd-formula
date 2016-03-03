import pytest
import re


@pytest.fixture()
def RubyGem(Command):
    class GemClass():
        def __init__(self, pkg_name, gem_bin=None):
            self.gem_dict = {}
            self.pkg_name = pkg_name
            if gem_bin:
                args = ['%s list', gem_bin]
            else:
                args = ['gem list']
            for line in Command.check_output(*args).split('\n'):
                gem_re = re.compile('^(\w+) \((.*?)\)$')
                if re.match(gem_re, line):
                    name, version = re.search(gem_re, line).groups()
                    self.gem_dict[name] = version

        @property
        def is_installed(self):
            return bool(self.gem_dict.get(self.pkg_name))

        @property
        def version(self, pkg_name):
            return self.gem_dict.get(self.pkg_name)
    return GemClass
