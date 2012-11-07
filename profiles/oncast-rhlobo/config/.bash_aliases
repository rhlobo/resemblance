#!/bin/bash 

# ALIASES
alias clip='xclip -selection c'
alias dateclip='date | clip'

alias chrome='google-chrome'
alias jeclipse='~/dev/eclipseJava/eclipse'
alias peclipse='~/dev/eclipseCpp/eclipse'
alias ceclipse='~/dev/eclipseCpp/eclipse'
alias sublime='~/dev/sublimeText/sublime_text'

alias gmail='/opt/google/chrome/google-chrome --app=http://www.gmail.com'
alias gdocs='/opt/google/chrome/google-chrome --app=http://drive.google.com'
alias xpi='/opt/google/chrome/google-chrome --app=http://portal.xpi.com.br'
alias financeiro='/opt/google/chrome/google-chrome --app=https://docs.google.com/spreadsheet/ccc?key=0Ag5Sx215sW9PdGo2aHV0QmJpUHRyNGV4Q2ZmQURPdEE#gid=1'

alias worktime='/opt/google/chrome/google-chrome --app=http://ontrack.heroku.com/worktimes'
alias workreport='google docs edit workTrack --editor=vim'
alias ontrack='/opt/google/chrome/google-chrome --app=http://ontrack.oncast.com.br'
alias oncast='gmail & worktime & ontrack & jeclipse & workreport'
alias ontrackssh='ssh -i ~/dropbox/files/oncast/ontrack/ontrackkey.prod.pem ubuntu@54.232.122.88'
alias ontracksshstag='ssh -i ~/dropbox/files/oncast/ontrack/ontrackkey.stag.pem ubuntu@10.252.136.227'


# FUNCTIONS
function encode() { echo -n $@ | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'; }

function goo() { google-chrome http://www.google.com/search?hl=en#q="`encode $@`" ;}

# PATH
CDPATH='.:~:~/dev'
