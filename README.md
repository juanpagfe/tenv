# Terminal Environment (tenv)
Small project to maintain and be able to install and deploy my terminal environment through different Linux computers.

## Directory Structure
Each directory contains important configurations for the bashrc/zshrc and other tools.

### config
All the files and directories in this folder will be copied in the user's config directory (usually `~/.config`). This helps to have a shared set of configurations that when needed, you can port to other computers.

### env
Contains a set of bash files that are merged into one in the build process. The amount of files is not fixed, so you can delete/create any file. I use this files for organizing my aliases and predifined functions for them to be accesible in my terminals.

### rc
Contains the dotfiles and folders that are copied to the user's home directory with more configurations for the tools.

## Install

```bash
#It will install the environment in the current machine
#  -- Merges all the env/ files into one envrc file that is stored in /etc/
#  -- Copies the config/ files and directories to the ~/.config folder
#  -- Copies the rc/ files and directories to the $HOME folder
make install
```

## Deploy

```bash
#It will build the environment and create a tar file, then it will copy it into the selected hosts (can be multiple at the same time) and install the environment.
./deploy pi@bga.local main@selfhost.tk 
```