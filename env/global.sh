#!/bin/bash

###############################################################################################
#                                                                                             #
#                                         GLOBAL ENV                                          #
#                                                                                             #
###############################################################################################

export BC_ENV_ARGS=~/.bc

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
NC='\033[0m'

export GOPATH=$HOME/Develop/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     export MACHINE=Linux;;
    Darwin*)    export MACHINE=Mac;;
    CYGWIN*)    export MACHINE=Cygwin;;
    MINGW*)     export MACHINE=MinGw;;
    *)          export MACHINE="UNKNOWN:${unameOut}"
esac

###############################################################################################
#                                                                                             #
#                                        GLOBAL ALIASES                                       #
#                                                                                             #
###############################################################################################

YUM_CMD=$(which yum >> /dev/null; echo $?)
APT_GET_CMD=$(which apt-get >> /dev/null; echo $?)
BREW_GET_CMD=$(which brew >> /dev/null; echo $?)

if [[ $YUM_CMD -eq 0 ]]; then
  export PACKAGE_MANAGER=yum
elif [[ $APT_GET_CMD -eq 0 ]]; then
  export PACKAGE_MANAGER=apt-get
elif [[ $BREW_CMD -eq 0 ]]; then
  export PACKAGE_MANAGER=brew
else
  echo "Error, can't get PMAN"
fi

#Package manager
function pman(){
  if [ $PACKAGE_MANAGER = "brew" ]; then
    $PACKAGE_MANAGER $@
  else
    sudo $PACKAGE_MANAGER $@
  fi
}

#Clear terminal and change directory to home
alias c='clear'

alias copy="xclip -i -sel p -f | xclip -i -sel c"

#Creates a file
alias t='touch'

#Close terminal
alias e='exit'

#History+grep shortcut
alias hs='history | grep'

alias gvim='gvim -v'

# Smart ls alias
alias l='ls -lah'

# Make and change directory at once
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'

# fast find
alias ff='find . -name $1'

# Login as root
alias root='sudo -i'

# System
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

#JAVA
alias sjava='sudo update-alternatives --config javac && sudo update-alternatives --config java'

#GNOME
alias gopen='xdg-open'

#Dehumanize bytes. E.g. 1Kb --> 1024 bytes
alias dehumanize='numfmt --from=iec'

#Dehumanize bytes. E.g. 1Kb --> 1024 bytes
alias humanize='numfmt --to=iec-i --suffix=B'

###############################################################################################
#                                                                                             #
#                                       GLOBAL FUNCTIONS                                      #
#                                                                                             #
###############################################################################################

#Compare two strings
function cstr(){
  if [[ "$#" -lt 2 ]]; then
    echo "Usage: cstr \"string1\" \"string2\" (Only two parameters allowed)"
    return 1
  fi
  if [[ "$#" -gt 2 ]]; then
    echo "Usage: cstr \"string1\" \"string2\" (Only two parameters allowed)"
    return 1
  fi
  diff <(echo "$1") <(echo "$2")
  res=$?
  if [[ res -eq 0 ]]; then
    echo "They are the same"
  fi
}

#Create file with random base64 content
function crfile() {
  wanted_size=$(dehumanize $2)
  file_size=$((((wanted_size/12)+1)*12 ))
  read_size=$((file_size*3/4))
  dd if=/dev/urandom bs=$read_size count=1 | base64 > $1
  truncate -s "$wanted_size" $1 
}

#Simple calculations in bc
function clc() {
    if [ $# -eq 0 ]; then
        bc -i
    else
        echo "$@" | bc
    fi
}
# Reloads environment scripts on the current session
function reload_scripts() {
  source /etc/envrc 
}

# Go up moves pwd to parent's directory $num times.
# gu 3 === cd ../../../
function gu() {
  num=$1
  if [ -z "$num" ]; then
    num=1
  fi
  while [ $num -ne 0 ]; do
    cd ..
    num=$((num - 1))
  done
}

function clean_desktop() {
  DIR=~/Desktop
  DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
  if [ -n "$(find "$DIR" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then
    echo "Empty directory $(echo $DIR)"
  else
    gio trash ~/Desktop/*
    echo "Desktop cleaned up"
  fi
}

# Extract any kind of know files
function extract() {

  if [[ "$#" -lt 1 ]]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    return 1 #not enough args
  fi

  if [[ ! -e "$1" ]]; then
    echo -e "File does not exist!"
    return 2 # File not found
  fi

  DESTDIR="."

  filename=$(basename "$1")

  case "${filename##*.}" in
  tar)
    echo -e "Extracting $1 to $DESTDIR: (uncompressed tar)"
    tar xvf "$1" -C "$DESTDIR"
    ;;
  gz)
    echo -e "Extracting $1 to $DESTDIR: (gip compressed tar)"
    tar xvfz "$1" -C "$DESTDIR"
    ;;
  tgz)
    echo -e "Extracting $1 to $DESTDIR: (gip compressed tar)"
    tar xvfz "$1" -C "$DESTDIR"
    ;;
  xz)
    echo -e "Extracting  $1 to $DESTDIR: (gip compressed tar)"
    tar xvf -J "$1" -C "$DESTDIR"
    ;;
  bz2)
    echo -e "Extracting $1 to $DESTDIR: (bzip compressed tar)"
    tar xvfj "$1" -C "$DESTDIR"
    ;;
  tbz2)
    echo -e "Extracting $1 to $DESTDIR: (tbz2 compressed tar)"
    tar xvjf "$1" -C "$DESTDIR"
    ;;
  zip)
    echo -e "Extracting $1 to $DESTDIR: (zipp compressed file)"
    unzip "$1" -d "$DESTDIR"
    ;;
  lzma)
    echo -e "Extracting $1 : (lzma compressed file)"
    unlzma "$1"
    ;;
  rar)
    echo -e "Extracting $1 to $DESTDIR: (rar compressed file)"
    unrar x "$1" "$DESTDIR"
    ;;
  7z)
    echo -e "Extracting $1 to $DESTDIR: (7zip compressed file)"
    7za e "$1" -o "$DESTDIR"
    ;;
  xz)
    echo -e "Extracting $1 : (xz compressed file)"
    unxz "$1"
    ;;
  exe)
    cabextract "$1"
    ;;
  *)
    echo -e "Unknown archieve format!"
    return
    ;;
  esac
}

#Compress file. Only tar and zip files supported
function compress() {
  if [[ "$#" -lt 1 ]]; then
    echo "Usage: compress <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz> <path/file_names>"
    return 1 #not enough args
  fi

  filename=$(basename "$1")
  arr=("$@")
  files="${arr[@]:1}"

  case "${filename##*.}" in
  zip)
    echo -e "Compressing $files to $1: (${filename##*.} file)"
    zip -r $1 $files
    ;;
  tar)
    echo -e "Extracting $1 to $DESTDIR: (${filename##*.} tar)"
    tar -cavvf $1 $files
    ;;
  gz)
    echo -e "Extracting $1 to $DESTDIR: (${filename##*.} compressed tar)"
    tar -cavvf $1 $files
    ;;
  tgz)
    echo -e "Extracting $1 to $DESTDIR: (${filename##*.} compressed tar)"
    tar -cavvf $1 $files
    ;;
  xz)
    echo -e "Extracting  $1 to $DESTDIR: (${filename##*.} compressed tar)"
    tar -cavvf $1 $files
    ;;
  bz2)
    echo -e "Extracting $1 to $DESTDIR: (${filename##*.} compressed tar)"
    tar -cavvf $1 $files
    ;;
  tbz2)
    echo -e "Extracting $1 to $DESTDIR: (${filename##*.} compressed tar)"
    tar -cavvf $1 $files
    ;;
  *)
    echo -e "Unknown archieve format!"
    return
    ;;
  esac
}

# Cats environment files
function catenv() {
  if [ -z "$1" ]; then
    cat /etc/envrc
  else
    acat=$(alias | grep $1)
    if [ -z "$acat" ]; then
      fcat=$(declare -f $1)
      if [ -z "$fcat" ]; then
        echo "${GREEN}Not an alias nor a function. Regex search:${NC}"
        cat /etc/envrc | grep $1
      else
        echo "${GREEN}Function${NC}"
        echo $fcat
      fi
    else
      echo "${GREEN}Alias${NC}"
      echo "$acat"
    fi
  fi
}

function uploadenv() {
  host=$1
  name="${1%@*}"
  if [ -z "$host" ]; then
    echo "You need to specify the host (eg. pi@pi0.local)"
    return
  fi

  if [ -z "$name" ]; then
    echo "You need to specify the username (eg. pi@pi0.local. It can't be root)"
    return
  fi

  if [ "$name" = "root" ]; then
    echo "You need to specify the username (eg. pi@pi0.local. It can't be root)"
    return
  fi
  
  scp /etc/envrc $1:/home/$name
  ssh $1 -T <<ENDSSH
      sudo mv ~/envrc /etc/envrc
      . /etc/envrc
      updatenv
ENDSSH
  echo "Environment shared and updated in $1"
}

function updatenv(){
  ENVRC_TEXT=". /etc/envrc"
  if [[ $(grep -L "$ENVRC_TEXT" ~/.bashrc) ]]; then   
    echo $ENVRC_TEXT | sudo tee -a ~/.bashrc
  fi

  if [ -f ~/.zshrc ]; then
      if [[ $(grep -L "$ENVRC_TEXT" ~/.zshrc) ]]; then   
          echo $ENVRC_TEXT | sudo tee -a ~/.zshrc
      fi
  fi

  if sudo test -f /root/.bashrc; then
    if [[ $(sudo grep -L "$ENVRC_TEXT" /root/.bashrc) ]]; then   
      echo $ENVRC_TEXT | sudo tee -a /root/.bashrc
    fi
  fi

  if sudo test -f /root/.zshrc; then
    if [[ $(sudo grep -L "$ENVRC_TEXT" /root/.zshrc) ]]; then   
        echo $ENVRC_TEXT | sudo tee -a /root/.zshrc
    fi
  fi

  . /etc/envrc
}
