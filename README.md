puppet-xldeploy
===============

####Table of Contents

1. [Overview](#overview)

2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet-xldeploy](#setup)
    * [What puppet-xldeploy affects](#what-puppet-xldeploy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet-xldeploy](#beginning-with-puppet-xldeploy)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

overview
--------
The Xldeploy module enables you to install and manage large XL Deploy enabled infrastructures.

module-description
------------------
XL Deploy is a kick-ass modular platform independant software deployment system. This module enables you to tie this deployment software into your puppet environment. It can take care of installing XL Deploy servers as well as integrate middleware components eslewhere in your infrastructure.

setup
-----
**what-puppet-xldeploy-affects:**

* installation/service/configuration files for XL Deploy
* listened-to ports
* backend storage filesystem/database
* xldeploy housekeeping
* xldeploy repository configuration items
* xldeploy repository roles/permissions
* xldeploy repository dictionaries
* xldeploy cli installation 
* installs compatible java version (optional)

**setup-requirements**

* This module makes use of exported resources (optional) if you descide to use this functionallity please configure this in your puppet.conf file on the master.
* This module makes use of the puppetdbquery module to distribute sshkeys across the infrastructure (optional). This functionality depends on puppetdb.


**beginning-with-puppet-xldeploy**

Basic usage when installing a xldeploy server

    class{xldeploy::server:}

For a more comprehensive setup

    class{xldeploy::server
        install_java                => true,
        install_license             => true,
        install_type                => 'netinstall'
        download_user               => 'foobar',
        download_password           => 'notapassword'
        download_proxy_url          => 'http://some:user@companyproxy.evil.empire:8080'
     }
