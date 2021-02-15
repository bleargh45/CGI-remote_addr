# NAME

CGI::remote\_addr - Enhanced version of CGI.pm's "remote\_addr()"

# SYNOPSIS

```perl
use CGI;
use CGI::remote_addr;

my $cgi  = CGI->new();
my $addr = $cgi->remote_addr();
```

# DESCRIPTION

`CGI::remote_addr` implements an enhanced version of the `remote_addr()`
method provided by `CGI.pm`, which attempts to return the original IP address
that the connection originated from (which is not necessarily the IP address
that we received the connection from).

Simply loading `CGI::remote_addr` causes it to over-ride the existing
`remote_addr()` method.  Do note, though, that this is a global over-ride; if
you're running under mod\_perl you've just over-ridden it for **all** of your
applications.

## Differences from CGI.pm

- We check not only `$ENV{REMOTE_ADDR}` to find the IP address, but also look in
`$ENV{HTTP_X_FORWARDED_FOR}` to find the IP address.  If
`$ENV{HTTP_X_FORWARDED_FOR}` is defined, we try that first.
- Only valid IP addresses are returned, regardless of whatever exists in
`$ENV{REMOTE_ADDR}` or `$ENV{HTTP_X_FORWARDED_FOR}`.  I've seen lots of cases
where the values for `$ENV{HTTP_X_FORWARDED_FOR}` were stuffed with garbage,
and we make sure that you only get a real IP back.
- We return IPs in both a scalar and a list context.  In scalar context you get
the first (originating) IP address.  In list context you get a unique list of
all of the IPs that the connection was received through.
- In the event that we cannot find a valid IP address, this method returns
`undef`, **NOT** 127.0.0.1 (like `CGI.pm` does).

# METHODS

- **remote\_addr()**

    Returns the IP address(es) of the remote host.

# AUTHOR

Graham TerMarsch (cpan@howlingfrog.com)

# COPYRIGHT

Copyright (C) 2008 Graham TerMarsch.  All Rights Reserved.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# SEE ALSO

- [CGI](https://metacpan.org/pod/CGI)
