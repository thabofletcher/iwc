#!/usr/bin/perl



# comment out when done debugging
BEGIN { $SIG{'__DIE__'} = sub { print <<__WARN__ and exit 1 } }
Fatal Error in @{[(caller(2))[1]||__FILE__]} at ${\ scalar localtime }
while responding to request from ${\ $ENV{'REMOTE_ADDR'} || 'localhost
+' }
${\ join("\n",$!,$@,@_) }
__WARN__

$url = '../clock.pl';

print "Status: 302 Moved\nLocation: $url\n\n";
