#!/bin/zsh

echo -e "\a" && tput bel
echo "This script will install a couple of tools.\nIt will always beep when the next package is about to be installed just as you just heard.\nYou will then have 5 seconds to skip the installation of the current package by pressing any key.\nWait 10 seconds or press any key to continue"
read -t 10 -k -s

if [ ! -d  "bashrc-tmux" ]; then
  echo "About to install bashrc-tmux, press any key to skip."
  echo -e "\a" && tput bel
  read -t 5 -k -s
  if [[ $? -eq 1 ]]; then
    echo "Installing bashrc-tmux..."
    git clone git@github.com:clelange/bashrc-tmux.git
  else
    echo "Skipping installation of bashrc-tmux."
  fi
else
  echo "bashrc-tmux already installed."
fi

which brew > /dev/null
if [[ $? -eq 1 ]]; then
  echo "About to install homebrew, press any key to skip."
  echo -e "\a" && tput bel
  read -t 5 -k -s
  if [[ $? -eq 1 ]]; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "Skipping installation of homebrew."
  fi
else
  echo "homebrew already installed."
fi

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "About to install oh-my-zsh, press any key to skip."
  echo -e "\a" && tput bel
  read -t 5 -k -s
  if [[ $? -eq 1 ]]; then
    echo "Installing oh-my-zsh..."
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  else
    echo "Skipping installation of oh-my-zsh."
  fi
else
  echo "oh-my-zsh already installed."
fi
