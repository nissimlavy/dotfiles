# Path to your oh-my-zsh installation.
export ZSH=/Users/nissimlavy/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel9k/powerlevel9k"
DEFAULT_USER="nissimlavy"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias pg="ps -ef | grep"
alias dls="cd ~/Downloads"
alias hgrep="history | grep"
alias dev="cd ~/dev"

eg(){
      MAN_KEEP_FORMATTING=1 man "$@" 2>/dev/null \
          | gsed --quiet --expression='/^E\(\x08.\)X\(\x08.\)\?A\(\x08.\)\?M\(\x08.\)\?P\(\x08.\)\?L\(\x08.\)\?E/{:a;p;n;/^[^ ]/q;ba}' \
          | ${MANPAGER:-${PAGER:-pager -s}}
}

ctail() {
 tail -f $1 | awk '
  /INFO/ {print "\033[32m" $0 "\033[39m"}
  /ERROR/ {print "\033[31m" $0 "\033[39m"}
  /WARN/ {print "\033[33m" $0 "\033[39m"}
  /DEBUG/ {print "\033[35m" $0 "\033[39m"} 
  /!/ {print "\033[31m" $0 "\033[39m"}
   {if($0 !~ /INFO|ERROR|WARN|DEBUG/)	
	{print$0}}'
}

#Welcome Message
sed -n $(( $RANDOM % 114 + 1 ))p quotes
# cat ~/scripts/motd
# echo -ne $(cat tasks) | sed "s/^ //"
eval $(thefuck --alias)


function play {
    # Skip DASH manifest for speed purposes. This might actually disable
    # being able to specify things like 'bestaudio' as the requested format,
    # but try anyway.
    # Get the best audio that isn't WebM, because afplay doesn't support it.
    # Use "$*" so that quoting the requested song isn't necessary.
    youtube-dl --default-search=ytsearch: \
               --youtube-skip-dash-manifest \
               --output="${TMPDIR:-/tmp/}%(title)s-%(id)s.%(ext)s" \
               --restrict-filenames \
               --format="bestaudio[ext!=webm]" \
               --exec=afplay "$*"
}

function mp3 {
    # Get the best audio, convert it to MP3, and save it to the current
    # directory.
    youtube-dl --default-search=ytsearch: \
               --restrict-filenames \
               --format=bestaudio \
               --extract-audio \
               --audio-format=mp3 \
               --audio-quality=1 "$*"
}

function mkcd {
    # Make a directory and change to it.
    mkdir -p "$1" && cd "$1"
}

export EDITOR=vim

# Easily extract all compressed file types
extract () {
   if [ -f "$1" ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf -- "$1"    ;;
           *.tar.gz)    tar xvzf -- "$1"    ;;
           *.bz2)       bunzip2 -- "$1"     ;;
           *.rar)       unrar x -- "$1"     ;;
           *.gz)        gunzip -- "$1"      ;;
           *.tar)       tar xvf -- "$1"     ;;
           *.tbz2)      tar xvjf -- "$1"    ;;
           *.tgz)       tar xvzf -- "$1"    ;;
           *.zip)       unzip -- "$1"       ;;
           *.Z)         uncompress -- "$1"  ;;
           *.7z)        7z x -- "$1"        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file"
   fi
}

# Get weather data for Bristol
weather() {
    echo BROOKLYN:
    curl -s "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=${@:-11229}"| perl -ne 's/&amp;deg;/°/g;/<title>([^<]+)/&&printf "%s:",$1;/<fcttext>([^<]+)/&&print $1,"\n"';
}

# Define a word using collinsdictionary.com
define() {
  curl -s "http://www.collinsdictionary.com/dictionary/english/$*" | sed -n '/class="def"/p' | awk '{gsub(/.*<span class="def">|<\/span>.*/,"");print}' | sed "s/<[^>]\+>//g";
}

#export GOPATH="$gopath"/Users/nissimlavy/go-projects:/Users/nissimlavy/dev/Webapp:
export GOPATH=/Users/nissimlavy/go-projects
export PATH=$PATH:$GOPATH/"$gopath"go/bin
