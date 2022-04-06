#!/bin/bash

###############################################################################################
#                                                                                             #
#                                        PERSONAL ALIASES                                     #
#                                                                                             #
###############################################################################################

HUGO_SUPPORTED_LANGUAGES=("en" "es")
EMOTIONS_TEMPLATE=/home/jpgarcia/journals/templates/emotion.txt
alias hpost="hcontent posts"
alias hproject="hcontent projects"
alias emotion="jrnl emotions < $EMOTIONS_TEMPLATE && jrnl emotions -1 --edit"

###############################################################################################
#                                                                                             #
#                                        PERSONAL FUNCTIONS                                   #
#                                                                                             #
###############################################################################################

function hcontent() {
    if [ ! -d content/$1 ]; then
        echo "You must be on a HUGO project directory. Or create a base directory for content/$1."
    else
        if [ -z "$2" ]
        then
            echo "You have to provide a valid $1 slug (e.g: first-post)"
        else
            for VARIABLE in $HUGO_SUPPORTED_LANGUAGES
            do
                hugo new $1/$2/index.$VARIABLE.md
            done
        fi
        
    fi
}

function jrnl() {
    if [ $MACHINE = "Mac" ]; then
        /usr/local/bin/jrnl $@
    elif [ $MACHINE = "Linux" ]; then
        ~/.local/bin/jrnl $@
    else
        echo "jrnl.sh not found for $MACHINE"
    fi

    if [ -d ~/journals ]; then
        cd ~/journals
        if ! git diff-index --quiet HEAD --; then
            git add --all
            git commit -m "Log $(date)"
            git push origin master
        fi
        cd -
    fi
}
