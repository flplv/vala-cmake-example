#!/usr/bin/perl -w

my @file_test_list = `egrep --include "*.vala" -hr -e "base\\s*?\\(\\s*?\\""  -e "add_test\\s*?\\(\\s*?\\""`;

$current_base = "";

foreach $line(@file_test_list) {
    $_ = $line;
    my ($name) = /"(.*?)"/;

    if (index($line, "base") != -1) {
        $current_base = $name
    }
    else {
        print "/";
        print $current_base;
        print "/";
        print $name;
        print "\n";
    }
}
