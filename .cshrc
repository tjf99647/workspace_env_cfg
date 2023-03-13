############################Synopsys########################

#setenv SynopsysList /home/chehejia/eda
#
##SNPSLMD_LICENSE_FILE
#setenv SNPSLMD_LICENSE_FILE 27020@10.190.4.1
#
##VCS
#setenv DVE_HOME $SynopsysList/vcs/S-2021.09-SP1-1/gui/dve
#setenv VCS_HOME $SynopsysList/vcs/S-2021.09-SP1-1
#setenv PATH $VCS_HOME/bin:$PATH
#setenv VERDI_HOME $SynopsysList/verdi/T-2022.06
#setenv NOVAS_HOME $SynopsysList/verdi/T-2022.06
#
##SCL
#setenv SCL_HOME $SynopsysList/scl/2021.12
#setenv PATH $SCL_HOME/linux64/bin:$PATH
#
##primetime
#setenv PRIMETIME_HOME $SynopsysList/prime/S-2021.06-SP5
#setenv PATH $PRIMETIME_HOME/bin:$PATH
#
##FORMALITY
#setenv FORMALITY_HOME $SynopsysList/fm/S-2021.06-SP5
#setenv PATH $FORMALITY_HOME/bin:$PATH
#
##VERDI
#setenv PATH $VERDI_HOME/bin:$PATH
#
##dc_syn
#setenv DC_HOME $SynopsysList/syn/S-2021.06-SP5
#setenv PATH $DC_HOME/bin:$PATH
#
##ICC
#setenv ICC_HOME $SynopsysList/icc2/S-2021.06-SP5
#setenv PATH $ICC_HOME/bin:$PATH
#
##SPYGLASS
#setenv SPYGLASS_HOME $SynopsysList/spyglass/S-2021.09-SP1-1/SPYGLASS_HOME
#setenv PATH $SPYGLASS_HOME/bin:$PATH
#
##starrc
#setenv STARRC_HOME $SynopsysList/starrc/S-2021.06-SP5
#setenv PATH $STARRC_HOME/bin:$PATH
#
##LC
#setenv LC_HOME $SynopsysList/lc/T-2022.03-SP2
#setenv PATH $LC_HOME/bin:$PATH

#ALIAS
alias dc dc_shell
alias dv design_vision
alias pt primetime
alias fm formality
alias starrc StarrXtract
alias lc lc_shell
alias spyglass spyglass
alias sg sg_shell


# Colors!
set     red="%{\033[1;31m%}"
set   green="%{\033[0;32m%}"
set  yellow="%{\033[1;33m%}"
set    blue="%{\033[1;34m%}"
set magenta="%{\033[1;35m%}"
set    cyan="%{\033[1;36m%}"
set   white="%{\033[0;37m%}"
set     end="%{\033[0m%}" # This is needed at the end... :(

set prompt="[${cyan}%n${end}@${green}%m${end}]: `pwd`\n${magenta}\%\!${end} "
if ($?ICDS_HOME) then
  set prompt="ICDS:$prompt"
endif
set cmdh = "\!"
alias cd 'chdir \!:*; set prompt="[${cyan}%n${end}@${green}%m${end}]: `pwd`\n${magenta}\%$cmdh${end} "'# ▶

# Clean up after ourselves...
#unset red green yellow blue magenta cyan yellow white end

set CurPath=`pwd`

if($CurPath =~ *workspace*db[0-9] ) then
  setenv WORKSPACE `pwd`
endif
if($?WORKSPACE) then
else
  setenv WORKSPACE `pwd`
endif 

echo "WORKSPACE: ${WORKSPACE}"


setenv PATH ${WORKSPACE}/schumacher-ppartl/sv_packs/tb/common/scripts:$PATH

alias ff   'find . -iname '
alias gg   'source ~/.cshrc'
alias e    '/usr/bin/gvim'
alias h    'history'
alias l    'ls -l'
alias seda 'source /share/eda_env/edacsh'
alias go0  "cd /share/tjf_workspace/db0;  gg"
alias go1  "cd /share/tjf_workspace/db1;  gg"
alias go2  "cd /share/tjf_workspace/db2;  gg" 
alias gop  "cd $WORKSPACE/schumacher-ppartl" 
alias gom  "cd $WORKSPACE/schumacher-ppartl" 
alias goc  "cd $WORKSPACE/schumacher-ppartl/sv_packs/tb/common" 



# Set for fast entry
alias .     "cd .."
alias ..    "cd ../.."
alias ...   "cd ../../.."
alias ....  "cd ../../../.."
alias ..... "cd ../../../../.."

# GIT related
alias gs    "git status"
alias gsn   "git status -uno"
alias gco   "git checkout"
alias gd    "git difftool"
alias gdc   "git difftool --cached"
alias gpush "git push origin HEAD:refs/for/master"
alias gsl   "git config --file .gitmodules --name-only --get-regexp path"
alias gsv   "git submodule foreach git remote -v"
alias gsa   "git submodule add "

# Ctags related
alias ctags_uvms "ctags -R --languages=systemverilog -o ~/tags_m/tags_uvm /share/app/eda/vcs/S-2021.09-SP1-1/etc/uvm-1.2"
alias ctags_uvmf "ctags -R --languages=systemverilog -o ${WORKSPACE}/tags_uvmf $WORKSPACE"
alias ctags_cpp  "ctags -R --languages=C++ -o ${WORKSPACE}/tags_cpp $WORKSPACE"


