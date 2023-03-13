#!/usr/bin/perl
# Author: tangjunfeng
# Created Time: Wed 01 Feb 2023 10:34:47 AM HKT
# Copyright (C): 2023 ALL rights reserved.

use strict;
use warnings;
use Getopt::Long;
use Term::ANSIColor;
use File::Basename;
use Cwd qw(getcwd abs_path);

$ENV{UVMF_HOME} = '/share/tjf_workspace/UVMF_LX';
print "UVMF_HOME: $ENV{UVMF_HOME}\n";

my ($repo_path)=(abs_path($0)=~/(^.*schumacher-ppartl)/);
my $cur_path=getcwd;
my $out_path=$repo_path;#"./uvmf_out";
my $yaml_default="$repo_path/sv_packs/tb/common/yamls/uvmf";
my $yaml_path=$yaml_default;
my $scripts = "$ENV{UVMF_HOME}/scripts/yaml2uvmf.py";
my $module_name="";
my $m_path="";
my $merge_option="";
my $tmpl_option="";
my $tmpl_path="";
my $uvmf_cmd="";
my $no_copy;
my $no_code_gen;
my $gen_only;

## Parse options from @ARGV
GetOptions(
  'm|module=s'   => \$module_name,
  'o|out_dir=s'  => \$out_path,
  'y|yml_dir=s'  => \$yaml_path,
  't|tmpl_dir=s' => \$tmpl_path,
  'merge_path=s' => \$m_path,
  'no_copy'      => \$no_copy,
  'no_code_gen'  => \$no_code_gen,
  'gen_only'     => \$gen_only
) or die $!;

die "module name is not specified $!" if($module_name eq "");
$out_path .= "_$module_name" if($out_path eq "./uvmf_out");

my $YamlList  = "${module_name}_yaml_list";
my @yaml_list =("${module_name}_in_interface.yaml" ,
                "${module_name}_out_interface.yaml" ,
                "${module_name}_util_comp_predictor.yaml" ,
                "${module_name}_environment.yaml" ,
                "${module_name}_bench.yaml" );

#===============================================#
# Check if all required YAML files exist
#===============================================#
#print get_yaml_list($yaml_path) . "\n";
#get_yaml_list($yaml_path);


#===============================================#
# Check if there is UVMF codes exist in repo,
# if so merge with existing codes
#===============================================#
my $dst_path = "$out_path/sv_packs/tb";

my $dst_lib  = "$dst_path/uvc_lib";
my $dst_env  = "$dst_path/uvm/$module_name";
my $dst_tc   = "$dst_path/uvm/$module_name/tests/testcases";
my $dst_seq  = "$dst_path/uvm/$module_name/tests/sequences";
my $dst_tb   = "$repo_path/units/$module_name/src/tb";

my $uvmf_intf = "/verification_ip/interface_packages";
my $uvmf_env  = "/verification_ip/environment_packages";
my $uvmf_test = "/project_benches/$module_name/tb/tests";
my $uvmf_seq  = "/project_benches/$module_name/tb/sequences";
my $uvmf_tb   = "/project_benches/$module_name/tb/testbench";

#merge_source() if(-e $dst_env) ;

if(-e $dst_env ) {
  $m_path = $out_path ;
  $out_path = "out_uvmf_tmp";

  print "UVMF code of $module_name exist, to merge with new generated code\n";
}

unless ($m_path eq "") {
  $merge_option = "-m ". $m_path . " --merge_no_backup --merge_skip_missing_blocks "; #" --merge_debug --merge_verbose";
}

if($gen_only) {
  $m_path="";
  $merge_option="";
  $out_path="out_uvmf_tmp";
}

unless ($tmpl_path eq "") {
  $tmpl_option = "-t ". $tmpl_path ;
}

#========================================#
# Start UVMF codes generation
#========================================#
#($uvmf_cmd) = qw($scripts &get_yaml_list($yaml_path) -d $out_path $merge_option $tmpl_option) ;
$uvmf_cmd = "$scripts " . &get_yaml_list($yaml_path) . " -d $out_path $merge_option $tmpl_option";
#$uvmf_cmd = "$scripts @yaml_list -d $out_path $merge_option $tmpl_option";
execute($uvmf_cmd, 1) unless $no_code_gen;

print color 'yellow';
print("UVMF code generation SUCCEED...\n");
print color 'reset';

#========================================#
# Copy UVMF codes to workspace
#========================================#
#copy_to_workspace($out_path) unless $no_copy;

# Remove temporary UVMF output
if($out_path eq "out_uvmf_tmp" ) {
  print color 'yellow';
  print("Remove temporary codes...\n");
  print color 'reset';
  #execute("rm -rf $out_path", 1);
}

print color 'green';
print("Scripts execution DONE...\n");
print color 'reset';

sub get_yaml_list{
  my $path = shift;
  my $list_m; 

  $path =~ s/$/\// unless($path =~ m/\$/) ;

  $list_m = $path . "$module_name/" . $YamlList;
  return "-F $list_m" if(-e $list_m) ;

  my @yaml_list_m;
  foreach (@yaml_list) {
    my $file = $_; 
    $file = $path . "$module_name/" . $file ; #if ($path eq $yaml_default) ;
    die "$file not exist, $!" unless(-e $file) ;
    push @yaml_list_m, $file ; 
  }

  $list_m = join " ", @yaml_list_m ;
  return $list_m;

}

sub copy_to_workspace{

  my $src_path = shift;

  my $intf_path = $src_path.$uvmf_intf."/*" ;
  my $env_path  = $src_path.$uvmf_env ."/*" ;
  my $test_path = $src_path.$uvmf_test."/*" ;
  my $seq_path  = $src_path.$uvmf_seq ."/*" ;
  my $tb_path   = $src_path.$uvmf_tb  ."/*" ;

  print color 'yellow';
  print "Copying UVMF generated files to Schumacher Workspace...\n";
  print color 'reset';

  # Copy UVM lib
  execute("cp -rf $intf_path ${dst_lib}");
  execute("cp -rf $env_path  ${dst_env}");

  # Copy Test & sequence
  unless (-e "${dst_tc}") {
    execute("mkdir -p ${dst_tc}");
  }
  execute("cp -rf $test_path ${dst_tc}");
  unless (-e "${dst_seq}") {
    execute("mkdir -p ${dst_seq}");
  }
  execute("cp -rf $seq_path ${dst_seq}");

  # Copy TB top
  execute("cp -rf $tb_path ${dst_tb}");

  # Remove redundent files (yaml, *.vinfo, *.do, Makefile, *.compile)
  chdir($dst_path);
  execute("find . -iname  \"yaml\"     | xargs rm -rf");
  execute("find . -iname  \"*.vinfo\"  | xargs rm -rf");
  execute("find . -iname  \"*.do\"     | xargs rm -rf");
  execute("find . -iname  \"Makefile\" | xargs rm -rf");
  execute("find . -iname  \"*.compile\"| xargs rm -rf");

  # update filelist
  execute("find . -iname  \"*.f\" | xargs sed -i \"s/interface_packages\\///\"");

  chdir($dst_tb);
  #execute("cd $dst_tb");
  execute("find . -iname  \"*.vinfo\"  | xargs rm -rf");
  execute("find . -iname  \"*.compile\"| xargs rm -rf");

  # update filelist
  execute("find . -iname  \"*.f\" | xargs sed -i \"s/tb\\/testbench/src\\/tb/\"");

  #print "CUR DIR: $cur_path\n";
  chdir($cur_path);

  # Remove temporary UVMF output
  execute("rm -rf $out_path");

  print color 'yellow';
  print "Done copy...\n";
  print color 'reset';

}

sub merge_source {

  my $src_dir= "uvmf_src";
  my $intf_path = $src_dir.$uvmf_intf ;
  my $env_path  = $src_dir.$uvmf_env  ;
  my $test_path = $src_dir.$uvmf_test ;
  my $seq_path  = $src_dir.$uvmf_seq  ;
  my $tb_path   = $src_dir.$uvmf_tb   ;

  print "UVMF code exist, to merge with new generated code\n";

  # mkdir($src_dir);
  #mkdir($intf_path);
  #mkdir($env_path );
  #mkdir($test_path);
  #mkdir($seq_path );
  #mkdir($tb_path  );

  # Copy to UVMF codes in repo to src dir

}

sub execute {
  my $cmd = shift;
  my $verbose = shift;
  my $result ;
  if($verbose) {
    print color 'cyan';
    print "Executing ";
    print color 'reset';
    print color 'green';
    print"$cmd\n";
    print color 'reset';
  }
  $result = system($cmd);

  ##print "RESULT: $result \n";
  die "Execution fail: \nCMD: $cmd \nEXIT $!" unless($result eq 0);

}



#sub end_with_slash {
#  my $path = shift;
#
#  $path =~ s/$/\// unless($path =~ m/\/$/) ;
#
#}
