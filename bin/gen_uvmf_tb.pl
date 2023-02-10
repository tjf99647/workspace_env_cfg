#!/usr/bin/perl
# Author: tangjunfeng
# Created Time: Wed 01 Feb 2023 10:34:47 AM HKT
# Copyright (C): 2023 ALL rights reserved.

use strict;
use warnings;
use Getopt::Long;
use Term::ANSIColor;
use File::Basename;
use Cwd;

my $cur_path=getcwd;
my $out_path="./uvmf_out";
my $yaml_default="$ENV{WORKSPACE}/schumacher-ppartl/sv_packs/tb/common/yamls/uvmf";
my $yaml_path=$yaml_default;
my $scripts = "$ENV{UVMF_HOME}/scripts/yaml2uvmf.py";
my $module_name="";
my $m_path="";
my $merge_option="";
my $cmd="";
my $no_copy;
my $no_code_gen;
## Parse options from @ARGV
GetOptions(
  'm|module=s'   => \$module_name,
  'o|out_dir=s'  => \$out_path,
  'y|yml_dir=s'  => \$yaml_path,
  'merge_path=s' => \$m_path,
  'no_copy'      => \$no_copy,
  'no_code_gen'  => \$no_code_gen
) or die $!;

die "module name is not specified $!" if($module_name eq "");
$out_path .= "_$module_name" if($out_path eq "./uvmf_out");

my @yaml_list = ( "${module_name}_in_interface.yaml" ,
                  "${module_name}_out_interface.yaml" ,
                  "${module_name}_util_comp_alu_predictor.yaml" ,
                  "${module_name}_environment.yaml" ,
                  "${module_name}_bench.yaml" );

get_yaml_list($yaml_path);

#if($m_path eq "") {
#  $cmd = "$scripts @yaml_list -d $out_path";
#} else {
#  $cmd = "$scripts @yaml_list -d $out_path -m $m_path";
#  #$cmd = "$scripts -d $out_path -m $out_path/verification_ip/interface_packages/srf_in_pkg";
#}

unless ($m_path eq "") {
  $merge_option = "-m ". $m_path;
}

#$cmd = "$scripts @yaml_list -d $out_path $merge_option -t $ENV{UVMF_HOME}/templates_0";
$cmd = "$scripts @yaml_list -d $out_path $merge_option";

# Start UVMF codes generation
execute($cmd) unless $no_code_gen;

# Copy UVMF codes to workspace
copy_to_workspace($out_path) unless $no_copy;

print color 'yellow';
print("UVMF code generation DONE\n");
print color 'reset';

sub execute {
  my $cmd = shift;
  my $result ;
  print color 'cyan';
  print "Executing ";
  print color 'reset';
  print"$cmd\n";
  $result = system($cmd);

  ##print "RESULT: $result \n";
  die "Execution fail: \nCMD: $cmd \nEXIT $!" unless($result eq 0);

}

sub get_yaml_list{
  my $path = shift;

  $path .= "\/";
  #print "DEBUG0: $path\n" ;
  $path =~ s/$/\// unless($path =~ m/\$/) ;
  #print "DEBUG1: $path\n" ;

  ##print @yaml_list ;
  foreach my $file (@yaml_list) {
    $file = $path . "$module_name/" . $file ; #if ($path eq $yaml_default) ; 
    die "$file not exist, $!" unless(-e $file) ;
  }

}

sub copy_to_workspace{

  my $src_path = shift;
  my $dst_path = "$ENV{WORKSPACE}/schumacher-ppartl/sv_packs/tb";
  my $dst_path_tb = "$ENV{WORKSPACE}/schumacher-ppartl/units/$module_name/src/tb";

  my $intf_path = $src_path."/verification_ip/interface_packages/*";
  my $env_path  = $src_path."/verification_ip/environment_packages/*";
  my $test_path = $src_path."/project_benches/$module_name/tb/tests/*";
  my $seq_path  = $src_path."/project_benches/$module_name/tb/sequences";
  my $tb_path   = $src_path."/project_benches/$module_name/tb/testbench/*";

  print color 'yellow';
  print "\nCopying UVMF generated files to Schumacher Workspace\n";
  print color 'reset';

  # Copy UVM lib
  execute("cp -rf $intf_path ${dst_path}/uvc_lib");
  execute("cp -rf $env_path  ${dst_path}/uvm/$module_name");

  # Copy Test & sequence
  unless (-e "${dst_path}/uvm/$module_name/tests/testcases") {
    execute("mkdir -p ${dst_path}/uvm/$module_name/tests/testcases");
  }
  execute("cp -rf $test_path ${dst_path}/uvm/$module_name/tests/testcases");
  #execute("mv ${dst_path}/uvm/$module_name/tests/tests ${dst_path}/uvm/$module_name/tests/testcases");
  execute("cp -rf $seq_path ${dst_path}/uvm/$module_name/tests");

  # Copy TB top
  execute("cp -rf $tb_path ${dst_path_tb}");

  # Remove redundent files (yaml, *.vinfo, *.do, Makefile, *.compile) 
  #execute("cd $dst_path");
  chdir($dst_path);
  execute("find . -iname  \"yaml\"     | xargs rm -rf");
  execute("find . -iname  \"*.vinfo\"  | xargs rm -rf");
  execute("find . -iname  \"*.do\"     | xargs rm -rf");
  execute("find . -iname  \"Makefile\" | xargs rm -rf");
  execute("find . -iname  \"*.compile\"| xargs rm -rf");

  # update filelist
  execute("find . -iname  \"*.f\" | xargs sed -i \"s/interface_packages\\///\"");

  chdir($dst_path_tb);
  #execute("cd $dst_path_tb");
  execute("find . -iname  \"*.vinfo\"  | xargs rm -rf");
  execute("find . -iname  \"*.compile\"| xargs rm -rf");

  # update filelist
  execute("find . -iname  \"*.f\" | xargs sed -i \"s/tb\\/testbench/src\\/tb/\"");

  #print "CUR DIR: $cur_path\n";
  chdir($cur_path);

  # Remove temporary UVMF output
  execute("rm -rf $out_path");

}

#sub end_with_slash {
#  my $path = shift;
#
#  $path =~ s/$/\// unless($path =~ m/\/$/) ;
#
#}
