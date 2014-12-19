function authme {
 ssh $1 'cat >>~/.ssh/authorized_keys' <~/.ssh/id_rsa.pub
}

setjdk() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
}

rvmify() {
  echo "$1" > .ruby-version
  echo "$2" > .ruby-gemset
}

function gcl {
  git clone git@github.com:$1.git
}

function f() {
  fab -f ~/code/uswitch/puppet/fabfile.py "$@"
}

function dead() {
  ssh deploy@$1 -p22 -l ubuntu -i ~/.ssh/uswitch-web-key.pem
}

function gitprunelocal() {
  git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
}

function qq {
  local repo="$HOME/code/$1"
  local uswitch="$HOME/code/uswitch/$1"
  if   [ -e $repo ] && [ -d $repo  ]; then cd $repo;
  elif [ -e $uswitch ] && [ -d $uswitch ]; then cd $uswitch;
  else echo "Repo or course not found: $1"; return 1;
  fi
}

_qq() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    projects=$(cd ~/code ; ls -d */. | sed 's/\/\.//g')
    uswitch=$(cd ~/code/uswitch ; ls -d */. | sed 's/\/\.//g')
    COMPREPLY=($(compgen -W "${projects} ${uswitch}" -- ${cur}))
}

complete -F _qq qq
