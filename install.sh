#!/bin/sh

mkdir -p ~/.bin
curl -s "https://raw.githubusercontent.com/qwertzguy/git-quick/master/git-quick" > ~/.bin/git-quick
chmod 755 ~/.bin/git-quick
[ ! -f ~/.profile ] && touch ~/.profile
grep -Fx -m 1 "export PATH=\$PATH:$HOME/.bin" ~/.profile > /dev/null || echo "export PATH=\$PATH:$HOME/.bin" >> ~/.profile
export PATH=$PATH:$HOME/.bin
echo "Installed. Type git quick in a git repository for usage."
