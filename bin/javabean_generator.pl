#!/usr/bin/perl
## filter to generate javabean methods on a series of variable definitions
## will eat all lines that do not look like a variable definition
my $first = 1;
my $pre = undef;
while(<>) {
	if (/^(\s*)(private|public|protected)?\s*([\s\w\<,\>{}\[\]]+)\s+(\w+)/) {
		if ($first) {
			$pre = $1;
			print "$pre// javabean methods {{{\n";
			$first = 0;
		} else {
			print "\n";
		}
		print <<EOF;
${1}public $3 get\u$4() {
${1}	return $4;
${1}}
${1}public void set\u$4($3 $4) {
${1}	this.$4 = $4;
${1}}
EOF
	}
}
print "${pre}// }}}" if $pre;
