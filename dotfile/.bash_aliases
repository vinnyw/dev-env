export VISUAL=vim
export EDITOR=vim

# fix annoying directory colours
LS_COLORS=$LS_COLORS:'di=4;94:ow=4;94' ; export LS_COLORS

# if bash completion is available, set it up for ssh/scp
if [ -d 'etc/bash_completion.d/' ]; then 
    _ssh() 
    {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)
        COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
        return 0
    }
    complete -F _ssh ssh
fi

# custom wsl prompt
if [ ! -z "$WSL_DISTRO_NAME" ]; then    
    # terminal title
    #PS1='\033]0;${WSL_DISTRO_NAME}\a'    
    # username
    PS1='\[\e[0;32m\]\u\[\e[m\]'
    # seperator
    PS1+='\[\e[0;2;32m\]@\[\e[m\]'
    # container
    PS1+='\[\e[0;33m\]${WSL_DISTRO_NAME}\[\e[m\]' 
    # seperator
    #PS1+='\[\e[37m\]:\[\e[m\]'
    #PS1+='\[\e[0;2;32m\]:\[\e[m\]'
    PS1+='\[\e[0;34m\]:\[\e[m\]'
    # path
    PS1+='\[\e[1;34m\]\w\[\e[m\]' 
    # trailing
    PS1+='\[\e[0m\]$\[\e[m\] '
fi
