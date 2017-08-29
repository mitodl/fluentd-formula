=======
fluentd
=======

SaltStack formula for installing and configuring FluentD

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Available states
================

.. contents::
    :local:

``fluentd``
-----------

Install the FluentD service for shipping and aggregating logs and other data.

``fluentd.plugins``
-------------------

Install plugins for extending FluentD based on pillar data

``fluentd.reverse_proxy``
-------------------------

Install and configure an Nginx HTTPS reverse proxy for encrypting traffic to HTTP based endpoints


Template
========

This formula was created from a cookiecutter template.

See https://github.com/mitodl/saltstack-formula-cookiecutter.
