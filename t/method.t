use Test::More 'no_plan';
use Debug::Smart -trace => '$trace';
use IO::File;

my $foo = "foo";
my $bar = "bar";
my $buz = "buz";
my $hash_ref = {$foo => $bar, $bar => $buz};

LOG $foo;
LOG $bar;
LOG $buz;
DUMP('dump', $hash_ref);
YAML('yaml', $hash_ref);
my $trace = 1;
$trace = 2;
$trace = 3;
$trace = 4;
$trace = 'tracing message';
$trace = {
    hoge => 'huga',
};

my $log = IO::File->new('t/main.debug_log', 'r') or die "can't open";

#LOG
my $line = $log->getline;
chomp $line;
is($line, 'foo', 'test foo');
$line = $log->getline;
chomp $line;
is($line, 'bar', 'test bar');
$line = $log->getline;
chomp $line;
is($line, 'buz', 'test buz');

#DUMP
$line = $log->getline;
chomp $line;
is($line, '[dump #DUMP]', 'test dump');
$line = $log->getline;
chomp $line;
is($line, '$VAR1 = {', 'test dump2');
$line = $log->getline;
chomp $line;
is($line, "          'bar' => 'buz',", 'test dump3');
$line = $log->getline;
chomp $line;
is($line, "          'foo' => 'bar'", 'test dump4');
$line = $log->getline;
chomp $line;
is($line, '        };', 'test dump5');

#YAML
$line = $log->getline;
chomp $line;
is($line, '[yaml #YAML]', 'yaml dump');
$line = $log->getline;
chomp $line;
is($line, '---', 'yaml dump2');
$line = $log->getline;
chomp $line;
is($line, 'bar: buz', 'yaml dump3');
$line = $log->getline;
chomp $line;
is($line, 'foo: bar', 'yaml dump4');

#TRACE
$line = $log->getline;
chomp $line;
is($line, '[TRACE name:$trace line:15] 1', 'test TRACE');
$line = $log->getline;
chomp $line;
is($line, '[TRACE name:$trace line:16] 2', 'test TRACE2');
$line = $log->getline;
chomp $line;
is($line, '[TRACE name:$trace line:17] 3', 'test TRACE3');
$line = $log->getline;
chomp $line;
is($line, '[TRACE name:$trace line:18] 4', 'test TRACE4');
$line = $log->getline;
chomp $line;
is($line, '[TRACE name:$trace line:19] tracing message', 'test TRACE5');
$line = $log->getline;
chomp $line;
is($line, '[TRACE name:$trace line:22 #DUMP]', 'test TRACE6');
$line = $log->getline;
chomp $line;
is($line, '$VAR1 = {', 'test TRACE7');
$line = $log->getline;
chomp $line;
is($line, "          'hoge' => 'huga'", 'test TRACE8');
$line = $log->getline;
chomp $line;
is($line, '        };', 'test TRACE9');

$log->close;
