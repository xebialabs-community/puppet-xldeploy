puppet-xldeploy
===============

####Table of Contents

1. [License](#license)

2. [Overview](#overview)

3. [Module Description - What the module does and why it is useful](#module-description)
4. [Setup - The basics of getting started with puppet-xldeploy](#setup)
    * [What puppet-xldeploy affects](#what-puppet-xldeploy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet-xldeploy](#beginning-with-puppet-xldeploy)
5. [Usage - Configuration options and additional functionality](#usage)
6. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Guide for contributing to the module](#development)

license
-------
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS 
FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.

overview
--------
The xldeploy module enables you to install and manage large XL Deploy enabled infrastructures.

module-description
------------------
XL Deploy is a kick-ass modular platform independant software deployment system. This module enables you to tie this deployment software into your puppet environment. It can take care of installing XL Deploy servers as well as integrate middleware components elsewhere in your infrastructure.

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

    class{xldeploy::server:
        install_java                => true,
        install_license             => true,
        install_type                => 'download',
        download_user               => 'foobar',
        download_password           => 'notapassword',
        download_proxy_url          => 'http://some:user@companyproxy.evil.empire:8080'
     }

Installing the cli

    class{xldeploy::cli:
            install_java                => true,
            install_type                => 'netinstall',
            download_user               => 'foobar',
            download_password           => 'notapassword',
            download_proxy_url          => 'http://some:user@companyproxy.evil.empire:8080'
     }

