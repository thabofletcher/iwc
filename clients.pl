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

# output name list to the browser
$clients_length=@clients;
for($i=1; $i<$clients_length; $i++) { #?cid=$i
	unless ($clients[$i] eq "") {
		print "<li id='cid-$i'>$clients[$i]</li>";
		}
	}

sub get_clients { my $dbh = @_[0];
	my $query = "SELECT client_id, client_name FROM clients WHERE client_id NOT IN (SELECT clients.client_id FROM clients INNER JOIN times ON clients.client_id=times.FK_client_id AND times.clocked_in=1 AND times.employee='$ENV{REMOTE_USER}' GROUP BY clients.client_id)";
	my $sth = $dbh->prepare($query);
	$sth->execute();
	$sth->bind_columns(\$id, \$name);
	
	my @clients;
	while($sth->fetch()) {
		@clients[$id] = $name;
		}
	$sth->finish();
	return @clients;
}
