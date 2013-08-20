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
$dbh = DBI->connect($connectionInfo,$userid,$passwd) or die $DBI::errstr;

@clients = get_clients($dbh);

# prepare and execute  times query
$query = "SELECT * FROM times WHERE clocked_in=1 AND employee='$ENV{REMOTE_USER}'";
$sth = $dbh->prepare($query);
$sth->execute();

# assign fields to variables
$sth->bind_columns(\$id, \$client_id, \$intime, \$outtime, \$clocked_in, \$comment, \$employee);

# output name list to the browser
while($sth->fetch()) {
	if ($clocked_in && $employee eq $ENV{REMOTE_USER}) {
		print "<li id='tid-$id'>$clients[$client_id]<br/><small>$intime</small><div style='display:none;'><teaxtarea/><button/></div></li>";
		}
	}

sub get_clients { my $dbh = @_[0];
	my $query = "SELECT * FROM clients";
	my $sth = $dbh->prepare($query);
	$sth->execute();
	$sth->bind_columns(\$id, \$name, \$domain);
	
	my @clients;
	while($sth->fetch()) {
		@clients[$id] = $name;
		}
	$sth->finish();
	return @clients;
}
