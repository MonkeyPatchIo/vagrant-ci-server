# Vagrant CI Server

This project demonstrates the provisioning of [TeamCity Server](https://www.jetbrains.com/teamcity) with Vagrant 2.0 using Ansible.

It relies on the following Ansible Galaxy roles
- [ansiblebit.oracle-java](https://galaxy.ansible.com/ansiblebit/oracle-java)
- [matisku.teamcity-server](https://galaxy.ansible.com/matisku/teamcity-server)
- [jdauphant.nginx](https://galaxy.ansible.com/jdauphant/nginx)

A basic integration test harness is execued with [test-kitchen](https://github.com/test-kitchen/test-kitchen) and [kitchen-ansible](https://github.com/neillturner/kitchen-ansible)

## Getting Started

### Install Dependencies
On your local machine, you need to have the following components installed
- [Vagrant 2.0](https://www.vagrantup.com/downloads.html)
- [VirtualBox 5.2](https://www.virtualbox.org/wiki/Downloads)
- [Ansible 2.x](http://docs.ansible.com/ansible/latest/intro_installation.html)

This has been tested with
- Vagrant 2.0.2
- VirtualBox 5.2.8
- Ansible 2.3.2.0

### Run Vagrant
To provision the CI server, run the following command:
```
$ vagrant up

# Log extract
Bringing machine 'ee-ci-server' up with 'virtualbox' provider...
==> ee-ci-server: Importing base box 'ubuntu/xenial64'...
...
==> ee-ci-server: Running 'pre-boot' VM customizations...
==> ee-ci-server: Booting VM...
==> ee-ci-server: Waiting for machine to boot. This may take a few minutes...
...
==> ee-ci-server: Running provisioner: ansible...
...
PLAY RECAP *********************************************************************
ee-ci-server               : ok=55   changed=26   unreachable=0    failed=0
```

Your TeamCity Server will then be available on [http://localhost:6080](http://localhost:6080)

## Integration Testing
Server provisioning testing is achieved using [test-kitchen](https://github.com/test-kitchen/test-kitchen) and [kitchen-ansible](https://github.com/neillturner/kitchen-ansible)

The `test-kitchen` configuration file `.kitchen.yml` defines the provisioning engine, targeted platforms and test suites.

Assuming you already have ruby and bundler installed locally, run the following commands:
```
# Install gem dependencies
$ bundle install

# Show all available tests
$ bundle exec kitchen list
Instance             Driver   Provisioner      Verifier  Transport  Last Action    Last Error
default-centos-71    Vagrant  AnsiblePlaybook  Inspec    Ssh        <Not Created>  <None>
default-ubuntu-1404  Vagrant  AnsiblePlaybook  Inspec    Ssh        <Not Created>  <None>
default-ubuntu-1604  Vagrant  AnsiblePlaybook  Inspec    Ssh        <Not Created>  <None>
default-ubuntu-1804  Vagrant  AnsiblePlaybook  Inspec    Ssh        <Not Created>  <None>

# Then you can run the test suite against a specific configuration
$ bundle exec kitchen test default-ubuntu-1604

# Log extract
-----> Starting Kitchen (v1.20.0)
-----> Cleaning up any prior instances of <default-ubuntu-1604>
-----> Destroying <default-ubuntu-1604>...
       Finished destroying <default-ubuntu-1604> (0m0.00s).
-----> Testing <default-ubuntu-1604>
-----> Creating <default-ubuntu-1604>...
       Bringing machine 'default' up with 'virtualbox' provider...
       ==> default: Importing base box 'bento/ubuntu-16.04'...
...
Profile: tests from {.../test/integration/default"} (tests from {:path=>"...ee-ci-server.test.integration.default"})
Version: (not specified)
Target:  ssh://vagrant@127.0.0.1:2201


  ✔  02: Verify teamcity-server service
     ✔  Service teamcity-server should be enabled
     ✔  Service teamcity-server should be installed
     ✔  Service teamcity-server should be running
     ✔  Port 8111 should be listening
     ✔  Port 8111 protocols should include "tcp"
  ✔  01: Verify nginx service
     ✔  Service nginx should be enabled
     ✔  Service nginx should be installed
     ✔  Service nginx should be running
     ✔  Port 80 should be listening
     ✔  Port 80 protocols should include "tcp"

  System Package cowsay
     ✔  should be installed
  System Package nginx
     ✔  should be installed
  User www-data
     ✔  should exist

Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
...
-----> Kitchen is finished. (37m3.50s)
```

Default test suite defined under `test/integration/default` runs the full installation process `test-kitchen` to coordinate system provisioning and validation and `kitchen-ansible` as the provisioning engine.

## Techincal Details

### Vagrant Configuration
You can change the Vagrant VM configuration by updating the `Vagrant` file:
- port (default: 6080)
- memory (a minimum of 2GB required for TeamCity)
- cpus

### Vagrant Provisioning
The provisioning takes advantage of the [Ansible provisioning](https://www.vagrantup.com/docs/provisioning/ansible.html).

### Ansible Roles
The following public Ansible roles are executed on the Vagrant VM during provisioning phase:
- `ansiblebit.oracle-java`: Java JDK Installation
- `matisku.teamcity-server`: TeamCity Server Installation
- `jdauphant.nginx`: Nginx webserver Installation

### Ansible Configuration
The settings file `ansible/vars/main.yml` can be updated to match your TeamCity server configuration needs:
- Version to install (default to 2017.2.2)
- Plugins to install

### Using different CI Server
Switching to a different CI Server such as Jenkins or GoCD is as easy as swapping the Ansible Galaxy roles.
You may prefer use these CI Servers:
- [Jenkins](https://galaxy.ansible.com/geerlingguy/jenkins)
- [GoCD](https://galaxy.ansible.com/ansible-city/gocd_server)

## About MonkeyPatch
We are a team of It experts. We are specialised in cloud, mobile and database.
[MonkeyPatch](http://www.monkeypatch.io/en)
![monkeypatch](mkp.png)
