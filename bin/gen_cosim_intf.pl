#!/usr/bin/perl
# Author: tangjunfeng
# Created Time: Sat 28 Jan 2023 04:38:36 PM HKT
# Copyright (C): 2023 ALL rights reserved.

use strict;
use warnings;
use Getopt::Long;
use Term::ANSIColor;

my $base_path="/share/tjf_workspace/cad-scripts/interface_gen";
my $rtl_inf_gen="$base_path/src/rtl_inf_gen.py";
my $dpi_cosim_gen="$base_path/src/dpi_cosim_gen.py";
my $py_cmpl="python3";
my $port_list_m="$base_path/latest_csv_input/Port_Map.csv";
my $intf_list_m="$base_path/latest_csv_input/Schumacher_Interfaces_NPU.csv";

# Variables get from options
my $module;
my $gen_rtl;
my $gen_tb;
my $gen_cm;

## parse options from @ARGV
GetOptions(
    'm|module=s' => \$module,
    'gen_rtl'    => \$gen_rtl,
    'gen_tb'     => \$gen_tb,
    'gen_cm'     => \$gen_cm,
) or die $!;

if($gen_rtl) {
    print color 'blue';
    print "To print RTL top for arf module for $module\n";
    print color 'reset';
    #system("$py_cmpl $rtl_inf_gen -h");
    execute("$py_cmpl $rtl_inf_gen  --interface $intf_list_m --port_list $port_list_m --module_name $module");
}


#To print tb for arf module:
if($gen_tb) {
    print color 'magenta';
    print "To print tb for module $module\n";
    print color 'reset';
    execute("$py_cmpl $dpi_cosim_gen --interface $intf_list_m --port_list $port_list_m --out_file_type SV --MN $module");
}

if($gen_cm) {
    #To print cmodel top for arf module
    print color 'cyan';
    print "To print cmodel for module $module\n";
    print color 'reset';
    execute("$py_cmpl $dpi_cosim_gen --interface $intf_list_m --port_list $port_list_m --out_file_type CM --MN $module");
}

sub execute {
    my $cmd = shift;
    print color 'cyan';
    print "Executing ";
    print color 'reset';
    print"$cmd\n";
    system($cmd);
}


