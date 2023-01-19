############################Synopsys########################

setenv SynopsysList /home/chehejia/eda

#SNPSLMD_LICENSE_FILE
setenv SNPSLMD_LICENSE_FILE 27020@10.190.4.1

#VCS

setenv DVE_HOME $SynopsysList/vcs/S-2021.09-SP1-1/gui/dve
setenv VCS_HOME $SynopsysList/vcs/S-2021.09-SP1-1
setenv PATH $VCS_HOME/bin:$PATH
setenv VERDI_HOME $SynopsysList/verdi/T-2022.06
setenv NOVAS_HOME $SynopsysList/verdi/T-2022.06

#SCL
setenv SCL_HOME $SynopsysList/scl/2021.12
setenv PATH $SCL_HOME/linux64/bin:$PATH

#primetime
setenv PRIMETIME_HOME $SynopsysList/prime/S-2021.06-SP5
setenv PATH $PRIMETIME_HOME/bin:$PATH

#FORMALITY
setenv FORMALITY_HOME $SynopsysList/fm/S-2021.06-SP5
setenv PATH $FORMALITY_HOME/bin:$PATH

#VERDI
setenv PATH $VERDI_HOME/bin:$PATH

#dc_syn
setenv DC_HOME $SynopsysList/syn/S-2021.06-SP5
setenv PATH $DC_HOME/bin:$PATH

#ICC
setenv ICC_HOME $SynopsysList/icc2/S-2021.06-SP5
setenv PATH $ICC_HOME/bin:$PATH

#SPYGLASS
setenv SPYGLASS_HOME $SynopsysList/spyglass/S-2021.09-SP1-1/SPYGLASS_HOME
setenv PATH $SPYGLASS_HOME/bin:$PATH

#starrc
setenv STARRC_HOME $SynopsysList/starrc/S-2021.06-SP5
setenv PATH $STARRC_HOME/bin:$PATH

#LC
setenv LC_HOME $SynopsysList/lc/T-2022.03-SP2
setenv PATH $LC_HOME/bin:$PATH


#ALIAS
alias dc dc_shell
alias dv design_vision
alias pt primetime
alias fm formality
alias starrc StarrXtract
alias lc lc_shell
alias spyglass spyglass
alias sg sg_shell

 set prompt="[%n@%m]: `pwd`\n\!% "
 if ($?ICDS_HOME) then
   set prompt="ICDS:$prompt"
 endif
 set cmdh = "\!"
 alias cd 'chdir \!:*; set prompt="[%n@%m]: `pwd`\n$cmdh% "'

alias ff 'find . -iname '
alias gg 'source ~/.cshrc'
alias e  '/usr/bin/gvim'
alias h  'history'


# Set for fast entry
alias .     "cd .."
alias ..    "cd ../.."
alias ...   "cd ../../.."
alias ....  "cd ../../../.."
alias ..... "cd ../../../../.."

# GIT related
alias gs    "git status"
alias gco   "git checkout"
alias gd    "git difftool"
alias gdc   "git difftool --cached"
alias gpush "git push origin HEAD:refs/for/master"
