use strict;
use warnings;

use inc::Module::Install;

name            'Debug-Smart';
all_from        'lib/Debug/Smart.pm';

requires        'Carp'              => 0;
requires        'YAML'              => 0;
build_requires  'Test::More'        => 0;

auto_install;
WriteAll;
