#!/bin/bash
# This Source Code Form is subject to the terms of the
# Mozilla Public License, v. 2.0. If a copy of the MPL
# was not distributed with this file, You can obtain one
# at https://mozilla.org/MPL/2.0/.

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
echo "  ------- GIT COMMIT v0.02 -------"
echo "$li  Copyright (C) 2022 $ds"
echo "  --------------------------------"
echo

help() {
  #echo "usage: $0 git_commit_msg [git_commit_date]"
  echo "usage: $0 git_commit_msg [git_commit_date] [git_commit_option ...]"
  #echo " e.g.: $0 \"git commit message string\" \"git commit date override\" --amend --no-edit"
  echo " e.g.: $0 \"git commit message string\" \"April 7 13:14:15 PDT 2005\" --amend --no-edit"
  echo
}

# help (usage/example)
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

# moved/updated below
#[[ -z $git_commit_msg ]] && git_commit_msg=$1
#[[ -z $git_commit_date ]] && git_commit_date=$2

#git_amend=
#git_no_edit=
git_commit_args=()

# arguments
for arg; do
  case ${arg,,} in
  amend|--amend)
    #git_amend=--amend
    git_commit_args+=(--amend)
    ;;
  no-edit|--no-edit)
    #git_no_edit=--no-edit
    git_commit_args+=(--no-edit)
    ;;
  # prohibits git_commit_msg or git_commit_date which starts with (prefix) '-'
  -*)
    git_commit_args+=("$arg")
    ;;
  *)
    [[ -z $git_commit_msg ]] && git_commit_msg=$arg && continue
    [[ -z $git_commit_date ]] && git_commit_date=$arg && continue
    ;;
  esac
done

if [[ -z $git_commit_msg ]]; then
  echo -e "  \e[31merror: git commit message string (git_commit_msg) not provided!\e[0m"
  echo
  help
  exit 2
fi
if [[ -z $git_commit_date ]]; then
  git_commit_date=$(date)
  echo "Using current date/time: $git_commit_date"
#elif [[ -n $(date -d "$git_commit_date" 2>/dev/null) && $git_commit_date != $(date -d "$git_commit_date" 2>/dev/null) ]]; then
#elif [[ -n $(date -d "$git_commit_date" 2>/dev/null) && $git_commit_date != $(date -d "$git_commit_date") ]]; then
elif [[ -n $(date -d "$git_commit_date" 2>/dev/null) ]]; then
  #git_commit_date=$(date -d "$git_commit_date" 2>/dev/null)
  git_commit_date=$(date -d "$git_commit_date")
fi

#export GIT_COMMITTER_DATE="$git_commit_date"
#git commit -m "$git_commit_msg" --date "$git_commit_date"
# 2-in-1
#GIT_COMMITTER_DATE="$git_commit_date" git commit -m "$git_commit_msg" --date "$git_commit_date"
#GIT_COMMITTER_DATE="$git_commit_date" git commit $git_amend $git_no_edit -m "$git_commit_msg" --date "$git_commit_date"
#GIT_COMMITTER_DATE="$git_commit_date" git commit "${git_commit_args[@]}" -m "$git_commit_msg" --date "$git_commit_date"
#if ! GIT_COMMITTER_DATE="$git_commit_date" git commit -m "$git_commit_msg" --date "$git_commit_date"; then
#if ! GIT_COMMITTER_DATE="$git_commit_date" git commit $git_amend $git_no_edit -m "$git_commit_msg" --date "$git_commit_date"; then
if ! GIT_COMMITTER_DATE="$git_commit_date" git commit "${git_commit_args[@]}" -m "$git_commit_msg" --date "$git_commit_date"; then
  echo
  echo -e "  \e[31merror: git commit failed!\e[0m"
  echo
  exit 3
fi
