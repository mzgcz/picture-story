#!/usr/bin/perl -w

use strict;
use utf8;
use GraphViz;
use open IO => ':utf8';
use open OUT => ':utf8';

#three format
#1. somebody status
#2. somebody do something
#3. somebody use something do something

#usage
#pstor input_file output_dir

my $pstory_file = shift @ARGV;
my $pstory_dir = shift @ARGV;

sub pstory_style_3 {
  my ($sb, $use, $tl, $do, $st) = @_;
  my $pstory = GraphViz->new(rankdir => 'LR');
  $pstory->add_node($sb);
  $pstory->add_node($tl);
  $pstory->add_node($st);
  $pstory->add_edge($sb => $tl, label => $use);
  $pstory->add_edge($tl => $st, label => $do);
  $pstory->as_svg("$pstory_dir/no.3");
}

sub pstory_style_2 {
  my ($sb, $do, $st) = @_;
  my $pstory = GraphViz->new(rankdir => 'LR');
  $pstory->add_node($sb);
  $pstory->add_node($st);
  $pstory->add_edge($sb => $st, label => $do);
  $pstory->as_svg("$pstory_dir/no.2");
}

sub pstory_style_1 {
  my ($sb, $status) = @_;
  my $pstory = GraphViz->new(rankdir => 'LR');
  $pstory->add_node($sb);
  $pstory->add_node($status);
  $pstory->add_edge($sb => $status);
  $pstory->as_svg("$pstory_dir/no.1");
}

open PSTORY_INFO, "<$pstory_file";
while (<PSTORY_INFO>) {
  chomp;
  if (/^(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s*$/) {
    &pstory_style_3($1, $2, $3, $4, $5);
  } elsif (/^(\w+)\s+(\w+)\s+(\w+)\s*$/) {
    &pstory_style_2($1, $2, $3);
  } elsif (/^(\w+)\s+(\w+)\s*$/) {
    &pstory_style_1($1, $2);
  }
}

close PSTORY_INFO;
