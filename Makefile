all :
.PHONY : all build merge_env install install_dependencies config config_vim config_bc copy_config
SHELL := /bin/bash

build: merge_env
	if [ -d tenv ]; then \
		rm -rf tenv; \
	fi
	if [ -d tenv.tar.gz ]; then \
		rm tenv.tar.gz; \
	fi
	mkdir tenv
	cp -R config tenv/config
	cp -R rc tenv/
	cp /tmp/envrc tenv/
	cp Makefile tenv
	tar -czvf tenv.tar.gz tenv/*
	rm -rf tenv

merge_env:
	if [ ! -f envrc ]; then \
		echo "Generating envrc file"; \
		if [ -f /tmp/envrc ]; then \
			sudo rm /tmp/envrc; \
		fi; \
		touch /tmp/envrc; \
		cat env/*.sh > /tmp/envrc; \
	fi

config_vim:
	if [[ ! -d ~/.vim/bundle/Vundle.vim ]];then \
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; \
	fi
	if [ -d ~/.vimrc ]; then \
		rm ~/.vimrc; \
	fi
	cp rc/.vimrc ~/.vimrc
	cp rc/.vim/* ~/.vim/

config_bc:
	if [ -d ~/.bc ]; then \
		rm ~/.bc; \
	fi
	cp rc/.bc ~/.bc

config: config_vim config_bc copy_config

copy_config:
	$(foreach file, $(wildcard config/*), \
		if [ ! -d ~/.config ]; then \
			mkdir ~/.config; \
		fi; \
		if [ -d ~/.$(file) ];then \
			rm -rf ~/.$(file); \
		fi; \
		cp -r $(file) ~/.$(file); \
		)

install_dependencies:
	if  command -v yum >/dev/null; then \
		sudo yum -y install python3-pip rsync vim bc git; \
	fi
	if command -v apt-get >/dev/null; then \
		sudo apt-get install python3-pip rsync vim bc avahi-utils dnsutils net-tools; \
	fi
	if command -v brew >/dev/null; then \
		brew install rsync vim xclip ffmpeg; \
	fi

install: install_dependencies config merge_env
	if [ -f envrc ]; then \
		sudo mv envrc /etc/envrc; \
	else \
		sudo mv /tmp/envrc /etc/envrc; \
	fi
	bash -c 'source /etc/envrc && updatenv'
	echo "Instalation completed"
