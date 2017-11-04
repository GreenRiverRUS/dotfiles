# Prompt init
autoload -U promptinit
promptinit

mkdir -p /tmp/zsh-temp
git_prompt_file=/tmp/zsh-temp/$RANDOM$RANDOM$RANDOM
echo -n "" > $git_prompt_file


# Store current git branch (if available)
function git_branch_store() {
    if git branch >/dev/null 2>/dev/null; then
        ref=$(git symbolic-ref HEAD | cut -d'/' -f3)
        echo -n "(%F{red}git%f on %F{green}$ref%f)" > $git_prompt_file
    else
        echo -n "" > $git_prompt_file
    fi
}

function launch() {
    git_branch_store
}

function launch_back() {
    launch $!
}

PERIOD=2
function periodic() {
    launch_back
}

setopt prompt_subst


# Main prompt
[ ! "$UID" = "0" ] && PROMPT='$(cat $git_prompt_file)%B%F{blue}%2~/%f%F{blue}%f%b$ '
# Root prompt
[  "$UID" = "0" ] && PROMPT='$(cat $git_prompt_file)%B%F{red}%2~/%f%F{blue}%f%b$ '
# Right prompt
#RPROMPT="%{$fg_bold[grey]%}(%*)%{$reset_color%}%"


# Bind keys
bindkey "^[[0~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[F" end-of-line
bindkey "^[OF" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[3~" delete-char
bindkey "^[[3~" delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[OC" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[OD" backward-word
bindkey '^R' history-incremental-search-backward


# Moar color
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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


# Add access to X-server for root 
[ ! "$UID" = "0" ] && xhost +si:localuser:root > /dev/null

# Activate the bash-style comments in interactive mode
setopt interactivecomments


# History
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=1000
setopt append_history hist_ignore_all_dups
setopt hist_ignore_space hist_reduce_blanks


# Aliases
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias reload='source /home/vadim/.zshrc'
alias hibernate='echo disk | sudo tee /sys/power/state'
alias -s {avi,mpeg,mpg,mov,m2v,mkv,mp4}=vlc
alias -s {jpg,JPG,jpeg,JPEG,png,PNG}=eog
alias -s {odt,doc,docx,xls,xlsx,sxw,rtf}=libreoffice
alias -s pdf=evince
autoload -U pick-web-browser
alias -s {html,htm}=opera
alias -s {py,pyw}=python

alias win='sudo mount -t ntfs-3g /dev/sdb4 /mnt/win; cd /mnt/win/Users/Vadim/Documents'
alias uwin='sudo umount /dev/sdb4'
alias draft='vim /home/vadim/Documents/Draft.txt'

alias hs='vblank_mode=0 primusrun wine .wine/drive_c/Program\ Files\ \(x86\)/Battle.net/Battle.net\ Launcher.exe 1>/dev/null 2>&1 &'
alias runvpn_rub='sudo /usr/bin/openvpn --log /var/log/openvpn/log --config /home/vadim/.vpn/rubbles/vmazaev.ovpn --daemon'
alias killvpn='sudo /usr/bin/kill -9 $(/usr/bin/pidof openvpn)'


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
 tar)      tar cpvf $2.tar  $2       ;;
 bz2)    bzip $2 ;;
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

dinit_rubbles() {
	export DOCKER_TLS_VERIFY="1"
	export DOCKER_HOST="tcp://:2376"
	export DOCKER_CERT_PATH="/home/vadim/.vpn/rubbles"
}

dinit_denis() {
        export DOCKER_TLS_VERIFY="1"
        export DOCKER_HOST="tcp://:2376"
        export DOCKER_CERT_PATH="/home/vadim/.vpn/denis"
}

dinit_local() {
	unset DOCKER_HOST
	unset DOCKER_TLS_VERIFY
}

