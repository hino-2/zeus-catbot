$\=$/;
use Time::Piece;

sub pora_analiz {
	opendir DIR, 'analizy';
	my @ls = sort grep { /^[0-9]/ } readdir(DIR); 
	closedir DIR;

	print $date1 = sprintf("%04d-%02d-%02d", $time[5]+1900, $time[4]+1, $time[3]); 
	print $date2 = ( split ( "_", pop @ls ) ) [0];
	
	print ((Time::Piece->strptime(sprintf("%04d-%02d-%02d", $time[5]+1900, $time[4]+1, $time[3]), "%Y-%m-%d") - Time::Piece->strptime( $date2, "%Y-%m-%d"))/86400); 
	
	((Time::Piece->strptime(sprintf("%04d-%02d-%02d", $time[5]+1900, $time[4]+1, $time[3]), "%Y-%m-%d") - Time::Piece->strptime( $date2, "%Y-%m-%d")))/86400 > 60 ? return true : return false;
}

@time = localtime;

print pora_analiz ();


__END__

$\=$/;

$str = '������ �।�।�।��᫥���� �������';
$str =~ /������(.*)�������/i;
opendir DIR, 'analizy';
my @ls = sort grep { /^[0-9]/ } readdir(DIR); 
if (index ($1, '��᫥����') > 0) {
	  $reply = "��� ��$1�ﭠ���� (����� �� ���祡��� ⠩���)";
	  my $num = () = $1 =~ /�।/gi;
	  $photo = 'analizy/'.$ls[ (scalar @ls) - $num - 1 ];
} else {
	  $reply = "�� ����� ".(scalar @ls)." ��� �ﭠ�����. ��� �������� ��᫥����, ��� �।��᫥����, ��� �।�।��᫥����, ��� ... �ﭠ����.";
}
closedir DIR;

print for @ls;

print "$reply, $photo ".((scalar @ls) - $num - 1);





__END__
opendir DIR, 'analizy';
@ls = sort grep { /^[0-9]/ } readdir(DIR);
print join " ", sort @ls;

__END__
#print 41%2;

#print for @ls;
$str = '������ �।�।�।�।��᫥���� �������';
$str =~ /������(.*)�������/i;
if (index ($1, '��᫥����') > 0) {
     
      print $n = () = $1 =~ /�।/g;
}



$q = int rand(2);
if ($q == 1) {
	print "ok $q";
} else
{print "ne ok $q";}


use feature 'say';

$str = '��।��: 111';
my ($reply) = (split /: /, $str)[1];
say $reply;

    my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
    my ($username, $real_name) = (split /:/, $str)[0, 4];
    print "$username\n";
    print "$real_name\n";
