use strict;
use warnings;
use Test::More tests => 10;
use CGI;
BEGIN {
    use_ok( 'CGI::remote_addr' );
}

###############################################################################
### Clear our environment; we'll set it up locally as needed.
###############################################################################
delete $ENV{HTTP_X_FORWARDED_FOR};
delete $ENV{REMOTE_ADDR};

###############################################################################
# Return empty handed if NO IP information available
empty_handed_if_no_ip_available: {
    my $cgi = CGI->new('');
    my $ip  = $cgi->remote_addr();
    ok !defined $ip, 'undef if no IP available';
}

###############################################################################
# Return IP from REMOTE_ADDR if that's all we've got
remote_addr: {
    local $ENV{REMOTE_ADDR} = '127.0.0.1';
    my $cgi = CGI->new('');
    my $ip  = $cgi->remote_addr();
    is $ip, '127.0.0.1', 'use REMOTE_ADDR if available';
}

###############################################################################
# Prefer IP from HTTP_X_FORWARDED_FOR if available
http_x_forwarded_for: {
    local $ENV{REMOTE_ADDR} = '127.0.0.1';
    local $ENV{HTTP_X_FORWARDED_FOR} = '192.168.0.1';
    my $cgi = CGI->new('');
    my $ip  = $cgi->remote_addr();
    is $ip, '192.168.0.1', 'prefer HTTP_X_FORWARDED_FOR if available';
}

###############################################################################
# Only return valid IPs
only_valid_ips: {
    local $ENV{HTTP_X_FORWARDED_FOR} = '<unknown>, 127.0.0.1';
    my $cgi = CGI->new('');
    my $ip  = $cgi->remote_addr();
    is $ip, '127.0.0.1', 'only valid IPs returned';
}

###############################################################################
# Return in scalar context
scalar_context: {
    local $ENV{REMOTE_ADDR} = '127.0.0.1';
    local $ENV{HTTP_X_FORWARDED_FOR} = '192.168.0.1';
    my $cgi = CGI->new('');
    my $ip  = $cgi->remote_addr();
    is $ip, '192.168.0.1', 'scalar context';
}

###############################################################################
# Return in list context
list_context: {
    local $ENV{REMOTE_ADDR} = '127.0.0.1';
    local $ENV{HTTP_X_FORWARDED_FOR} = '192.168.0.1';
    my $cgi = CGI->new('');
    my @ips = $cgi->remote_addr();
    is scalar @ips, 2, 'list context contains 2 entries';
    is $ips[0], '192.168.0.1', '... HTTP_X_FORWARDED_FOR is first';
    is $ips[1], '127.0.0.1',   '... REMOTE_ADDR is second';
}

###############################################################################
# List context is unique
list_context_is_unique: {
    local $ENV{REMOTE_ADDR} = '127.0.0.1';
    local $ENV{HTTP_X_FORWARDED_FOR} = '192.168.0.1, 127.0.0.1';
    my $cgi = CGI->new('');
    my @ips = $cgi->remote_addr();
    is scalar @ips, 2, 'list context contains 2 unique entries';
}
