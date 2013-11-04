# secretbox
[![Build Status](https://travis-ci.org/evaryont/puppet-secretbox.png?branch=master)](https://travis-ci.org/evaryont/puppet-secretbox)

## Overview

Storing passwords in your puppet manifests is a Bad Idea™. Generating random
values for your passwords is a Good Idea. However, a plain random function will
change every time you run it, quickly breaking things. How can you fix that?

Hopefully, with secretbox, you shouldn't have to worry.

## Setup

Make sure [pluginsync] is enabled, as this is a custom puppet function.
Otherwise, install the module as you would any other and you should be good to
go.

[pluginsync]: http://docs.puppetlabs.com/guides/plugins_in_modules.html#enabling-pluginsync

## Usage

[secretbox] defines a custom "return value" function for puppet, so you can use
it on the right side of any variable assignment, parameter list, if statement,
etc. For example:

    $mysql_root_password = secretbox('mysql_root_password')

Will set the variable `$mysql_root_password` to the value stored associated with
the index "mysql_root_password".

The first time `secretbox(index)` is called on a node that doesn't have a value
for 'index', it will be randomly generated. The random value will be written to
disk. Any subsequent calls to secretbox with the same index will return the
pre-computed value and will not generate a new secret.

Each node has it's own unique "box", and does not share it's indexes or values
with other nodes. All calls to secretbox with the same index on a given node are
guaranteed to return the same value.

## Reference

### secretbox
Requires an index be passed as the first parameter. This index, along with the
node's FQDN will be used to uniquely identify a secret. If the secret doesn't
exist prior to the call, it will be generated. In this instance, secretbox can
accept a second argument, which specifies the length of the randomly generated
value. If the second value is left unspecified, it defaults to 32 characters
long.

The generated value can contain any printable ASCII value (character codes 32
through 126), excluding single quote ('), double quotes ("), forward slash (/)
and hash (#).

Upon generation, the value is saved to a file named the passed index. The file
is stored in a directory named after the FQDN. This directory is then stored
within the 'secretbox' directory, underneath Puppet's 'vardir'. In practice,
a given index has it's value stored in `/var/lib/puppet/secretbox/FQDN/index`.

- *Type*: rvalue

## Limitations

Secretbox does nothing to prevent additional snooping on the files. It's assumed
the directory in which it stores it's files (usually
`/var/lib/puppet/secretbox`) is adequately protected. Default installations of
puppet should be fine, as `/var/lib/puppet` is already protected.

## Development

Pull requests are appreciated. If you do want to contribute to this project,
make sure all tests pass. Also, be kinder rather than meaner.

[secretbox]: https://github.com/evaryont/puppet-secretbox
