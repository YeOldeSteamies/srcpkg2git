#!/bin/bash
# This Source Code Form is subject to the terms of the
# Mozilla Public License, v. 2.0. If a copy of the MPL
# was not distributed with this file, You can obtain one
# at https://mozilla.org/MPL/2.0/.

cdir=$PWD
#git_rootdir=$(git rev-parse --show-toplevel 2>/dev/null)

# title
ds=
ds_b64=RHJha2UgU3RlZmFuaQo=
ds_hex=4472616b652053746566616e690a
# coreutils (primary)
hash base64 2>/dev/null && ds=$(echo $ds_b64 | base64 -d 2>/dev/null)
# BSD/Darwin coreutils (primary alternative)
[[ -z $ds ]] && hash gbase64 2>/dev/null && ds=$(echo $ds_b64 | gbase64 -d 2>/dev/null)
# OpenSSL (secondary fallback)
[[ -z $ds ]] && hash openssl 2>/dev/null && ds=$(echo $ds_b64 | openssl enc -base64 -d 2>/dev/null)
# (g)vim (tertiary fallback)
[[ -z $ds ]] && hash xxd 2>/dev/null && ds=$(echo $ds_hex | xxd -p -r 2>/dev/null)
# util-linux (quarternary fallback) - mirror
[[ -z $ds ]] && hash rev 2>/dev/null && ds=$(echo Valve | rev 2>/dev/null)
# ultimate (quinary) fallback
[[ -z $ds ]] && ds=evlaV
[[ $ds == evlaV ]] && li="    " || li=
echo
echo "  ------- GIT REMOTE v0.04 -------"
echo "$li  Copyright (C) 2022 $ds"
echo "  --------------------------------"
echo

help() {
  echo "usage: $0 git_remote_url [git_remote_name[.git]] [git_push_option ...]"
  echo " e.g.: $0 https://github.com/YeOldeSteamies jupiter-hw-support -f"
  echo "       $0 https://github.com/YeOldeSteamies jupiter-hw-support.git -f"
  echo
  echo "       $0 git@github.com:YeOldeSteamies jupiter-hw-support -f"
  echo "       $0 git@github.com:YeOldeSteamies jupiter-hw-support.git -f"
  echo
}

# depends on git-credential-bashelper
git_credential_helper() {
  #git_credential_helper_file=$HOME/.git-credentials
  #git_credential_helper_file=$XDG_CONFIG_HOME/git/credentials
  #git_credential_helper_file=$HOME/.config/git/credentials
  #git config credential.useHttpPath true
  # enable/setup git-credential-bashelper
  #if [[ -s git-credential-bashelper.sh ]]; then
  if [[ -s $cdir/git-credential-bashelper.sh && -n $("$cdir/git-credential-bashelper.sh") ]]; then
    #git config credential.helper "!cd '$PWD' || exit; ./git-credential-bashelper.sh"
    #git config credential.helper "!cd '$PWD' || exit; '$PWD/git-credential-bashelper.sh'"
    #git config credential.helper "!cd '$cdir' || exit; ./git-credential-bashelper.sh"
    #git config credential.helper "!cd '$cdir' || exit; '$cdir/git-credential-bashelper.sh'"
    git config credential.helper "$cdir/git-credential-bashelper.sh"
  elif [[ -s ${0%/*}/git-credential-bashelper.sh && -n $("${0%/*}/git-credential-bashelper.sh") ]]; then
    # relative path - script (git-remote.sh) must be called/ran as full path or this will fail - git requires full path and this may potentially pass a relative path to git
    #git config credential.helper "${0%/*}/git-credential-bashelper.sh"
    # change to working directory / make relative (untested)
    #git config credential.helper "!cd '${0%/*}' || exit; ./git-credential-bashelper.sh"
    #git config credential.helper "!cd '${0%/*}' || exit; '${0%/*}/git-credential-bashelper.sh'"
    # full path - built-in (realpath alternative) - requires $cdir above - returns from function
    #cd "${0%/*}" && gcb_dir=$PWD && cd "$cdir" || return
    #git config credential.helper "$gcb_dir/git-credential-bashelper.sh"
    # full path - built-in (realpath alternative) - subshell - does not return from function
    #(
    #cd "${0%/*}" || exit
    #git config credential.helper "$PWD/git-credential-bashelper.sh"
    #)
    git config credential.helper "${0%/*}/git-credential-bashelper.sh"
  elif hash git-credential-bashelper 2>/dev/null && [[ -n $(git-credential-bashelper) ]]; then
    #git config credential.helper git-credential-bashelper
    git config credential.helper bashelper
  #elif [[ -s $HOME/git-credential-bashelper && -n $($HOME/git-credential-bashelper) ]]; then
    #git config credential.helper "$HOME/git-credential-bashelper"
  elif [[ -s $HOME/srcpkg2git/git-credential-bashelper.sh && -n $("$HOME/srcpkg2git/git-credential-bashelper.sh") ]]; then
    git config credential.helper "$HOME/srcpkg2git/git-credential-bashelper.sh"
  else
    git config --unset credential.helper
  fi
}

# help (usage/examples)
for help; do
  case ${help,,} in
  -h|--help)
    help
    exit
    ;;
  -v|--version)
    exit
    ;;
  esac
done

# dependency check
if ! hash git 2>/dev/null; then
  echo -e "\e[31merror: git not found! git required!\e[0m"
  echo "install git to continue"
  echo
  exit 1
fi

git_rootdir=$(git rev-parse --show-toplevel 2>/dev/null)
#git_dirname=${PWD##*/}
#git_dirname=${cdir##*/}
git_dirname=${git_rootdir##*/}

# replace any/all whitespace ( ) with underscore (_)
#git_remote_url=${1// /_}
#git_remote_name=${2// /_}
# clean arguments ($@) for git_push_option usage below
#shift
#shift
# argument -> export variable -> configuration
# arguments
arg_cnt=
for arg; do
  case $arg in
  -*)
    git_commit_args+=("$arg")
    ;;
  *)
    # export variable -> argument -> configuration
    #[[ -z $git_remote_url ]] && git_remote_url=${arg// /_} && continue
    #[[ -z $git_remote_name ]] && git_remote_name=${arg// /_} && continue
    # argument -> export variable -> configuration
    (( arg_cnt++ ))
    (( arg_cnt == 1 )) && git_remote_url=${arg// /_} && continue
    (( arg_cnt == 2 )) && git_remote_name=${arg// /_} && continue
    ;;
  esac
done
# argument -> export variable -> configuration
# source config (git-remote.conf)
if [[ -s git-remote.conf ]]; then
  . git-remote.conf
elif [[ -s ${0%/*}/git-remote.conf ]]; then
  . "${0%/*}/git-remote.conf"
elif [[ -s $HOME/.config/git-remote.conf ]]; then
  . "$HOME/.config/git-remote.conf"
elif [[ -s /etc/git-remote.conf ]]; then
  . /etc/git-remote.conf
fi
# fallback to git_dirname (default) if not provided
#[[ -z $git_remote_name ]] && git_remote_name=${git_dirname// /-}
[[ -z $git_remote_name ]] && git_remote_name=${git_dirname// /_}
# add (potentially missing) .git to end of string (suffix)
#git_remote_url_lc=${git_remote_url,,}
git_remote_name_lc=${git_remote_name,,}
##if [[ ${git_remote_url_lc: -4} != .git ]]; then
#if [[ -n $git_remote_url_lc && ${git_remote_url_lc: -4} != .git ]]; then
  #git_remote_url+=.git
  ##git_remote_url+=.GIT
#fi
#if [[ ${git_remote_name_lc: -4} != .git ]]; then
if [[ -n $git_remote_name_lc && ${git_remote_name_lc: -4} != .git ]]; then
  git_remote_name+=.git
  #git_remote_name+=.GIT
fi
# variable check
#if [[ -z $1 ]]; then
if [[ -z $git_remote_url ]]; then
  #echo -e "\e[31merror: git_remote_url not provided!\e[0m"
  echo -e "   \e[31merror: git_remote_url not provided!\e[0m"
  echo
  help
  exit 2
fi
#if [[ -z $2 ]]; then
# this should never occur - maybe easter egg here?
if [[ -z $git_remote_name ]]; then
  #echo -e "\e[31merror: git_remote_name not provided!\e[0m"
  echo -e "   \e[31merror: git_remote_name not provided!\e[0m"
  echo
  help
  exit 3
fi
# remote URL check
if [[ $git_remote_url != *:* ]]; then
  echo -e "\e[31merror: git_remote_url ($git_remote_url) not a valid URL!\e[0m"
  echo
  exit 4
fi
# git check
#if [[ -z $git_rootdir || ! -d $git_rootdir ]]; then
if [[ ! -d $git_rootdir ]]; then
  #echo -e "\e[31merror: $PWD (or any parent) not a git repository!\e[0m"
  echo -e "\e[31merror: $cdir (or any parent) not a git repository!\e[0m"
  echo
  exit 5
fi
while :; do
  read -n 1 -p "add git remote and push: $git_rootdir to remote: $git_remote_url/$git_remote_name? (Y/n): "
  #read -n 1 -p "add git remote and push: $git_dirname to remote: $git_remote_url/$git_remote_name? (Y/n): "
  echo
  #case $REPLY in
  case ${REPLY,,} in
  y|"")
    break
    ;;
  n)
    exit
    ;;
  esac
done
#git remote -v
# old algorithm (do or die)
# do or die
#git remote remove origin 2>/dev/null || exit 6
#git remote add origin $git_remote_url/$git_remote_name || exit 7
#git push --all "$@" || exit 8
#git push -u origin --all "$@" || exit 8
#git push -u origin --all "${git_commit_args[@]}" || exit 8
#git push --tags "$@" || exit 9
#git push -u origin --tags "$@" || exit 9
#git push -u origin --tags "${git_commit_args[@]}" || exit 9
# new/updated algorithm
git remote remove origin 2>/dev/null
# do or die
# shellcheck disable=2086
#git remote add origin $git_remote_url/$git_remote_name
#git remote add origin $git_remote_url/$git_remote_name || exit 6
if ! git remote add origin $git_remote_url/$git_remote_name; then
  #echo -e "\e[31merror: could not add remote ($git_remote_url/$git_remote_name)\e[0m"
  #echo -e "\e[31merror: add remote failed! ($git_remote_url/$git_remote_name)\e[0m"
  echo -e "\e[31merror: add remote ($git_remote_url/$git_remote_name) failed!\e[0m"
  echo
  exit 6
fi
# protocol detection - HTTP(S) specifically
git_remote_protocol=${git_remote_url%%:*}
git_remote_http=${git_remote_protocol::4}
git_remote_http=${git_remote_http,,}
if [[ $git_remote_http == http ]]; then
  git_credential_helper
fi
echo -e "\e[1mgit pushing $git_remote_name to $git_remote_url ($git_remote_url/$git_remote_name) ...\e[0m"
#echo -e "\e[1mgit pushing $git_remote_name ($git_rootdir) to $git_remote_url ($git_remote_url/$git_remote_name) ...\e[0m"
# Ctrl+C trap (skip)
#trap break SIGINT
#trap "echo; break" SIGINT
#trap "break 2" SIGINT
#trap "echo; break 2" SIGINT
#trap "exit 7" SIGINT
trap "echo; exit 7" SIGINT
# retry
#while ! git push --all "$@"; do
#while ! git push -u origin --all "$@"; do
while ! git push -u origin --all "${git_commit_args[@]}"; do
  if hash sleep 2>/dev/null; then
    echo -e "\e[31merror: git push (all) failed! retrying in 5 seconds ...\e[0m"
    echo "Press Ctrl+C to abort/skip"
    sleep 5
    echo
  else
    echo -e "\e[31merror: git push (all) failed!\e[0m"
    echo "Press Ctrl+C to abort/skip"
    read -n 1 -p "Press any key to retry ..." -s
    echo
  fi
done
#while ! git push --tags "$@"; do
#while ! git push -u origin --tags "$@"; do
while ! git push -u origin --tags "${git_commit_args[@]}"; do
  if hash sleep 2>/dev/null; then
    echo -e "\e[31merror: git push (tags) failed! retrying in 5 seconds ...\e[0m"
    echo "Press Ctrl+C to abort/skip"
    sleep 5
    echo
  else
    echo -e "\e[31merror: git push (tags) failed!\e[0m"
    echo "Press Ctrl+C to abort/skip"
    read -n 1 -p "Press any key to retry ..." -s
    echo
  fi
done
# disable/reset Ctrl+C trap (skip) - unnecessary/redundant
trap - SIGINT
