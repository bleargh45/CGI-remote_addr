use strict;
use warnings;
use Module::Build;

Module::Build->new(
    'module_name'       => 'CGI::remote_addr',
    'dist_author'       => 'Graham TerMarsch (cpan@howlingfrog.com)',
    'license'           => 'perl',
    'create_makefile_pl'=> 'traditional',
    'requires'              => {
        'CGI'                   => 0,
        'Regexp::Common'        => 0,
        'List::MoreUtils'       => 0,
        },
    'build_requires'        => {
        'Test::More'            => 0,
        },
    )->create_build_script();
