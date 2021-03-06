# Prompt init
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%B!%b'
zstyle ':vcs_info:*' stagedstr '%B+%b'
zstyle ':vcs_info:*' nvcsformats '%F{blue}%B%2~%b%f'  # show only last 2 parts of path outside vcs
zstyle ':vcs_info:*' formats '%B%F{blue}%r%f%%b(%B%F{yellow}%b%f%%b%c%u)%B%F{blue}%S%f%%b'
zstyle ':vcs_info:*' actionformats '%B%F{blue}%r%f%%b[%B%F{red}%a%f%%b]%B%F{blue}%S%f%%b'

# Fix subdir path (%S) inside vcs to show only last 2 parts of path
# e.g. repo/dir/subdir/file -> subdir/file
zstyle ':vcs_info:*+set-message:*' hooks subdir-path
function +vi-subdir-path() {
    #autoload -U regexp-replace
    #hook_com[base]="${hook_com[base]/$HOME/~}"
    basename="$(basename ${hook_com[subdir]})"
    if [ "$basename" = "." ]; then
        hook_com[subdir]=""
        return
    fi
    basedir="$(basename $(dirname ${hook_com[subdir]}))"
    if [ "$basedir" = "." ]; then
        hook_com[subdir]="$basename"
    else
        hook_com[subdir]="$basedir/$basename"
    fi
}

precmd() { vcs_info }

setopt prompt_subst
# Main prompt
[ ! "$UID" = "0" ] && PROMPT='%B%F{green}%n@%f%F{red}%m%f%b:${vcs_info_msg_0_}$ '
# Root prompt
[  "$UID" = "0" ] && PROMPT='%B%F{red}%n@%m%f%b:${vcs_info_msg_0_}# '


# Bind keys
#bindkey "^[[0~" beginning-of-line
#bindkey "^[OH" beginning-of-line
#bindkey "^[[H" beginning-of-line
#bindkey "^[[1~" beginning-of-line
#bindkey "^[[4~" end-of-line
#bindkey "^[[F" end-of-line
#bindkey "^[OF" end-of-line
#bindkey "^[[4~" end-of-line
#bindkey "^[[3~" delete-char
#bindkey "^[[3~" delete-char
#bindkey "^[[3~" delete-char
#bindkey "^[[3~" delete-char
#bindkey "^[[1;5C" forward-word
#bindkey "^[OC" forward-word
#bindkey "^[[1;5D" backward-word
#bindkey "^[OD" backward-word
bindkey '^R' history-incremental-search-backward


# Moar color
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
    'alias'           'fg=green'
    'builtin'         'fg=cyan'
    'function'        'fg=cyan'
    'command'         'fg=153,bold'
    'precommand'      'fg=magenta, underline'
    'hashed-commands' 'fg=cyan'
    'path'            'underline'
    'globbing'        'fg=166'
)


# Autocompletion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'


# Set vim as default editor
export EDITOR=vim

export PYENV_ROOT="$HOME/.pyenv"

path+=$PYENV_ROOT/bin
export PATH

# Add access to X-server for root (if available)
[ ! "$UID" = "0" ] && command -v xhost && xhost +si:localuser:root > /dev/null

# Activate the bash-style comments in interactive mode
setopt interactivecomments


# History
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=1000
setopt append_history hist_ignore_all_dups
setopt hist_ignore_space hist_reduce_blanks


# Aliases
alias xclip='xclip -selection clipboard'
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias reload='source ~/.zshrc'
alias hibernate='echo disk | sudo tee /sys/power/state'
alias -s {avi,mpeg,mpg,mov,m2v,mkv,mp4}=vlc
alias -s {jpg,JPG,jpeg,JPEG,png,PNG}=eog
alias -s {odt,doc,docx,xls,xlsx,sxw,rtf}=libreoffice
alias -s pdf=evince
autoload -U pick-web-browser
alias -s {html,htm}=vivaldi
alias -s {py,pyw}=python3

#alias hs='vblank_mode=0 primusrun wine .wine/drive_c/Program\ Files\ \(x86\)/Battle.net/Battle.net\ Launcher.exe 1>/dev/null 2>&1 &'
#alias win='sudo mount -t ntfs-3g /dev/sdb4 /mnt/win; cd /mnt/win/Users/Vadim/Documents'
#alias uwin='sudo umount /dev/sdb4'

alias killvpn='sudo /bin/kill -SIGINT $(/bin/pidof openvpn)'
alias runvpn='sudo /usr/local/sbin/openvpn --config /etc/openvpn/openvpn.conf'
alias runvpn_docean='sudo /usr/local/sbin/openvpn --log /var/log/openvpn.log --config /home/vmazaev/.vpn/vmazaev_thinkpad.ovpn --daemon'
alias prbvpn='if [[ $(/bin/pidof openvpn) ]]; then echo "VPN is running"; else echo "VPN is not running"; fi'
# alias runvpn='sudo /usr/bin/openvpn --log /var/log/openvpn/log --config /home/vadim/.vpn/vscale/vmazaev.ovpn --script-security 2 --up /etc/openvpn/update-resolv-conf.sh --down /etc/openvpn/update-resolv-conf.sh --down-pre --daemon'

#alias mount_dev='sshfs root@hostname:/home/vmazaev/ /home/vmazaev/Ya/shared -C -p 22 -o uid=43681 -o gid=98640'
#alias umount_dev='fusermount -u /home/vmazaev/Ya/shared'


# Functions
extract() {
    if [ -f $1 ] ; then
    case $1 in
    *.tar.bz2)   tar xjf $1        ;;
    *.tar.gz)    tar xzf $1     ;;
    *.bz2)       bunzip2 $1       ;;
    *.rar)       unrar x $1     ;;
    *.gz)        gunzip $1     ;;
    *.tar)       tar xf $1        ;;
    *.tbz2)      tar xjf $1      ;;
    *.tbz)       tar -xjvf $1    ;;
    *.tgz)       tar xzf $1       ;;
    *.zip)       unzip $1     ;;
    *.Z)         uncompress $1  ;;
    *.7z)        7z x $1    ;;
    *)           echo "I don't know how to extract '$1'..." ;;
    esac
    else
    echo "'$1' is not a valid file"
    fi
}

pk() {
    if [ $1 ] ; then
        case $1 in
            tbz)       tar cjvf $2.tar.bz2 $2      ;;
            tgz)       tar czvf $2.tar.gz  $2       ;;
            tar)       tar cpvf $2.tar  $2       ;;
            bz2)       bzip $2 ;;
            gz)        gzip -c -9 -n $2 > $2.gz ;;
            zip)       zip -r $2.zip $2   ;;
            7z)        7z a $2.7z $2    ;;
            *)         echo "'$1' cannot be packed via pk()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

venv() {
    FILE=/venv/bin/activate
    MPATH=`pwd`
    while [  "$MPATH" != '/' ]; do
        if [ -f ${MPATH}${FILE} ];
        then
            echo Activating ${MPATH}${FILE}
            source ${MPATH}${FILE}
            break
        fi
        MPATH="$(dirname "$MPATH")"
    done
    if [ "$MPATH" = '/' ];
    then
        echo Not found
    fi
}

venv3() {
    FILE=/venv3/bin/activate
    MPATH=`pwd`
    while [  "$MPATH" != '/' ]; do
        if [ -f ${MPATH}${FILE} ];
        then
            echo Activating ${MPATH}${FILE}
            source ${MPATH}${FILE}
            break
        fi
        MPATH="$(dirname "$MPATH")"
    done
    if [ "$MPATH" = '/' ];
    then
        echo Not found
    fi
}

#ace() {
#    acestream-launcher -t torrent "$1"
#}

dinit_docean() {
    unset DOCKER_TLS_VERIFY
    export DOCKER_HOST="tcp://172.17.0.2:2375"
    unset DOCKER_CERT_PATH
}

dinit_local() {
    unset DOCKER_HOST
    unset DOCKER_TLS_VERIFY
    unset DOCKER_CERT_PATH
}

echo "
                  o
                  |
                ,'~'.
               /     \ 
              |   ____|_
              |  '___,,_'         .----------------.
              |  ||(o |o)|       ( KILL ALL HUMANS! )
              |   -------         ,----------------'
              |  _____|         -'
              \  '####,
               -------
             /________\ 
           (  )        |)
           '_ ' ,------|\          _
          /_ /  |      |_\        ||
         /_ /|  |     o| _\      _||
        /_ / |  |      |\ _\____//' |
       (  (  |  |      | (_,_,_,____/
        \ _\ |   ------|
         \ _\|_________|
"
