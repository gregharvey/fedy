#!/bin/bash

cat <<EOF | tee /etc/profile.d/color_prompt.sh > /dev/null 2>&1
# Check for Git availability
if hash git 2> /dev/null; then

  # Git helper functions
  function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
  }
   function parse_git_stash {
    [[ $(git stash list 2> /dev/null | tail -n1) != "" ]] && echo "^"
  }
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)$(parse_git_stash)/"
  }

  # Colors in Terminal (Bash) - with Git branches
  if [[ ! -z $BASH ]]; then
    if [[ $EUID -eq 0 ]]; then
      PS1='\[\033[33m\][\[\033[m\]\[\033[31m\]\u@\h\[\033[m\] \[\033[33m\]\W \[\e[0;36m\]$(parse_git_branch)\[\e[m\]\[\033[m\]\[\033[36m\]]\[\033[m\] # '
    else
      PS1='\[\033[36m\][\[\033[m\]\[\033[34m\]\u@\h\[\033[m\] \[\033[32m\]\W \[\e[0;36m\]$(parse_git_branch)\[\e[m\]\[\033[m\]\[\033[36m\]]\[\033[m\] $ '
    fi
  fi

else

  # Colors in Terminal (Bash)
  if [[ ! -z \$BASH ]]; then
    if [[ \$EUID -eq 0 ]]; then
      PS1="\[\033[33m\][\[\033[m\]\[\033[31m\]\u@\h\[\033[m\] \[\033[33m\]\W\[\033[m\]\[\033[33m\]]\[\033[m\] # "
    else
      PS1="\[\033[36m\][\[\033[m\]\[\033[34m\]\u@\h\[\033[m\] \[\033[32m\]\W\[\033[m\]\[\033[36m\]]\[\033[m\] \$ "
    fi
  fi

fi
EOF
