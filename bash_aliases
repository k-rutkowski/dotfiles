alias ls='exa'
alias bat='bat --color=always'
alias cat='bat'
alias du='dust'
alias cd='z'
alias f='fzf --preview "bat --color=always {}"'
alias vimf='fzf -m --preview="bat --color=always {}" --bind "enter:become(nvim {+})"'

alias c='clear'
alias l='ls -F'
alias la='ls -alF'
alias ll='ls -alFh --header --git --icons'
alias tree='ls --tree --level=4 -I=.git --git-ignore --header --git --icons'
alias df='df -h'
alias fastping='ping -i.2'
alias h='history'
alias j='jobs'
alias now='date +"%Y-%m-%d %T"'
alias nowd='date +"%Y-%m-%d"'
alias nowt='date +"%T"'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias su='sudo -i'
alias x='exit'

alias gs="git status"
alias gl="git log --oneline -n 10"
alias gll="git log --oneline -n 40"
alias gln="git log --oneline -n"
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gd="git diff"
alias gdc="git diff --staged"
