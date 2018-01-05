# Ccsh

[![Build Status](https://travis-ci.org/raffs/ccsh.svg?branch=master)](https://travis-ci.org/raffs/ccsh)


ccsh is an interactive shell console connected into multiple servers, the intent
of this interface is to simplify the need to run very simple task on the
machine instances.

ccsh will read the servers from the **host** file and create an interactive shell
for running commands on all selected servers

Project Information:
* **Status:** Development
* **Author:** Rafael Oliveira Silva
* **Blog:** [raffs.com.br](https://raffs.com.br/)

## Setup

### Requirements

* Ruby
* Rubygem

#### Installation

Install the ccsh gem
```sh
gem install ccsh
```

#### Create host file

By default the ccsh command will load the file from ```~/.cssh/host.yaml```. The file path could change using the
```ccsh -h path/to/HOSTFILE``` command.

```yaml
---
# Example: hosts_exa01.yaml
#
# Default example from the ccsh connections
version: 1.0

# define default settings for each defined host
defaults:
  port: 22
  user: user
  password: password
  private_key: ~/.ssh/id_rsa
  ssh_options:
    timeout: 720
    host_key: 'ssh-rsa'

# list of host file
hosts:

  - name: Node 01
    hostname: node01.example.com
    groups:
      - production
      - webserver

  - name: Node 02
    hostname: node02.example.com
    groups:
      - production
      - dbserver
```

### Start the console

Start the ccsh console and server group name such as ```all``` or ```webserver```
```sh
$ ccsh webserver

ccsh> hostname
```

## Contributing

* [Github Issues](https://github.com/raffs/ccsh/issues)
* [Pull Requests](https://github.com/raffs/ccsh/pulls)

### Testing

To run the rspec spec run:
```sh
rake spec
```

### Build

To build the ccsh gem package run:
```sh
gem build ccsh.gemspec
```

### Installing local gem

To install the generated gem package run:
```sh
gem install_local gem-VERSION.gem
```

Optionally you can run the *build* and *install locally* with the `rake deploy_local`

### Process

* **Fork** the repository
* Create a **branch** following the pattern: feature/<FEATURE_SHORT_DESCRIPTION>
	* Implement the new feature
	* Add spec test for each implemented task/feature/function
* Create the **Pull Request**
