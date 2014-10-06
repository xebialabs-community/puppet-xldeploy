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

For a more comprehensive setup in wich a supported java version is installed and a xldeploy license file is included try the example below.

    class{xldeploy::server:
        install_java                => true,
        install_license             => true,
        install_type                => 'download',
        download_user               => 'foobar',
        download_password           => 'notapassword',
        download_proxy_url          => 'http://some:user@companyproxy.evil.empire:8080'
     }


To install the command line interface (cli) software bundled with xldeploy use the seperate xldeploy::cli class like discribed below. 

    class{xldeploy::cli:
            install_java                => true,
            install_type                => 'netinstall',
            download_user               => 'foobar',
            download_password           => 'notapassword',
            download_proxy_url          => 'http://some:user@companyproxy.evil.empire:8080'
     }


From a potential xldeploy client machine using the module to register a ci in with the xldeploy server. 

  all in one go:

    class{xldeploy::client:
            http_context_root => '/xldeploy',
            http_server_address => 'xldeploy.local.domain',
            http_port           => '4516',
            admin_password      => 'dummy',
            ssl                 => 'false',
            cis                 => { 'project_folder' => { name => "/Infrastructure/projectx",
                                                           type => 'core.Directory',
                                                           remove_when_expired => 'true'},
                                     'host' => { name => "/Infrastructure/projectx/${hostname}_sshHost",
                                                 type => 'overthere.SshHost',
                                                 properties => { 'os' => 'UNIX',
                                                                 'port' => '22',
                                                                 'username' => 'deployit',
                                                                 'tags' => 'projectx' }
                                      }
                                     }
    }
  the above example uses the builtin create_resources construct to create the ci's specified in the array one by one. This construct is especially handy when used in conjunction with automatic data bindings from a Hiera backend.
  
  
  Users are also able to create ci's using the module's types and providers:

    xldeploy_ci{ '/Infrastructure/projectx':
          ensure             => present,
          type               => 'core.Directory',
          rest_url           => 'http://admin:password@xldeploy.domain.local:4516/xldeploy' }
    }
    
    xldeploy_ci{ "/Infrastructure/projectx/${hostname}_sshHost":
          ensure             => present,
          type               => 'overthere.SshHost',
          properties         => { 'os' => 'UNIX',
                                  'port' => '22',
                                  'username' => 'deployit',
                                  'tags' => 'projectx' },
          rest_url           => 'http://admin:password@xldeploy.domain.local:4516/xldeploy' }
    }

  Both class parameters and types and providers are available for defining memberships,users, roles, dictionary_settings and role_permissions wich work in the same way as the above specified method for defining a ci