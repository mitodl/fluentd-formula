fluentd formula
===============

20191107 (2019-11-07)
---------------------
- Upgrade to recent FluentD and Ruby versions (see https://github.com/mitodl/fluentd-formula/pull/11)
- Create directory for position (.pos) files

201809 (2018-09-04)
-------------------

- Fixed path to service definitions
- Update fluentd.service
- Moved import outside for loop
- Fixed path for systemd unit file template
- Fixed unpaired closing conditional tag
- Fixed keys in context based on feedback
- Templatized user/group in service conf and added recurse setting on newly created folders
- Added the creation of a fluentd user and group.
- Refactored init file.
- Removed Ubuntu 12 code.
- Added the creation of some folders to be used for file buffering.
- Replaced git_plugin code because it doesn't work with http_plugins
- Added option to install plugins from github
- Merge pull request #8 from mitodl/sar/bugfix
- Removed conf.sls file in response to issue#7. Functionality of that file is already included in the init file or one can use config.sls to update the config
- Updated Nginx config to use IPv6 localhost address
- Fix stop command for systemd.

201702 (2017-02-10)
-------------------

- Exposed a version attribute in the map.jinja so that the version of FluentD can be overridden via Pillar

201602 (2016-03-03)
-------------------

- First release
