#!/usr/bin/zsh

set -e  # exit on error
set -o nounset  # exit when encounters an unset variable

LANGUAGES=("en_US" "zh_CN")

if [ $# -ne 1 ]  # Checking if 1 argument is given
then
  exit 1
fi

function for_every_asset_directory () {
  current_path=$(pwd)   # Certain qt tools can only be invoked in the
                        # same directory as the qml files

  for assets_dir in $(find . -regex "^\./qt5-ui-.*/extensions/assets$" -type d)
  do
    cd $assets_dir
    print -P "%B%F{blue}Inside ${assets_dir}:%f%b"
    print -P "%B%F{yellow}Finding '*.qml':%f%b"
    find *.qml && EXIT_CODE=0 || EXIT_CODE=1  # Throw error if no matches
    if [[ $EXIT_CODE -eq 0 ]]   # Check if exit code is 0 ('find' doesn't exit with error)
    then
      [[ $assets_dir =~ 'qt5-ui-([^/]+)' ]] && feat=$match[1]
                        # Use regex to capture the name of the feature
      $1 $feat
    fi
    cd $current_path
    echo ""
  done
}


function _lupdate () {
  for lang in $LANGUAGES
  do
    lupdate -extensions qml $(find *.qml | tr '\n' ' ') -ts translations/${1}.${lang}.ts >> /dev/null
  done
}

function _lrelease () {
  for lang in $LANGUAGES
  do
    lrelease translations/${1}.${lang}.ts >> /dev/null
  done
}

function _format () {
  qmlformat -i $(find *.qml | tr '\n' ' ')
}

function _lint () {
  qmllint $(find *.qml | tr '\n' ' ')
}

function _translation () {
  _lupdate $1
  _lrelease $1
}

function _translationdiff () {
  for lang in $LANGUAGES
  do
    cp translations/${1}.${lang}.ts translations/${1}.${lang}.tmp.ts
    lupdate -extensions qml $(find *.qml | tr '\n' ' ') -ts translations/${1}.${lang}.tmp.ts >> /dev/null
    diff translations/${1}.${lang}.tmp.ts translations/${1}.${lang}.ts && EXIT_CODE=0 || EXIT_CODE=1
    rm translations/${1}.${lang}.tmp.ts
    if [[ $EXIT_CODE -eq 1 ]]
    then
      exit 1
    fi

    lrelease translations/${1}.${lang}.ts -qm translations/${1}.${lang}.tmp.qm >> /dev/null
    cmp translations/${1}.${lang}.tmp.qm translations/${1}.${lang}.qm && EXIT_CODE=0 || EXIT_CODE=1
    rm translations/${1}.${lang}.tmp.qm
    if [[ $EXIT_CODE -eq 1 ]]
    then
      exit 1
    fi
  done
}

case $1 in
  update)
    for_every_asset_directory _lupdate
    ;;

  release)
    for_every_asset_directory _lrelease
    ;;

  format)
    for_every_asset_directory _format
    ;;

  lint)
    for_every_asset_directory _lint
    ;;

  translation)
    for_every_asset_directory _translation
    ;;

  translationdiff)
    for_every_asset_directory _translationdiff
    ;;

  *)
    echo "Invalid argument, must be 'update', 'release', 'lint', 'format', 'translation' or 'translationdiff'"
    exit 1
    ;;
esac

print -P "%B%F{green}Done \u2714%f%b"