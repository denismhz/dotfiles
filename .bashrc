# Aliases
# ARCHIVE EXTRACTION
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#fix perl failed setting locale
#
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# vim
alias vim="nvim"

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# ls to exa
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# enable/disable battery saving mode
batterysave()
{
  if [ "$1" ] ; then
    case $1 in 
      "enable") 
        sudo bash -c "echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode;"
        echo -e "\nBatterysaving mode enabled!";;
      "disable") 
        sudo bash -c "echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode;"
        echo -e "\nBatterysaving mode disabled!";;
      "status")
        if [ $(awk -b '{print}' '/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode') -eq 1 ]; then
          echo -e "\nBatterysaving mode enabled!"
        else
          echo -e "\nBatterysaving mode disabled!"
        fi;;
    esac
  else
    echo "No valid argument! (enable, disable, status)"
  fi
}

# Set oh-my-posh theme 
eval "$(oh-my-posh init bash --config ~/theme.omp.json)"

# random aliases
alias dotfiles='git --git-dir=$HOME/repos/dotfiles --work-tree=$HOME'
