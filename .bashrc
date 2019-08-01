#!/bin/bash
echo running .bashrc

# This doesn't work on Mac, but does on RPi.
#xmodmap ~/.xmodmap

# Source global definitions.
# if [ -f /etc/bashrc ]; then
#   . /etc/bashrc
# fi

# Disable start/stop output control so
# ctrl-s can be used in Vim to save and
# ctrl-q can be used by unimpaired plugin.
#stty -ixon

# Sets the bash shell prompt.
# This overrides the setting in /etc/bashrc.
# \h outputs the host name.
# \W outputs the working directory.
# \w outputs the full working directory.
# \$ outputs # if superuser (like root), $ otherwise.
# Single quotes delay evaluation until each time prompt is output.
# Do this in /root/.bashrc too.
# export PS1='\W\$ ' # sets bash shell prompt
#export PS1='\[\e[0;35m\]\h:\[\e[0;36m\]\w\[\e[0;32m\]$(__git_ps1 " [%s]")\[\e[m\]$ '
#export PS1='\[\e[0;36m\]\W\[\e[0;32m\]$(__git_ps1 " [%s]")\[\e[m\]$ '

#---------------------------------------------------------------------------
# Aliases
#---------------------------------------------------------------------------

alias bigfiles="find . -type f -size +1000k -exec ls -lk {} \; | awk '{print \$5, \$9}' | sort -nr +1 | head"
alias bigdirs="du -sk * | sort -nr | head"

#alias cdangular='cd $JAVASCRIPT_DIR/AngularJS'
#alias cdbmx='cd $BMX_DIR'
#alias cddropbox='cd $DROPBOX_DIR'
#alias cdjava='cd $JAVA_DIR'
#alias cdjavascript='cd $JAVASCRIPT_DIR'
#alias cdjug='cd $JAVA_DIR/JUG'
#alias cdjq='cd $JQUERY_DIR'
#alias cdjs='cd $JAVASCRIPT_DIR'
#alias cdlanguages='cd $LANGUAGES_DIR'
#alias cdmaritz='cd $MARITZ_DIR'
#alias cdmyoci='cd $MYOCI_DIR'
#alias cdnode='cd $JAVASCRIPT_DIR/Node.js'
#alias cdnotes='cd ~/MyUnixEnv/notes'
#alias cdoci='cd $OCI_DIR'
#alias cdprogramming='cd $PROGRAMMING_DIR'
#alias cdrga='cd $RGA_DIR'
#alias cdruby='cd $RUBY_DIR'
#alias cdsett='cd $SETT_DIR'
#alias cdtraining='cd $TRAINING_DIR'
#alias cdvim='cd $PROGRAMMING_DIR/Tools/Vim'

# Misc aliases

# Git aliases
alias br='git branch'
alias nbr='git checkout -b'
alias dbr='git branch | grep -v "master" | xargs git branch -D'
alias ci='git commit -av'
alias co='git checkout'
alias lg='git log -p'
alias pull='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias push='git push origin `git rev-parse --abbrev-ref HEAD`'
alias sha='git rev-parse HEAD'
alias st='git status'
# status report from git commits
alias sr='git log --author="haas" --branches --no-merges --since="8 days ago" --pretty=format:"%cd %s" | tac'

# Ask for confirmation before overwriting or deleting files.
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# For a nicely formatted dump of LD_LIBRARY_PATH ...
alias eld="echo LD_LIBRARY_PATH :; echo -n '   ';echo \$LD_LIBRARY_PATH |sed 's/:/\n   /g'"

# Code printing (fancy two columns)
alias ens="enscript --borders --columns=2 --fancy-header --landscape --line-numbers=1 --mark-wrapped-lines=arrow --pretty-print=cpp"
alias ens1="enscript --borders --fancy-header --line-numbers=1 --mark-wrapped-lines=arrow --pretty-print=cpp -L63"

alias findcss="find3 css"
alias findhtml="find3 html"
alias findhtml1="find-depth-1 html"
#alias findjava="find3 java"
alias findjs="find3 js"
alias findjs2="find4 js"
alias findjson="find3 json"
alias findless="find3 less"

# ESLint aliases
alias esl="clear; eslint -f codeframe **/*.js"
# Fix ESLint issues in a JavaScript file, including adding missing semicolons.
# ex. fixsemi some-name.js
alias fixsemi="eslint --fix --rule 'semi: [2, always]'"
# Fix ESLint issues in a JavaScript file, including removing unnecessary semicolons.
# ex. fixnosemi some-name.js
alias fixnosemi="eslint --fix --rule 'semi: [2, never]'"

# Goes to root directory of current git repo.
alias cdgitroot='cd `git rev-parse --git-dir`; cd ..'

# Display directories and executables in different colors.
#alias ls='ls --color=tty'
alias ls='ls -G'
alias ll='ls -lh -a'

# See MySQLNotes.txt for steps to start mysqld, the daemon.
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

# Traceur for ES6
alias es6='traceur --experimental'

# For a nicely formatted dump of any path delimited with colons ...
# To use this enter "echo $PATH | nicepath".
alias nicepath="tr ':' '\n'"

# This is just like nicepath, but used when the path is delimited with spaces.
alias nicepathspaces="sed 's/ /\n   /g'"

# CTAGS
# alias ctags="`brew --prefix`/bin/ctags"

alias sortedpath="ruby -e 'puts ENV[\"PATH\"].split(File::PATH_SEPARATOR).sort'"

#complete -C complete-ant-cmd.pl ant build.sh

# Kill the process listening on a given port.
alias klp="kill-listening-process"

# For React Native
alias rna="react-native run-android"
alias rni="react-native run-ios"

# O.C. Tanner aliases

alias milestones-start="$TOOLS_DIR/apache-tomcat-8.5.23/bin/startup.sh ; sleep 1; tail -f $TOOLS_DIR/apache-tomcat-8.5.23/logs/catalina.out"
alias milestones-stop="$TOOLS_DIR/apache-tomcat-8.5.23/bin/shutdown.sh"

#----------------------------------------------------------------------------

# Moves to any directory within O.C. Tanner Projects
function oct {
  cd "$HOME/Projects/octanner/$1"
}

 function setTitle {
   Mac OS X Terminal
   echo -ne "\e]2;$@\a\e]1;$@\a";
 }
# typeset -fx setTitle
# alias st=setTitle

#source ~/.nvm/nvm.sh
ctags=/usr/local/bin/ctags

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

alias java8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8);export
PATH=$JAVA_HOME/bin:/Users/cameron.shellum/apps/lien:$PATH'

alias java7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7);export
PATH=$JAVA_HOME/bin:/Users/cameron.shellum/apps/lien:$PATH'

export java8
alias config='/usr/bin/git --git-dir=/Users/tyler.haas/.cfg/ --work-tree=/Users/tyler.haas'
