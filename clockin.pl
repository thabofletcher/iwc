#!/usr/bin/perl
use DBI;

# comment out when done debugging
BEGIN { $SIG{'__DIE__'} = sub { print <<__WARN__ and exit 1 } }
Fatal Error in @{[(caller(2))[1]||__FILE__]} at ${\ scalar localtime }
while responding to request from ${\ $ENV{'REMOTE_ADDR'} || 'localhost
+' }
${\ join("\n",$!,$@,@_) }
__WARN__

print "Content-type: text/html\n\n";

# database information
$db="";
$host="localhost";
$userid="";
$passwd="";
$connectionInfo="dbi:mysql:$db;$host";

# make connection to database
%query_vars = parse_query_string();
$dbh = DBI->connect($connectionInfo,$userid,$passwd) or die $DBI::errstr;
$client_id=$query_vars{"cid"};
if (!$dbh->do("INSERT INTO times (time_id,FK_client_id,intime,outtime,comment,clocked_in,employee) VALUES (NULL, '$client_id', NOW(),NULL,'','1','$ENV{REMOTE_USER}');")) {
	print "Failure";
	}

sub parse_query_string {
	my %queryString = ();
	my $env_query = $ENV{ "QUERY_STRING" };
	@parts = split(/\&/,$env_query);
	foreach $part (@parts) {
		($name, $value) = split(/\=/, $part);
		$queryString{"$name"} = $value;
		}		
	return %queryString;	
	}
