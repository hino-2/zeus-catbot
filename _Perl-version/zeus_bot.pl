#!/usr/bin/perl

# src UTF8
# cpan -fi WWW::Telegram::BotAPI Mojo::UserAgent IO::Socket::SSL Term::ReadKey
# 
# in case of stupid linux shit again:
# export HTTPS_PROXY=http://login:pass@proxy.neyvabank.ru:3128
#

use strict;
use utf8;
use constant true => 1;
use constant false => 0; 
use autodie;
use feature "switch";
use experimental qw( switch );
use WWW::Telegram::BotAPI;
use Time::Piece;
use Term::ReadKey;
use feature 'say';

my @updates = (); 
my $natasha = 229793471;
my $hozyain = 407927900;
my $timeoflastmessage = time();
my $interval = 432000 + int(rand(172800));
my @time = localtime;
my $isFighting = 0; # на случай ссоры с женой
my $api = WWW::Telegram::BotAPI->new(
	# токен бота
	token => '*'
);
my $reply;
my @replies = ('Мяу', 'Мур', 'Муур', 'Мууур', 'Муурр', 'Муррр', 'Мурмяу', 'Пф', 'Ме', 'Миу', 'Мееу', 
                       'Муа', 'Апчхи', 'Фуррр', 'Ммууууууррррмяяяяу', 'Мяу?', 'Мяу!', 'Мявк', 'Мявк!', 'Есть хочу');
my $photo;              
my $action;
my $doc;

Term::ReadKey::ReadMode('noecho');
print "ushakov.i.s's proxy password: ";
my $password = Term::ReadKey::ReadLine(0);
Term::ReadKey::ReadMode('restore');
print "\n";
$password =~ s/\R\z//;

my $ua = $api->agent;
my $proxy = $ua->proxy;
$ua = $ua->proxy(Mojo::UserAgent::Proxy->new);
$ua->proxy->https('http://ushakov.i.s:'.$password.'@proxy.neyvabank.ru:3128');
binmode STDOUT, ":utf8";

sub sendPhoto {
	my $photo_id = shift;
	my $chat_id = shift;
	unless ( eval {
		if ($photo_id =~ /^http/) {
			$api->SendPhoto(
				{
					chat_id => $chat_id,
					photo => $photo_id
				}
			);
		} else {
			$api->SendPhoto(
				{
					chat_id => $chat_id,
					photo => { file => $photo_id }
				}
			);
		}; 
	} ) {};
}

sub sendDocument {
	my $doc_id = shift;
	my $chat_id = shift;
	unless ( eval {
		if ($doc_id =~ /^http/) {
			$api->SendDocument(
				{
					chat_id => $chat_id,
					document => $doc_id
				}
			);
		} else {
			$api->SendDocument(
				{
					chat_id => $chat_id,
					document => { file => $doc_id }
				}
			);
		}; 
	} ) {};
}

sub sendMessage {
	my $text = shift;
	my $user = shift;
	unless ( eval {
		$api->SendMessage( {
			chat_id => $user,
			text => $text
		} );
	} ) {};
}

sub pora_analizy {
	opendir DIR, 'analizy';
	my @ls = sort grep { /^[0-9]/ } readdir(DIR); 
	closedir DIR;

	#my $date1 = sprintf("%04d-%02d-%02d", $time[5]+1900, $time[4]+1, $time[3]); 
	my $date2 = ( split ( "_", pop @ls ) ) [0];

	((Time::Piece->strptime(sprintf("%04d-%02d-%02d", $time[5]+1900, $time[4]+1, $time[3]), "%Y-%m-%d") - Time::Piece->strptime( $date2, "%Y-%m-%d")))/86400 > 30 ? return true : return false;
}

sub downloadFile {

}

chdir "$ENV{HOME}/progs/telegram-bot";
print "Began myan at ".sprintf("%04d-%02d-%02d %02d:%02d:%02d \n", $time[5]+1900, $time[4]+1, $time[3], $time[2], $time[1], $time[0]);
# включаем бесконечный цикл и погнали обрабатывать

# Natalia Ushakova : ushakova13 : 229793471 
# Игорь : hino_2 : 407927900 

while (1) {
	@time = localtime;
	$photo = '';
	$doc = '';
	$reply = $replies[int(rand(scalar @replies))];

	# пытаемся получить очередь
	unless ( eval { @updates = $api->getUpdates()->{result} } ) { #print sprintf("%02d:%02d:%02d ", $time[2], $time[1], $time[0])." $@\n"; 
												sleep(1); next; }
	
	# когда сам решил мяукнуть
	if (time() - $timeoflastmessage > $interval) {
		#if ($time[2] < 23 and $time[2] > 9) { 					# режим тишины
			# А вдруг захочет есть ?!
			if (int rand(3) == 1) {
				$reply = 'МЯУ!'; sendPhoto('https://pp.userapi.com/c621515/v621515877/e6a5/JYpGfWh5Jew.jpg', $natasha);
			}
			sendMessage ($reply, $natasha); 
			say sprintf("> %04d-%02d-%02d %02d:%02d:%02d ", $time[5]+1900, $time[4]+1, $time[3], $time[2], $time[1], $time[0])."Zeus : ".$reply;
		#};
		$timeoflastmessage = time();
		$interval = 432000 + int(rand(172800));
	}
	
	#say "$time[2] $time[1] ".pora_analiz();
	#if ($time[2] eq 17 and $time[1] eq 32 and pora_analizy ()) { sendMessage("analizy", $hozyain); }
	
	if (scalar @{($updates[0])} == 0) { sleep(1); next; } # если в очереди ничего нет, делаем задержку на 1 секунду и начинаем все сначала
	
	my $updateid;
	# если в очереди что-то есть начинаем обрабатывать этот массив
	for ( my $i = 0 ; $i < scalar @{ ( $updates[0] ) } ; $i++ ) {
		# просто всем шлем ответ 
		# logging message to STDOUT
		$photo = '';
		$doc = '';
		$reply = $replies[int(rand(scalar @replies))];

		say sprintf("%04d-%02d-%02d %02d:%02d:%02d ", $time[5]+1900, $time[4]+1, $time[3], $time[2], $time[1], $time[0]).$updates[0][$i]{message}{from}{first_name}." : "
				.$updates[0][$i]{message}{from}{username}." : ".$updates[0][$i]{message}{from}{id}." : ".$updates[0][$i]{message}{text};
		
		
		my $_user = $updates[0][$i]{message}{from}{id};
		if ($isFighting and $updates[0][$i]{message}{from}{id} == $natasha) { $reply = 'Я с тобой не разговариваю'; } # на случай ссоры с женой
		else {
		    for ($updates[0][$i]{message}{text}) {
			    when (/передай:/i) { $reply = (split /:/, $updates[0][$i]{message}{text})[1]; $_user = $natasha; }
			    when (/поссорился с женой/i) { if ($updates[0][$i]{message}{from}{id} == $hozyain) { $isFighting = 1; $reply = 'Я на твоей стороне, хозяин! =^.^= !!'; } }
			    when (/помирился с женой/i) { if ($updates[0][$i]{message}{from}{id} == $hozyain) { $isFighting = 0; $reply = 'Я тоже по ней соскучился мяу (('; } }
			    when (/красив|красав/i) { $reply = 'Ммррррррррррррр!'; $photo = 'https://pp.userapi.com/c621515/v621515627/11c66/GWartgn0HEI.jpg'; }
			    when (/привет|здравс|здраст/i) { $reply = 'Ну привет'; $photo = 'https://pp.userapi.com/c621515/v621515627/11c6f/YTQ9NOBOxwk.jpg'; }
			    when (/пират|pirat/i) { $reply = 'Йарр!!'; $photo = '/var/home/ushakov.i.s/progs/telegram-bot/pirat.png'; }
			    when (/выключ|прослед/i) { $reply = 'Мя прослежу.'; }
			    when (/позвонить ветеринару/i) { $reply = 'Вот телемяфон: Ника +7 (343) 210–43–46 или Ветпульс +7 (343) 200–08–04'; }
			    when (/команды|что (|ты )умеешь/i) { $reply = "1. позвонить ветеринару - телефон спасения котиков\n2. покажи [пред[пред[пред[пред[пред[...]]]]]последние анализы - котик помнит все свои анализы и с радостью поделится этой информацией"; }
			    when (/покажи(.*)(а|мя)нализ(|ы|ов)/i) { 
				    if ($updates[0][$i]{message}{from}{id} == $hozyain or $updates[0][$i]{message}{from}{id} == $natasha) {             # врачебные тайны только тем, кто кормит
					    opendir DIR, 'analizy';
					    my @ls = sort grep { /^[0-9]/ } readdir(DIR); 
					    closedir DIR;
					    $a = $1;
					    for ($a) {
						    when (/список/i) {
							      $reply = join "\n", @ls;
						    }
						    when (/последние/i) {
							      $reply = "Вот мяи".$a."мянализы (тшшшш это вмячебная таймня)";
							      my $num = () = $a =~ /пред/gi;
							      if ($ls[ (scalar @ls) - $num - 1 ] =~ /pdf|doc|odt/) { $doc = 'analizy/'.$ls[ (scalar @ls) - $num - 1 ]; } 
							      else 								     { $photo = 'analizy/'.$ls[ (scalar @ls) - $num - 1 ]; }
						    } 
						    default { $reply = "Мя помню ".(scalar @ls)." штук мянализов. Мягу показать последние, или предпоследние, или предпредпоследние, или ... мянализы.";  } 
					   }
				    } else { $reply = "Тебе не покажу! ТАЙМНЯЯЯЯЯЯ!!!! ШШШШШШШШШШШ!";  }
			    }
			    when (/c\/d|мкб|мочекамен/i) { $reply = 'Это мой любимый c/d, ОМГ !!! https://www.petshop.ru/catalog/cats/syxkor/vzroslye_1_6let/c_d_dlya_koshek_profilaktika_mkb_okean_ryba_1089/'; }
			    when (/k\/d|почек|почеч|почки/i) { $reply = 'Это мой любимый k/d, ОМГ !!! https://www.petshop.ru/catalog/cats/syxkor/vzroslye_1_6let/k_d_dlya_koshek_lechenie_pochek_serdca_i_nizhnego_otdel_mochevyvod_putey_1094/'; }
			    when (/еда|есть|куша|корм|жрат/i) { $reply = 'МЯУ!'; $photo = 'https://pp.userapi.com/c621515/v621515877/e6a5/JYpGfWh5Jew.jpg'; }
			    when ('') { $reply = 'no text'; if ($updates[0][$i]{message}{document}{file_id} ne '') { $api->getFile( { file_id => $updates[0][$i]{message}{document}{file_id} } ); } }
			    
			    default { $reply = $replies[int(rand(scalar @replies))];
		                          $photo = '';  
		                          $doc = ''; }
		    } 
		}

		if ( $reply  ne '' ) { sendMessage ($reply, $_user); };
		if ( $photo ne '' ) { sendPhoto     ($photo, $_user); };
		if ( $doc ne '' )   { sendDocument ($doc, $_user); };
		
		$updateid = ( $updates[0][$i]->{update_id} );
		sleep(1);
	}
	# делаем апдейт очереди, пометив обработанные сообщения путем задания offset
	unless ( eval { $api->getUpdates( { offset => $updateid + 1 } ) } ) {};
}

