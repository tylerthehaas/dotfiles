#!b/in/bash
echo running .bash_profile

unset COLUMNS # to prevent ps from truncating lines
set noclobber

# Files to ignore in filename completion.
export FIGNORE='.o:.swp'

# Look for libraries in standard places.
export LD_LIBRARY_PATH=.:$HOME/lib:/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH

#-------------------------------------------------------------------------

export PATH="/Users/tyler.haas/.local/bin:$PATH"

# Commonly used directory prefixes.

export DROPBOX_DIR=$HOME/Dropbox
export PROGRAMMING_DIR=$HOME/programming
export DATABASES_DIR=$PROGRAMMING_DIR/databases
export LANGUAGES_DIR=$PROGRAMMING_DIR/languages
export CSS_DIR=$LANGUAGES_DIR/CSS
export HTML_DIR=$LANGUAGES_DIR/html
export JAVA_DIR=$LANGUAGES_DIR/java
export JAVASCRIPT_DIR=$LANGUAGES_DIR/javascript
export JQUERY_DIR=$JAVASCRIPT_DIR/jquery
export MONGODB_DIR=$DATABASES_DIR/MongoDB
export TOMCAT_HOME=$HOME/tools/apache-tomcat-8.5.23
export TOOLS_DIR=$HOME/tools

# Ant settings
export ANT_HOME=$JAVA_DIR/Ant/apache-ant-1.8.2
export PATH=$ANT_HOME/bin:$PATH

# AsciiDoc settings
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

# coreutils settings
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Clojure settings
#export CLOJURE_HOME=$LANGUAGES_DIR/clojure/clojure-1.2.1
#export CLOJURE_HOME=/opt/clojure-1.5.1 # for RPi
#alias clj="java -cp $CLOJURE_HOME/clojure-1.5.1.jar clojure.main"

# Git settings
#export PATH=$PATH:/usr/local/git/bin
export GITHUB_USER=tylerthehaas
#export GITHUB_PASS=

# Java settings
# export JAVA_HOME=$(/usr/libexec/java_home)

# JavaScript settings
# export JS_CMD=node
# export JS_DIR=$LANGUAGES_DIR/javascript

# Maven settings
export MAVEN_HOME='/usr/local/'
export PATH=$PATH:$HOME/apache-maven-3.0.3/bin
export MAVEN_OPTS="-Xmx512m -XX:PermSize=348m"

# MongoDB settings
#export PATH=$PATH:$MONGODB_DIR/mongodb-osx-x86_64-2.4.3/bin

# MySQL settings
#export PATH=$PATH:/usr/local/mysql-5.0.51a-osx10.5-x86/bin

# Node.js settings
export NODE_PATH=.:/usr/local/lib/node_modules # Mocha needs this
export PATH=$PATH:$NODE_DIR/deps/v8/tools

# Postgres settings
#export PATH=$PATH:$POSTGRES_DIR/bin

# React Native settings
export ANDROID_HOME=/usr/local/opt/android-sdk
#export GRADLE_OPTS="-Dorg.gradle.daemon=true"

# Ruby settings
export RUBY_DIR=$LANGUAGES_DIR/Ruby
export RUBY_HOME=$HOME/.rbenv/versions/1.9.1-p430/bin
export PATH=$RUBY_HOME:$PATH
#export RUBY_HOME=/usr/local/lib/ruby
#export PATH=/usr/local/bin:$PATH
#export PATH=$PATH:/usr/local/Cellar/ruby/1.9.2-p290/bin
export RUBYOPT=-rubygems
# Tell less not to complain about ANSI escape codes, and run ri.
alias ri='RI="${RI} -f ansi" LESS="${LESS}-f-R" ri'

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

# Rust settings
export PATH="$HOME/.cargo/bin:$PATH"

# Subversion settings
export SVN_PREFIX=svn+ssh://oci-svn/education/training/tracks

# Tomcat settings
#export TOMCAT_HOME=$JAVA_DIR/Tomcat/apache-tomcat-7.0.41
#export BASEDIR=$TOMCAT_HOME
#export CATALINA_HOME=$TOMCAT_HOME

# TypeScript settings
export PATH=$PATH:~/programming/typescript/TypeScript/bin

# TypeScript settings
export PATH=$PATH:$LANGUAGES_DIR/TypeScript/ts1.5/bin

# Google Traceur settings
export PATH=$PATH:$JAVASCRIPT_DIR/traceur-compiler-master

# Vim settings
set -o vi # for vi-mode command-line editing
set editing-mode vi # for vi-mode command-line editing and all utilities that use readline
export EDITOR=vim
export VISUAL=vim
alias vim='/usr/local/bin/vim'

# Yarn
# export PATH="$PATH:`yarn global bin`:$HOME/.config/yarn/global/node_modules/.bin"

# When running multiple bash shells, allow all to write to history
# without overwriting each other.
# shopt -s histappend

# Don't retain duplicate commands in history.
export HISTCONTROL=ignoredups

# Show Git information in prompt.
# See https://github.com/matthewmccullough/MatthewsShellConfig
#source ~/.bash_gitprompt

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

#export TERM=xterm-256color-italic
export TERM=xterm-256color

# artifactory

export OCT_ARTIFACTORY_USER=readonly
export OCT_ARTIFACTORY_PASS=AP9tz2RMKavpt46upJgfhsV9WPJ
export TOKEN_HEX_KEY=AKCp5ZjzFsbXUprxVD1mewBsz4pqWKRqZGEDNYYqkEnG89dKh51hgDGZ6bMsksyWuH5N8EdYN

# OCTANNER
export OCT_DIR=$HOME/Projects/octanner
export PATH=$PATH:/Users/tyler.haas/.appreciatekit/bin
export commonauth_server_users=https://users-jam-stg.alamoapp.octanner.io
export commonauth_domain=localhost.awardselect.com
export commonauth_server_auth=https://fedstg.octanner.io
export commonauth_redirect_uri=http://localhost.awardselect.com:8080/common/Auth
export commonauth_client_id=stg_career_achievement_ui
export commonauth_app_auth_uri=http://localhost.awardselect.com:8080/a
export commonauth_client_secret=14FdkWuVZNCk0wkGbrzOd94Q
export commonauth_yb_login_url=http://localhost.awardselect.com:8080/commonauth/login
export commonauth_private_key=30820275020100300d06092a864886f70d01010105000482025f3082025b02010002818100d8b843d1c31808073577ab0f89579d6a55f0da91999861a43b37c080a0684deaa2e7e91f47171151c58783cdec332612374d581cabfd25580951049028b4e1e5a110f2f1a7cd9a4a2ce440b7ca6918b073820705c25d6fa6dce4552f7d48e28f6a71b8c970e766ff7ea9d11b41aade6b5b963b382c530731afa0b9e33e629f310203010001028180159f950cb9e58cef8333347b315def93eb8d4391a17ca5c9682b30e6e49a63a3d4ab45045ce87d4ee661961216ce27af4b9b48fe5b5ebfba1ffbd873b5cc0e79d6da8f49431ed85dbc458465cb84887c0bc48725348ab92c5d5218452c338317ff5a142ede69fabf67582250ea95553c59eb8c389521ca3dba7692a1816e227d024100f972cb6b7a8dca8802a466a60ed1b327fe48c04feef9c09ac26e678034dfbfcef13c1cbb922032e7aa2869faadd3ebbb734d45de15317514a010c0ad311e3e93024100de696a0be571c964ba95a44df2c796fee03c91751f9ddf149e6091981677ce2b239603af7efc16a33311f4f6f71d127d33cf0a68cbfcfd8521df67923536c1ab02400a3b2b1cbd6a136480b73d7e921d07bc1c31dfb1679bd6ca822f050fbd1b70428ca26a8b46f30b2375573301951f9c0b942f172e84b0029d55f359f3c08ffd0102402b441c7215ff6dab1fb4ee928f510e69a49b83bc621b27036ecfe062d2b419b240a8f52c95aa5a8902ed52571cb956186f14aeb4b6420fdb6f3c737c78c79f230240208ddf7ba31442e441b18b5fa849dcc6355ba11c19247373b2a391c79f3bd76b4895ebf1c97435a6d7b78f1294b3d80489ee56fc5d293658045e2fd22787a09a
export commonauth_public_key=30819f300d06092a864886f70d010101050003818d0030818902818100d8b843d1c31808073577ab0f89579d6a55f0da91999861a43b37c080a0684deaa2e7e91f47171151c58783cdec332612374d581cabfd25580951049028b4e1e5a110f2f1a7cd9a4a2ce440b7ca6918b073820705c25d6fa6dce4552f7d48e28f6a71b8c970e766ff7ea9d11b41aade6b5b963b382c530731afa0b9e33e629f310203010001
export commonauth_server_users=https://users-jam-stg.alamoapp.octanner.io
export commonauth_domain=awardselect.com
export commonauth_server_auth=https://fedstg.octanner.io
export commonauth_redirect_uri=https://localhost.awardselect.com:8443/common/Auth
export commonauth_client_id=stg_career_achievement_ui_x
export commonauth_app_auth_uri=https://localhost.awardselect.com:8443/a
export commonauth_client_secret=p30ZlEtwUjh99EdnGqCP0GV5l8voupqpwrBf
export commonauth_yb_login_url=https://localhost.awardselect.com:8443/a/commonauth/login
export commonauth_private_key=30820275020100300d06092a864886f70d01010105000482025f3082025b02010002818100d8b843d1c31808073577ab0f89579d6a55f0da91999861a43b37c080a0684deaa2e7e91f47171151c58783cdec332612374d581cabfd25580951049028b4e1e5a110f2f1a7cd9a4a2ce440b7ca6918b073820705c25d6fa6dce4552f7d48e28f6a71b8c970e766ff7ea9d11b41aade6b5b963b382c530731afa0b9e33e629f310203010001028180159f950cb9e58cef8333347b315def93eb8d4391a17ca5c9682b30e6e49a63a3d4ab45045ce87d4ee661961216ce27af4b9b48fe5b5ebfba1ffbd873b5cc0e79d6da8f49431ed85dbc458465cb84887c0bc48725348ab92c5d5218452c338317ff5a142ede69fabf67582250ea95553c59eb8c389521ca3dba7692a1816e227d024100f972cb6b7a8dca8802a466a60ed1b327fe48c04feef9c09ac26e678034dfbfcef13c1cbb922032e7aa2869faadd3ebbb734d45de15317514a010c0ad311e3e93024100de696a0be571c964ba95a44df2c796fee03c91751f9ddf149e6091981677ce2b239603af7efc16a33311f4f6f71d127d33cf0a68cbfcfd8521df67923536c1ab02400a3b2b1cbd6a136480b73d7e921d07bc1c31dfb1679bd6ca822f050fbd1b70428ca26a8b46f30b2375573301951f9c0b942f172e84b0029d55f359f3c08ffd0102402b441c7215ff6dab1fb4ee928f510e69a49b83bc621b27036ecfe062d2b419b240a8f52c95aa5a8902ed52571cb956186f14aeb4b6420fdb6f3c737c78c79f230240208ddf7ba31442e441b18b5fa849dcc6355ba11c19247373b2a391c79f3bd76b4895ebf1c97435a6d7b78f1294b3d80489ee56fc5d293658045e2fd22787a09a
export commonauth_public_key=30819f300d06092a864886f70d010101050003818d0030818902818100d8b843d1c31808073577ab0f89579d6a55f0da91999861a43b37c080a0684deaa2e7e91f47171151c58783cdec332612374d581cabfd25580951049028b4e1e5a110f2f1a7cd9a4a2ce440b7ca6918b073820705c25d6fa6dce4552f7d48e28f6a71b8c970e766ff7ea9d11b41aade6b5b963b382c530731afa0b9e33e629f310203010001
export COMMON_JACKET_BASE_URL=https://commonuijacket-perf-prd.alamoapp.octanner.io/app.bundle
source ~/.bashrc

