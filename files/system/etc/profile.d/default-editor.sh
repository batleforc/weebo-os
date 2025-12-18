# DEFAULT EDITOR SHOULD BE VIM, NOT NANO

if [ -z "$EDITOR" ]; then
    export EDITOR=vim
fi