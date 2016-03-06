#!/bin/sh
set -e

fm="$HOME/Copy/CODE/fractaled_mind"
jots="$fm/data/jots"

if [ -e "$jots" ]; then
  timestamp=$(date "+%Y%m%d%H%M")
  jot="$jots/$timestamp.yaml"

  if [ ! -e "$jot" ]; then
    echo "Jot : $jot"

cat <<- EOF > "$jot"
content: $1
EOF
  fi
fi

cd "$fm" && bundle exec middleman build

git --work-tree="$fm/build" --git-dir="$fm/build"/.git add -A
git --work-tree="$fm/build" --git-dir="$fm/build"/.git commit -m "Add new jot"
git --work-tree="$fm/build" --git-dir="$fm/build"/.git deploy
