#!/usr/bin/perl
use warnings;
use strict;

my $IS="avx2";

#Retrieve last version
my $dir=`ls  -d src/* | sort -r | head -n1`;
chomp($dir);
print "Last version was stored in $dir\n";



#Increment the version number
my ($prefix, $version) = $dir =~ /^([^0-9]*)([0-9]+)/;

$version = $version + 1;

if($version < 10){
	$version = "0$version";
}

print "New version created is $prefix"."$version\n";
my $newversion="$prefix"."$version";
print "$newversion\n";

print "cp -r $dir $newversion\n";
`cp -r $dir $newversion`;

my ($compile) = $newversion =~ /src\/(.*)/;

my $filename = "compileversion$version.sh";
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
print $fh "make build version=$compile model=cpu simd=$IS";
close $fh;
$filename = "runversion$version.sh";
open($fh, '>', $filename) or die "Could not open file '$filename' $!";
print $fh "bin/iso3dfd_$compile\_cpu_$IS.exe";
close $fh;

`chmod u+x runversion$version.sh`;
`chmod u+x compileversion$version.sh`;

print "You can compile your new version by running the script compileversion.sh\n";


