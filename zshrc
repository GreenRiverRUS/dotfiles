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
#[ ! "$UID" = "0" ] && command -v xhost 2>/dev/null 1>&2 && xhost +si:localuser:root > /dev/null

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
alias reload='source ~/.zshrc'
alias -s {avi,mpeg,mpg,mov,m2v,mkv,mp4}=vlc
alias -s {jpg,JPG,jpeg,JPEG,png,PNG}=eog
alias -s {odt,doc,docx,xls,xlsx,sxw,rtf}=libreoffice
alias -s pdf=evince
autoload -U pick-web-browser
alias -s {html,htm}=vivaldi
alias -s {py,pyw}=python3

alias killvpn='sudo /bin/kill -SIGINT $(/bin/pidof openvpn)'
alias runvpn='sudo /usr/local/sbin/openvpn --config /etc/openvpn/openvpn.conf'
alias prbvpn='if [[ $(/bin/pidof openvpn) ]]; then echo "VPN is running"; else echo "VPN is not running"; fi'



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
    venv_path="venv$1/bin/activate"
    cur_dir=$(pwd)

    while [ "$cur_dir" != '/' ]; do
        cur_path="$cur_dir/$venv_path"
        if [ -f "$cur_path" ]; then
            echo "Activating $cur_path..."
            source "$cur_path"
            break
        fi
        cur_dir="$(dirname "$cur_dir")"
    done

    if [ "$cur_dir" = '/' ]; then
        echo "Not found"
    fi
}

vinit() {
    version="$1"
    if [ -n "$2" ]; then
        name="$2"
    else
        name="venv$1"
    fi

    "$PYENV_ROOT/versions/$version/bin/python" -m venv "$name"
}

# dinit_manytask() {
#     unset DOCKER_TLS_VERIFY
#     export DOCKER_HOST="ssh://manytask"
#     unset DOCKER_CERT_PATH
# }

# dinit_local() {
#     unset DOCKER_HOST
#     unset DOCKER_TLS_VERIFY
#     unset DOCKER_CERT_PATH
# }
