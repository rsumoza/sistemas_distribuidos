use Cwd qw(getcwd);
$repo_root = getcwd();
$ENV{'TEXINPUTS'} = "$repo_root/cls//:" . ($ENV{'TEXINPUTS'} // '');
