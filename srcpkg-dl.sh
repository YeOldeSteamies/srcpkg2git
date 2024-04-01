#!/bin/bash
# This Source Code Form is subject to the terms of the
# Mozilla Public License, v. 2.0. If a copy of the MPL
# was not distributed with this file, You can obtain one
# at https://mozilla.org/MPL/2.0/.

# shellcheck disable=2128
cdir=$PWD
srcpkg_dl_dir="${cdir:-$PWD}/SRCPKG2GIT/.DL"
#srcpkg_remote_file=/tmp/srcpkg_remote.html
srcpkg_remote_file="$srcpkg_dl_dir/srcpkg_remote.html"
# set to override/use numerical naming (srcpkg_remote_file_no_ext + _NUMBER + [.] + srcpkg_remote_file_ext) - OVERRIDES srcpkg_remote_file
#srcpkg_remote_file_no_ext=/tmp/srcpkg_remote
srcpkg_remote_file_no_ext="$srcpkg_dl_dir/srcpkg_remote"
srcpkg_remote_file_ext="html"
query_str='?C=M&O=D'

error=
#srcpkg_remote_file_count=0
srcpkg_remote_file_count=
#srcpkg_update_name=
srcpkg_update_name=()
#srcpkg_update_file=
srcpkg_update_file=()
#srcpkg_update_url=
srcpkg_update_url=()
srcpkg_name_reduce_str=
srcpkg_name_redundant=()
# ironically redundant - already counted (srcpkg_update_name)
#srcpkg_name_unique=()
srcpkg_update_timestamp=()
conv_srcpkg_array=()

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
echo "  -------- SRCPKG DL v0.4 --------"
echo "$li  Copyright (C) 2022 $ds"
echo "  --------------------------------"
echo

# help (usage/examples)
for help; do
  case ${help,,} in
  -h|--help)
    #echo "usage: $0 [remote (HTML) URL/PATH ...]"
    #echo "usage: $0 [remote/local (HTML) URL/PATH ...]"
    #echo "usage: $0 [remote/local (HTML) URL/PATH ...] [[--][jupiter-]332|333|35|36|stable|beta|main|staging|rel|aio|all] [[--]holo[-333|-35|-36|-stable|-beta|-main|-staging|-rel|-aio|-all]] [[--]aio|all]"
    #echo "usage: $0 [remote/local (HTML) URL/PATH ...] [[--][jupiter-]{332|333|35|36|stable|beta|main|staging|rel|aio|all}] [[--]holo[{-333|-35|-36|-stable|-beta|-main|-staging|-rel|-aio|-all}]] [[--]{aio|all}]"
    echo "usage:"
    echo "  $0 [remote/local (HTML) URL/PATH ...] [[--]jupiter[{-332|-333|-35|-36|-stable|-beta|-main|-staging|-rel|-aio|-all}]] [[--]holo[{-333|-35|-36|-stable|-beta|-main|-staging|-rel|-aio|-all}]] [[--]{aio|all}]"
    echo
    echo " e.g.:"
    #echo "  $0 'https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources/jupiter/$query_str'"
    echo "  $0 'https://example.com/$query_str'"
    echo "  $0 '/path/to/file1.html$query_str' 'file:///path/to/file2.html$query_str'"
    #echo "  $0 --jupiter-main --jupiter-beta --holo"
    echo "  $0 --jupiter-main --holo-main"
    echo
    echo " options:"
    echo "  -h|--help"
    echo "  ❔ show this help message and exit"
    echo "  -v|--version"
    echo "  ℹ️  show version information and exit"
    echo
    echo "  --auto|--automate|--automatic|--bot"
    echo "  🤖 enable auto/bot mode (no prompt)"
    echo
    echo "  --fast-forward-update|--ff-update|"
    echo "  --mask-update|--masquerade-update|--pseudo-update"
    echo "  ⏩ fast forward / skip to latest package update sans/without downloading"
    echo "  🥸 (AKA mask/masquerade/pseudo update)"
    echo
    echo "  jupiter-332|--jupiter-332"
    echo "  📦 jupiter-3.3.2"
    echo "  jupiter-333|--jupiter-333"
    echo "  📦 jupiter-3.3.3"
    echo "  jupiter-35|--jupiter-35"
    echo "  📦 jupiter-3.5"
    echo "  jupiter-36|--jupiter-36"
    echo "  📦 jupiter-3.6"
    echo
    echo "  jupiter|--jupiter|jupiter-stable|--jupiter-stable"
    echo "  📦 jupiter-stable"
    echo "  jupiter-beta|--jupiter-beta"
    echo "  📦 jupiter-beta"
    echo "  jupiter-main|--jupiter-main"
    echo "  📦 jupiter-main"
    echo "  jupiter-staging|--jupiter-staging"
    echo "  📦 jupiter-staging"
    echo "  jupiter-rel|--jupiter-rel"
    echo "  📦 jupiter-rel"
    echo "  jupiter-aio|--jupiter-aio|jupiter-all|--jupiter-all"
    echo "  📦 jupiter all-in-one (AIO) - all of the above (jupiter)"
    echo
    echo "  holo-333|--holo-333"
    echo "  📦 holo-3.3.3"
    echo "  holo-35|--holo-35"
    echo "  📦 holo-3.5"
    echo "  holo-36|--holo-36"
    echo "  📦 holo-3.6"
    echo
    echo "  holo|--holo|holo-stable|--holo-stable"
    echo "  📦 holo-stable"
    echo "  holo-beta|--holo-beta"
    echo "  📦 holo-beta"
    echo "  holo-main|--holo-main"
    echo "  📦 holo-main"
    echo "  holo-staging|--holo-staging"
    echo "  📦 holo-staging"
    echo "  holo-rel|--holo-rel"
    echo "  📦 holo-rel"
    echo "  holo-aio|--holo-aio|holo-all|--holo-all"
    echo "  📦 holo all-in-one (AIO) - all of the above (holo)"
    echo
    echo "  aio|--aio|all|--all"
    echo "  📦 jupiter/holo all-in-one (AIO) - all of the above (jupiter/holo)"
    #echo "  📦 holo/jupiter all-in-one (AIO) - all of the above (holo/jupiter)"
    echo
    exit 0
    ;;
  -v|--version)
    exit 0
    ;;
  esac
done

# dependency check
for dep in curl grep xmllint; do
  if ! hash $dep 2>/dev/null; then
    echo -e "\e[31merror: $dep not found! $dep required!\e[0m"
    echo "install $dep to continue"
    echo
    #exit 1
    error=1
    #error+="$dep "
    #error+="$dep, "
  fi
done
if [[ -n $error ]]; then
  #echo
  #echo "install ${error: -1} to continue"
  #echo "install ${error: -2} to continue"
  #echo
  exit 1
fi

# whitespace buffer between (potential) export variable and configuration
[[ -n $srcpkg_remote ]] && srcpkg_remote+=" "
# export variable -> configuration -> argument
# source config (srcpkg-dl.conf)
if [[ -s srcpkg-dl.conf ]]; then
  . srcpkg-dl.conf
elif [[ -s ${0%/*}/srcpkg-dl.conf ]]; then
  . "${0%/*}/srcpkg-dl.conf"
elif [[ -s $HOME/.config/srcpkg-dl.conf ]]; then
  . "$HOME/.config/srcpkg-dl.conf"
elif [[ -s /etc/srcpkg-dl.conf ]]; then
  . /etc/srcpkg-dl.conf
fi

# inefficient
#if mkdir -p "$srcpkg_dl_dir"; then
  #cd "$srcpkg_dl_dir" || exit 2
#else
  #echo -e "\e[31merror: download directory ($srcpkg_dl_dir) could not be made!\e[0m"
  #echo
  #exit 2
#fi
# compact/efficient
if [[ ! -d $srcpkg_dl_dir ]] && ! mkdir -p "$srcpkg_dl_dir"; then
  #echo -e "\e[31merror: download directory ($srcpkg_dl_dir) could not be made!\e[0m"
  echo -e "\e[31merror: download directory ($srcpkg_dl_dir) could not be found or made!\e[0m"
  #echo -e "\e[31merror: download directory ($srcpkg_dl_dir) could not be found/made!\e[0m"
  echo
  exit 2
fi
cd "$srcpkg_dl_dir" || exit 2

dl_error() {
#if [[ -n $2 ]]; then
if [[ -n $1 && -n $2 ]]; then
  #echo -e "\e[31m$1 download error! download URL: $2\e[0m"
  echo -e "\e[31m$1 ($2) download error!\e[0m"
elif [[ -n $1 ]]; then
  echo -e "\e[31m$1 download error!\e[0m"
elif [[ -n $2 ]]; then
  echo -e "\e[31m$2 download error!\e[0m"
else
  echo -e "\e[31mdownload error!\e[0m"
  #return
fi
if [[ -e $1 ]]; then
  #rm -f "$1"
  #rm -fv "$1"
  #rm -i "$1"
  rm -iv "$1"
#else
  # redirect (potential) error output (stderr) to /dev/null - bypass/skip checking for sleep binary/command (hash) - dependency check bypass/skip - optional dependency
  ##sleep 5 2>/dev/null
  #hash sleep 2>/dev/null && sleep 5
elif hash sleep 2>/dev/null; then
  #echo "Continuing in 5 seconds ..."
  #echo "Retrying in 5 seconds ..."
  echo "Continuing/Retrying in 5 seconds ..."
  echo
  sleep 5
else
  #read -n 1 -p "Press any key to continue ..." -s
  #read -n 1 -p "Press any key to retry ..." -s
  read -n 1 -p "Press any key to continue/retry ..." -s
  echo
fi
}

steamos_src_url=https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources
#steamos_src_url=https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources/
# shellcheck disable=2034
steamos_src_url_query=$steamos_src_url/$query_str
jupiter_332_url=$steamos_src_url/jupiter-3.3.2/$query_str
jupiter_333_url=$steamos_src_url/jupiter-3.3.3/$query_str
jupiter_35_url=$steamos_src_url/jupiter-3.5/$query_str
jupiter_36_url=$steamos_src_url/jupiter-3.6/$query_str
jupiter_stable_url=$steamos_src_url/jupiter/$query_str
jupiter_beta_url=$steamos_src_url/jupiter-beta/$query_str
jupiter_main_url=$steamos_src_url/jupiter-main/$query_str
jupiter_staging_url=$steamos_src_url/jupiter-staging/$query_str
jupiter_rel_url=$steamos_src_url/jupiter-rel/$query_str
holo_333_url=$steamos_src_url/holo-3.3.3/$query_str
holo_35_url=$steamos_src_url/holo-3.5/$query_str
holo_36_url=$steamos_src_url/holo-3.6/$query_str
holo_stable_url=$steamos_src_url/holo/$query_str
holo_beta_url=$steamos_src_url/holo-beta/$query_str
holo_main_url=$steamos_src_url/holo-main/$query_str
holo_staging_url=$steamos_src_url/holo-staging/$query_str
holo_rel_url=$steamos_src_url/holo-rel/$query_str

for arg; do
  case ${arg,,} in
  # automation
  --auto|--automate|--automatic|--bot)
    export SRCPKG_AUTO=1
    ;;
  # fast forward (pseudo) update
  --fast-forward-update|--ff-update|--mask-update|--masquerade-update|--pseudo-update)
    pseudo_update=1
    ;;
  jupiter-332|--jupiter-332)
    # single string
    #srcpkg_remote=$jupiter_332_url
    srcpkg_remote+=" $jupiter_332_url"
    ;;
  jupiter-333|--jupiter-333)
    # single string
    #srcpkg_remote=$jupiter_333_url
    srcpkg_remote+=" $jupiter_333_url"
    ;;
  jupiter-35|--jupiter-35)
    # single string
    #srcpkg_remote=$jupiter_35_url
    srcpkg_remote+=" $jupiter_35_url"
    ;;
  jupiter-36|--jupiter-36)
    # single string
    #srcpkg_remote=$jupiter_36_url
    srcpkg_remote+=" $jupiter_36_url"
    ;;
  #jupiter-stable|--jupiter-stable|stable|--stable)
  jupiter|--jupiter|jupiter-stable|--jupiter-stable)
    # single string
    #srcpkg_remote=$jupiter_stable_url
    srcpkg_remote+=" $jupiter_stable_url"
    ;;
  #jupiter-beta|--jupiter-beta|beta|--beta)
  jupiter-beta|--jupiter-beta)
    # single string
    #srcpkg_remote=$jupiter_beta_url
    srcpkg_remote+=" $jupiter_beta_url"
    ;;
  #jupiter-main|--jupiter-main|main|--main)
  jupiter-main|--jupiter-main)
    # single string
    #srcpkg_remote=$jupiter_main_url
    srcpkg_remote+=" $jupiter_main_url"
    ;;
  # jupiter-staging released August 25, 2022
  #jupiter-staging|--jupiter-staging|staging|--staging)
  jupiter-staging|--jupiter-staging)
    # single string
    #srcpkg_remote=$jupiter_staging_url
    srcpkg_remote+=" $jupiter_staging_url"
    ;;
  # jupiter-rel released December 20, 2022
  #jupiter-rel|--jupiter-rel|rel|--rel)
  jupiter-rel|--jupiter-rel)
    # single string
    #srcpkg_remote=$jupiter_rel_url
    srcpkg_remote+=" $jupiter_rel_url"
    ;;
  jupiter-aio|--jupiter-aio|jupiter-all|--jupiter-all)
    # jupiter
    # single string
    #srcpkg_remote="$jupiter_main_url $jupiter_beta_url $jupiter_stable_url"
    #srcpkg_remote+=" $jupiter_main_url $jupiter_beta_url $jupiter_stable_url"
    # + staging
    # single string
    #srcpkg_remote="$jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url"
    #srcpkg_remote+=" $jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url"
    # + rel
    # single string
    #srcpkg_remote="$jupiter_rel_url $jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url"
    srcpkg_remote+=" $jupiter_rel_url $jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url"
    ;;
  #beta-main|--beta-main|main-beta|--main-beta)
    # single string
    ##srcpkg_remote="$jupiter_main_url $jupiter_beta_url"
    #srcpkg_remote+=" $jupiter_main_url $jupiter_beta_url"
    #;;
  holo-333|--holo-333)
    # single string
    #srcpkg_remote=$holo_333_url
    srcpkg_remote+=" $holo_333_url"
    ;;
  holo-35|--holo-35)
    # single string
    #srcpkg_remote=$holo_35_url
    srcpkg_remote+=" $holo_35_url"
    ;;
  holo-36|--holo-36)
    # single string
    #srcpkg_remote=$holo_36_url
    srcpkg_remote+=" $holo_36_url"
    ;;
  holo|--holo|holo-stable|--holo-stable)
    # single string
    #srcpkg_remote=$holo_stable_url
    srcpkg_remote+=" $holo_stable_url"
    ;;
  # holo-beta released November 15, 2022
  holo-beta|--holo-beta)
    # single string
    #srcpkg_remote=$holo_beta_url
    srcpkg_remote+=" $holo_beta_url"
    ;;
  # holo-main released August 3, 2022
  holo-main|--holo-main)
    # single string
    #srcpkg_remote=$holo_main_url
    srcpkg_remote+=" $holo_main_url"
    ;;
  # holo-staging released August 25, 2022
  holo-staging|--holo-staging)
    # single string
    #srcpkg_remote=$holo_staging_url
    srcpkg_remote+=" $holo_staging_url"
    ;;
  # holo-rel released December 20, 2022
  holo-rel|--holo-rel)
    # single string
    #srcpkg_remote=$holo_rel_url
    srcpkg_remote+=" $holo_rel_url"
    ;;
  holo-aio|--holo-aio|holo-all|--holo-all)
    # holo
    # single string
    #srcpkg_remote="$holo_main_url $holo_beta_url $holo_stable_url"
    #srcpkg_remote+=" $holo_main_url $holo_beta_url $holo_stable_url"
    # + staging
    # single string
    #srcpkg_remote="$holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    #srcpkg_remote+=" $holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    # + rel
    # single string
    #srcpkg_remote="$holo_rel_url $holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    srcpkg_remote+=" $holo_rel_url $holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    ;;
  aio|--aio|all|--all)
    # jupiter + holo
    # single string
    #srcpkg_remote="$jupiter_main_url $jupiter_beta_url $jupiter_stable_url $holo_main_url $holo_beta_url $holo_stable_url"
    #srcpkg_remote+=" $jupiter_main_url $jupiter_beta_url $jupiter_stable_url $holo_main_url $holo_beta_url $holo_stable_url"
    # + staging
    # single string
    #srcpkg_remote="$jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url $holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    #srcpkg_remote+=" $jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url $holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    # + rel
    # single string
    #srcpkg_remote="$jupiter_rel_url $jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url $holo_rel_url $holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    srcpkg_remote+=" $jupiter_rel_url $jupiter_staging_url $jupiter_main_url $jupiter_beta_url $jupiter_stable_url $holo_rel_url $holo_staging_url $holo_main_url $holo_beta_url $holo_stable_url"
    ;;
  *)
    # full/relative PATH -> URL (file://)
    #if [[ -z $(echo "$arg" | grep '://') && -s $arg || -s ${arg%\?*} ]]; then
    #if ! echo "$arg" | grep -q '://' && [[ -s $arg || -s ${arg%\?*} ]]; then
    if echo "$arg" | grep -vq '://' && [[ -s $arg || -s ${arg%\?*} ]]; then
      # relative PATH
      if [[ -s $PWD/$arg || -s $PWD/${arg%\?*} ]]; then
        # single string
        arg=file://$PWD/$arg
      # full PATH
      elif [[ -s $arg || -s ${arg%\?*} ]]; then
        # single string
        arg=file://$arg
      fi
    fi
    # single string
    #srcpkg_remote=$arg
    srcpkg_remote+=" $arg"
    ;;
  esac
done

# single string whitespace filter
while [[ $srcpkg_remote == *"  "* ]]; do
  # reduce all duplicate whitespaces (2 -> 1)
  srcpkg_remote=${srcpkg_remote//  / }
done
# prefix whitespace trim
#while [[ ${srcpkg_remote:0:1} == " " ]]; do
while [[ ${srcpkg_remote::1} == " " ]]; do
  srcpkg_remote=${srcpkg_remote:1}
done

##if [[ -n $1 ]]; then
#if [[ -n $* ]]; then
  ##srcpkg_remote=$1
  ##srcpkg_remote+=$1
  # separate strings
  ##srcpkg_remote=$@
  ##srcpkg_remote+=$@
  # single string
  ##srcpkg_remote=$*
  #srcpkg_remote+=$*
  # TODO maybe use array
#else
# single string
if [[ -z $srcpkg_remote ]]; then
  # URL queries - C=category (N=(file) name, S=(file) size, M=date); O=order (A=ascending, D=descending) - e.g., 'C=M&O=D' will sort by date in a descending order (last-first)
  # jupiter-rel
  # single string
  #srcpkg_remote=$steamos_src_url/jupiter-rel/$query_str
  #srcpkg_remote=$jupiter_rel_url
  # jupiter-staging appears to be a collection/snapshot of jupiter-main packages
  # jupiter-staging
  # single string
  #srcpkg_remote=$steamos_src_url/jupiter-staging/$query_str
  #srcpkg_remote=$jupiter_staging_url
  # jupiter-main
  # single string
  #srcpkg_remote=$steamos_src_url/jupiter-main/$query_str
  srcpkg_remote=$jupiter_main_url
  # jupiter-beta
  # single string
  #srcpkg_remote=$steamos_src_url/jupiter-beta/$query_str
  #srcpkg_remote=$jupiter_beta_url
  # jupiter-stable (jupiter)
  # single string
  #srcpkg_remote=$steamos_src_url/jupiter/$query_str
  #srcpkg_remote=$jupiter_stable_url
  # jupiter-(main/beta/stable) - all-in-one (AIO)
  # single string
  #srcpkg_remote="$steamos_src_url/jupiter-main/$query_str $steamos_src_url/jupiter-beta/$query_str $steamos_src_url/jupiter/$query_str"
  #srcpkg_remote="$jupiter_main_url $jupiter_beta_url $jupiter_stable_url"
  # jupiter-(main/beta)
  # single string
  #srcpkg_remote="$steamos_src_url/jupiter-main/$query_str $steamos_src_url/jupiter-beta/$query_str"
  #srcpkg_remote="$jupiter_main_url $jupiter_beta_url"
  # holo-rel
  # single string
  #srcpkg_remote=$steamos_src_url/holo-rel/$query_str
  #srcpkg_remote=$holo_rel_url
  # holo-staging appears to be a collection/snapshot of holo-main packages
  # holo-staging
  # single string
  #srcpkg_remote=$steamos_src_url/holo-staging/$query_str
  #srcpkg_remote=$holo_staging_url
  # holo-main
  # single string
  #srcpkg_remote=$steamos_src_url/holo-main/$query_str
  #srcpkg_remote=$holo_main_url
  # holo-beta
  # single string
  #srcpkg_remote=$steamos_src_url/holo-beta/$query_str
  #srcpkg_remote=$holo_beta_url
  # holo-stable (holo)
  # single string
  #srcpkg_remote=$steamos_src_url/holo/$query_str
  #srcpkg_remote=$holo_stable_url
  # holo-(main/beta/stable) - all-in-one (AIO)
  # single string
  #srcpkg_remote="$steamos_src_url/holo-main/$query_str $steamos_src_url/holo-beta/$query_str $steamos_src_url/holo/$query_str"
  #srcpkg_remote="$holo_main_url $holo_beta_url $holo_stable_url"
  # holo-(main/beta)
  # single string
  #srcpkg_remote="$steamos_src_url/holo-main/$query_str $steamos_src_url/holo-beta/$query_str"
  #srcpkg_remote="$holo_main_url $holo_beta_url"
  # TODO maybe use array
fi

# if array instead of string
#[[ ${#srcpkg_remote[@]} == 1 ]] && sr=" " || sr=s
# if string instead of array
if hash wc 2>/dev/null; then
  [[ $(wc -w <<< "$srcpkg_remote") == 1 ]] && sr=" " || sr=s
  echo "    source package remote$sr: $(wc -w <<< "$srcpkg_remote")"
else
  #sr='(s)'
  # single string
  # count whitespace(s) (remove all except whitespace)
  src=${srcpkg_remote//[^ ]}
  src=${#src}
  # math workaround - limited; zero (0) cannot be represented
  # 0 whitespace assumes 1 (0 -> 1) - this could potentially be zero (0); but zero (0) cannot be represented using this method/model; fixed - see: override to plural if zero (0) below
  #(( ${#src} + 1 == 1 )) && sr=" " || sr=s
  #(( src + 1 == 1 )) && sr=" " || sr=s
  # reduce math | - 1 == - 1
  #(( ${#src} == 0 )) && sr=" " || sr=s
  #(( src == 0 )) && sr=" " || sr=s
  # override to zero (0) and plural if zero (0)
  #if [[ -z $srcpkg_remote ]]; then
    #src=-1
    #sr=s
  #fi
  # mathless workaround - better/simpler method/model
  #[[ -n $srcpkg_remote ]] && (( ${#src} + 1 ))
  #[[ -n $srcpkg_remote ]] && (( src + 1 ))
  [[ -n $srcpkg_remote ]] && (( src++ ))
  #(( ${#src} == 1 )) && sr=" " || sr=s
  (( src == 1 )) && sr=" " || sr=s
  # TODO maybe use array
  #echo "    source package remote$sr: $(( ${#src} + 1 ))"
  #echo "    source package remote$sr: $(( src + 1 ))"
  #echo "    source package remote$sr: $(( src++ ))"
  echo "    source package remote$sr: $src"
fi
echo
#echo "source package remote URL$sr: $srcpkg_remote"
echo -e "source package remote URL$sr:\n${srcpkg_remote// /\\n}"
echo

echo "checking for source package update(s) ..."
#echo "checking for new source package(s) ..."
echo
for srcpkg_remote in $srcpkg_remote; do
  #if [[ -z $(echo "$srcpkg_remote" | grep '://') ]]; then
  #if ! echo "$srcpkg_remote" | grep -q '://'; then
  if echo "$srcpkg_remote" | grep -vq '://'; then
    echo -e "\e[93mwarning: URL ($srcpkg_remote) invalid! skipping ...\e[0m"
    echo
    continue
  fi
  # override/use srcpkg_remote_file with numerical naming (srcpkg_remote_file_no_ext + _NUMBER + [.] + srcpkg_remote_file_ext)
  if [[ -n $srcpkg_remote_file_no_ext ]]; then
    (( srcpkg_remote_file_count++ ))
    if [[ -n $srcpkg_remote_file_ext ]]; then
      srcpkg_remote_file=${srcpkg_remote_file_no_ext}_$srcpkg_remote_file_count.$srcpkg_remote_file_ext
    else
      srcpkg_remote_file=${srcpkg_remote_file_no_ext}_$srcpkg_remote_file_count
    fi
  fi
  # sanity check
  if [[ -z $srcpkg_remote_file ]]; then
    srcpkg_remote_file="$srcpkg_dl_dir/srcpkg_remote.html"
  fi
  #echo "downloading: $srcpkg_remote_file from: $srcpkg_remote ..."
  #echo "downloading: $srcpkg_remote to: $srcpkg_remote_file ..."
  #echo "downloading: $srcpkg_remote_file ..."
  while :; do
    # potentially continue download - Use "-C -" to tell curl to automatically find out where/how to resume the transfer. It then uses the given output/input files to figure that out.
    #[[ -e $srcpkg_remote_file ]] && curl_continue="-C -" || curl_continue=
    # inherit remote name
    # shellcheck disable=2086
    #if curl -OR $srcpkg_remote; then
    #if curl -ORs $srcpkg_remote; then
    #if curl $curl_continue -OR $srcpkg_remote; then
    #if curl $curl_continue -ORs $srcpkg_remote; then
    # specify name
    #if curl -Ro "$srcpkg_remote_file" $srcpkg_remote; then
    if curl -Rso "$srcpkg_remote_file" $srcpkg_remote; then
    #if curl $curl_continue -Ro "$srcpkg_remote_file" $srcpkg_remote; then
    #if curl $curl_continue -Rso "$srcpkg_remote_file" $srcpkg_remote; then
      break
    else
      dl_error "$srcpkg_remote_file" "$srcpkg_remote"
      #continue
    fi
  done
  #xmllint --html --xpath '/html/body/pre/span/a/@href' $srcpkg_remote_file
  # .src.tar.gz -> .tar.gz
  # remove '.sig' and include '.tar.gz' - filter
  # generic (srcpkg_html) - srcpkg_name and srcpkg_url
  #for srcpkg_html in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep '.tar.gz'); do
  #for srcpkg_name in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/@title' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep '.tar.gz'); do
  # no srcpkg_name filter required
  #for srcpkg_name in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/text()' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep '.tar.gz'); do
  #for srcpkg_url in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/@href' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep '.tar.gz'); do
  # .src.tar[.gz|.xz] -> .tar[.gz|.xz]
  # remove '.sig' and include '.tar[.gz|.xz]' - filter
  # generic (srcpkg_html) - srcpkg_name and srcpkg_url
  #for srcpkg_html in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -e '.tar.gz' -e '.tar.xz'); do
  #for srcpkg_html in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -E '.tar.gz|.tar.xz'); do
  #for srcpkg_name in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/@title' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -e '.tar.gz' -e '.tar.xz'); do
  #for srcpkg_name in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/@title' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -E '.tar.gz|.tar.xz'); do
  # no srcpkg_name filter required
  #for srcpkg_name in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/text()' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -e '.tar.gz' -e '.tar.xz'); do
  #for srcpkg_name in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/text()' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -E '.tar.gz|.tar.xz'); do
  #for srcpkg_url in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/@href' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -e '.tar.gz' -e '.tar.xz'); do
  for srcpkg_url in $(xmllint --html --xpath '/html/body/table/tbody/tr/td/a/@href' "$srcpkg_remote_file" 2>/dev/null | grep -v '.sig' | grep -E '.tar.gz|.tar.xz'); do
    # remove prefix whitespace - recommended before remove prefix leading/preliminary 'href=' below
    #srcpkg_url=${srcpkg_url# }
    # remove prefix whitespace(s) - recommended before remove prefix leading/preliminary 'href=' below
    srcpkg_url=${srcpkg_url##+( )}
    # remove any/all/both double quotes (")
    srcpkg_url=${srcpkg_url//\"}
    # remove any/all 'href='
    #srcpkg_url=${srcpkg_url//href=}
    # remove first found 'href='
    #srcpkg_url=${srcpkg_url/href=}
    # remove prefix leading/preliminary 'href='
    srcpkg_url=${srcpkg_url#href=}
    # decode (potential) URL encoding
    srcpkg_url=$(echo -e "${srcpkg_url//%/\\x}")
    # if (potentially) missing URL (srcpkg_remote) - direct/preliminary/prior - done better/universally below (filter srcpkg_url)
    #srcpkg_name=$srcpkg_url
    # add (potentially) missing URL (srcpkg_remote)
    # double quoting srcpkg_url is unnecessary (thanks to for loop above), but unharmful
    #if [[ -z $(echo "$srcpkg_url" | grep '://') ]]; then
    #if ! echo "$srcpkg_url" | grep -q '://'; then
    if echo "$srcpkg_url" | grep -vq '://'; then
      # remove (potential) URL query
      srcpkg_remote_no_query=${srcpkg_remote/\?*}
      if [[ ${srcpkg_remote_no_query: -1} == / ]]; then
        srcpkg_url=$srcpkg_remote_no_query$srcpkg_url
      else
        srcpkg_url=$srcpkg_remote_no_query/$srcpkg_url
      fi
    # done better below (filter srcpkg_url)
    #else
      #srcpkg_name=$srcpkg_url
    fi
    # TODO maybe get srcpkg_name from HTML (xmllint) - @href -> @title or text() (prefiltered) - must use srcpkg_html
    # filter srcpkg_url -> srcpkg_name
    #srcpkg_name=${srcpkg_url/*\/}
    srcpkg_name=${srcpkg_url##*/}
    # TODO maybe also compare timestamps and/or version numbers (extrapolate from HTML)
    # reduce name
    #srcpkg_name_reduce=${srcpkg_name//[!a-zA-Z]}
    #srcpkg_name_reduce=${srcpkg_name//[!-a-zA-Z]}
    #srcpkg_name_reduce=${srcpkg_name//[!-_a-zA-Z]}
    # trim suffix and reduce name
    #srcpkg_name_reduce=${srcpkg_name%%[0-9]*}
    #srcpkg_name_reduce=${srcpkg_name%.src.tar.gz}
    #srcpkg_name_reduce=${srcpkg_name%.tar.gz}
    srcpkg_name_reduce=${srcpkg_name%%.*}
    srcpkg_name_reduce=${srcpkg_name%-*}
    # filter
    #srcpkg_name_reduce=${srcpkg_name_reduce//[!a-zA-Z]}
    #srcpkg_name_reduce=${srcpkg_name_reduce//[!-a-zA-Z]}
    #srcpkg_name_reduce=${srcpkg_name_reduce//[!-_a-zA-Z]}
    # (pre)filter (potential) date suffix (-XXXXXXXX)
    #if [[ ${srcpkg_name_reduce:(-8)} =~ ^[0-9]+$ && ${srcpkg_name_reduce:(-9):1} == - ]]; then
    if [[ ${srcpkg_name_reduce: -8} =~ ^[0-9]+$ && ${srcpkg_name_reduce: -9:1} == - ]]; then
      #srcpkg_name_reduce=${srcpkg_name%-*}
      srcpkg_name_reduce=${srcpkg_name::-9}
    fi
    # grep word regexp support
    # '-' -> '_'
    #srcpkg_name_reduce=${srcpkg_name_reduce//-/_}
    #srcpkg_name_reduce=${srcpkg_name_reduce//[!a-zA-Z0-9]/_}
    srcpkg_name_reduce=${srcpkg_name_reduce//[!_a-zA-Z0-9]/_}
    # (post)filter (potential) date suffix (XXXXXXXX)
    #if [[ ${srcpkg_name_reduce:(-8)} =~ ^[0-9]+$ ]]; then
    if [[ ${srcpkg_name_reduce: -8} =~ ^[0-9]+$ ]]; then
      #srcpkg_name_reduce=${srcpkg_name:0:8}
      srcpkg_name_reduce=${srcpkg_name::8}
      # remove trailing '-' - dead code - '-' -> '_'
      #srcpkg_name_reduce=${srcpkg_name_reduce%-}
      # remove trailing '_'
      srcpkg_name_reduce=${srcpkg_name_reduce%_}
    fi
    # remove/skip duplicate/redundant package(s)
    #if [[ -n $(echo "$srcpkg_name_reduce_str" | grep -w "$srcpkg_name_reduce" &>/dev/null) ]]; then
    if echo "$srcpkg_name_reduce_str" | grep -iqw "$srcpkg_name_reduce" &>/dev/null; then
      # TODO maybe prompt to continue/download
      echo -e "    \e[1m$srcpkg_name: redundant download skipped!\n$srcpkg_name URL: $srcpkg_url\e[0m\n"
      srcpkg_name_redundant+=("$srcpkg_name")
      # break or continue - required unless remove/skip duplicate/redundant package(s) is moved within (else) or after break or download (curl) below
      if [[ -e $srcpkg_name ]]; then
        break
      else
        continue
      fi
      #continue
    else
      # single string
      srcpkg_name_reduce_str+=" $srcpkg_name_reduce"
      #srcpkg_name_reduce_str+="$srcpkg_name_reduce "
      # array
      #srcpkg_name_reduce_arr+=("$srcpkg_name_reduce")
      # ironically redundant - already counted below (srcpkg_update_name)
      #srcpkg_name_unique+=("$srcpkg_name")
    fi
    # break or download (curl)
    if [[ -e $srcpkg_name ]]; then
    #if [[ -f $srcpkg_name ]]; then
    #if [[ -s $srcpkg_name ]]; then
      # TODO maybe prompt to continue
      #echo "$srcpkg_name found! stop"
      #echo
      break
    else
      # pseudo update
      if [[ -n $pseudo_update ]]; then
        touch "$srcpkg_name"
        # disarm (redundant)
        pseudo_update=
        echo "pseudo update: $srcpkg_name"
        echo
        break
      fi
      # TODO maybe prompt to download
      #echo "downloading: $srcpkg_name from: $srcpkg_url ..."
      #echo "downloading: $srcpkg_url to: $srcpkg_name ..."
      echo "downloading: $srcpkg_name ..."
      while :; do
        # potentially continue download - Use "-C -" to tell curl to automatically find out where/how to resume the transfer. It then uses the given output/input files to figure that out.
        [[ -e $srcpkg_name ]] && curl_continue="-C -" || curl_continue=
        # inherit remote name
        # shellcheck disable=2086
        #if curl -OR $srcpkg_url; then
        #if curl -ORs $srcpkg_url; then
        #if curl $curl_continue -OR $srcpkg_url; then
        #if curl $curl_continue -ORs $srcpkg_url; then
        # specify name
        #if curl -Ro "$srcpkg_name" $srcpkg_url; then
        #if curl -Rso "$srcpkg_name" $srcpkg_url; then
        if curl $curl_continue -Ro "$srcpkg_name" $srcpkg_url; then
        #if curl $curl_continue -Rso "$srcpkg_name" $srcpkg_url; then
          # FIXME WIP
          # download and verify signature (.sig)
          # TODO add if -n config_option && hash gpg
          #if hash gpg 2>/dev/null; then
            ##if curl -Ro "$srcpkg_name.sig" $srcpkg_url.sig; then
            ##if curl -Rso "$srcpkg_name.sig" $srcpkg_url.sig; then
            #if curl $curl_continue -Ro "$srcpkg_name.sig" $srcpkg_url.sig; then
            ##if curl $curl_continue -Rso "$srcpkg_name.sig" $srcpkg_url.sig; then
              ##if ! gpg "$srcpkg_name.sig"; then
              ##if ! gpg --verify "$srcpkg_name.sig"; then
              #if ! gpg --verify "$srcpkg_name.sig" "$srcpkg_name"; then
                # TODO add prompt for deletion - if yes then
                #rm -fv "$srcpkg_name" "$srcpkg_name.sig"
                #continue
              #fi
            #fi
          #fi
          break
        else
          dl_error "$srcpkg_name" "$srcpkg_url"
          #continue
        fi
      done
      # single string
      #srcpkg_update_name+="$srcpkg_name "
      # array - if package contains spaces
      srcpkg_update_name+=("$srcpkg_name")
      # full PATH - requires an array if PATH contains spaces
      srcpkg_update_file+=("$srcpkg_dl_dir/$srcpkg_name")
      # single string
      #srcpkg_update_url+="$srcpkg_url "
      # array - to (potentially) reverse
      srcpkg_update_url+=("$srcpkg_url")
      # TODO maybe get timestamp from HTML - HTML does not include seconds
      # TODO maybe get timestamp from ls - cumbersome
      # timestamp - requires 'curl -R' above
      if hash date 2>/dev/null; then
        #if date -r "$srcpkg_name"; then
        #if [[ -n $(date -r "$srcpkg_name" 2>/dev/null) ]]; then
          # TODO maybe use srcpkg_update_file instead of srcpkg_name
          # single string - use both string (_str) and array
          #srcpkg_update_timestamp_str=$(date -r "$srcpkg_name")
        srcpkg_update_timestamp_str=$(date -r "$srcpkg_name" 2>/dev/null)
        if [[ -n $srcpkg_update_timestamp_str ]]; then
          # array - use both string (_str) and array
          #srcpkg_update_timestamp+=("$(date -r "$srcpkg_name")")
          #srcpkg_update_timestamp+=("$srcpkg_update_timestamp_str")
          #srcpkg_update_timestamp+=("$srcpkg_name) $(date -r "$srcpkg_name")")
          #srcpkg_update_timestamp+=("$srcpkg_name) $srcpkg_update_timestamp_str")
          #srcpkg_update_timestamp+=("$srcpkg_name timestamp: $(date -r "$srcpkg_name")")
          #srcpkg_update_timestamp+=("$srcpkg_name timestamp: $srcpkg_update_timestamp_str")
          #srcpkg_update_timestamp+=("$srcpkg_name date/time: $(date -r "$srcpkg_name")")
          #srcpkg_update_timestamp+=("$srcpkg_name date/time: $srcpkg_update_timestamp_str")
          #srcpkg_update_timestamp+=("$srcpkg_name: $(date -r "$srcpkg_name")")
          srcpkg_update_timestamp+=("$srcpkg_name: $srcpkg_update_timestamp_str")
          # individual timestamp output
          # single string
          #echo "timestamp: $srcpkg_update_timestamp_str"
          echo "$srcpkg_name timestamp: $srcpkg_update_timestamp_str"
          #echo "$srcpkg_name date/time: $srcpkg_update_timestamp_str"
        fi
      else
        srcpkg_update_timestamp_str=
        # redundant - done above
        srcpkg_update_timestamp=()
      fi
      echo
    fi
  done
done

# reverse arrays (correct inverted/reversed download) - must be after download
rev_array=()
for (( i=${#srcpkg_update_name[@]}-1; i>=0; i-- )); do
  rev_array+=("${srcpkg_update_name[i]}")
done
[[ -n ${rev_array[*]} && $rev_array != "$srcpkg_update_name" ]] && srcpkg_update_name=("${rev_array[@]}")
rev_array=()
for (( i=${#srcpkg_update_file[@]}-1; i>=0; i-- )); do
  rev_array+=("${srcpkg_update_file[i]}")
done
[[ -n ${rev_array[*]} && $rev_array != "$srcpkg_update_file" ]] && srcpkg_update_file=("${rev_array[@]}")
rev_array=()
for (( i=${#srcpkg_update_url[@]}-1; i>=0; i-- )); do
  rev_array+=("${srcpkg_update_url[i]}")
done
[[ -n ${rev_array[*]} && $rev_array != "$srcpkg_update_url" ]] && srcpkg_update_url=("${rev_array[@]}")
rev_array=()
for (( i=${#srcpkg_update_timestamp[@]}-1; i>=0; i-- )); do
  rev_array+=("${srcpkg_update_timestamp[i]}")
done
[[ -n ${rev_array[*]} && $rev_array != "$srcpkg_update_timestamp" ]] && srcpkg_update_timestamp=("${rev_array[@]}")
# redundant array cleanup
rev_array=()

# single string - trim last byte (space) - redundant
#if [[ -n $srcpkg_update_name ]]; then
  #srcpkg_update_name=${srcpkg_update_name::-1}
#fi
#if [[ -n $srcpkg_update_url ]]; then
  #srcpkg_update_url=${srcpkg_update_url::-1}
#fi

cd "$cdir" || exit 3

# TODO maybe copy/move to end of first for loop above (must clear all variables afterwards (srcpkg_update_name/file/url))
#if [[ -n $srcpkg_update_name || -n $srcpkg_name_redundant || -n $srcpkg_update_file || -n $srcpkg_update_url ]]; then
#if [[ -n ${srcpkg_update_name[@]} || -n ${srcpkg_name_redundant[@]} || -n ${srcpkg_update_file[@]} || -n ${srcpkg_update_url[@]} ]]; then
if [[ -n ${srcpkg_update_name[*]} || -n ${srcpkg_name_redundant[*]} || -n ${srcpkg_update_file[*]} || -n ${srcpkg_update_url[*]} ]]; then
  [[ ${#srcpkg_update_name[@]} == 1 ]] && sun=" " || sun=s
  [[ ${#srcpkg_name_redundant[@]} == 1 ]] && snr=" " || snr=s
  [[ ${#srcpkg_update_file[@]} == 1 ]] && suf=" " || suf=s
  # if array instead of string
  [[ ${#srcpkg_update_url[@]} == 1 ]] && suu=" " || suu=s
  # if string instead of array
  #if hash wc 2>/dev/null; then
    #[[ $(wc -w <<< "$srcpkg_update_url") == 1 ]] && suu=" " || suu=s
  #else
    # copied from sr/src above (sr -> suu & src -> suuc)
    ##suu='(s)'
    # single string
    # count whitespace(s) (remove all except whitespace)
    #suuc=${srcpkg_update_url//[^ ]}
    #suuc=${#suuc}
    # math workaround - limited; zero (0) cannot be represented
    # 0 whitespace assumes 1 (0 -> 1) - this could potentially be zero (0); but zero (0) cannot be represented using this method/model; fixed - see: override to plural if zero (0) below
    ##(( ${#suuc} + 1 == 1 )) && suu=" " || suu=s
    ##(( suuc + 1 == 1 )) && suu=" " || suu=s
    # reduce math | - 1 == - 1
    ##(( ${#suuc} == 0 )) && suu=" " || suu=s
    ##(( suuc == 0 )) && suu=" " || suu=s
    # override to zero (0) and plural if zero (0)
    ##if [[ -z $srcpkg_update_url ]]; then
      ##suuc=-1
      ##suu=s
    ##fi
    # mathless workaround - better/simpler method/model
    ##[[ -n $srcpkg_update_url ]] && (( ${#suuc} + 1 ))
    ##[[ -n $srcpkg_update_url ]] && (( suuc + 1 ))
    #[[ -n $srcpkg_update_url ]] && (( suuc++ ))
    ##(( ${#suuc} == 1 )) && suu=" " || suu=s
    #(( suuc == 1 )) && suu=" " || suu=s
  #fi
  [[ ${#srcpkg_update_timestamp[@]} == 1 ]] && sut=" " || sut=s
  # OBSOLETE - already done
  ##if [[ $sun == s || $snr == s || $suf == s || $suu == s || $sut == s ]]; then
  #if [[ ${#srcpkg_update_name[@]} != 1 || ${#srcpkg_name_redundant[@]} != 1 || ${#srcpkg_update_file[@]} != 1 || ${#srcpkg_update_url[@]} != 1 || ${#srcpkg_update_timestamp[@]} != 1 ]]; then
    # "" -> " "
    #[[ -z $sun ]] && sun=" "
    #[[ -z $snr ]] && snr=" "
    #[[ -z $suf ]] && suf=" "
    #[[ -z $suu ]] && suu=" "
    #[[ -z $sut ]] && sut=" "
  #fi
  if [[ -n ${srcpkg_name_redundant[*]} ]]; then
    #(( ${#srcpkg_update_name[@]} + ${#srcpkg_name_redundant[@]} == 1 )) && tspu=" " || tspu=s
    (( ${#srcpkg_update_file[@]} + ${#srcpkg_name_redundant[@]} == 1 )) && tspu=" " || tspu=s
    #echo "    total source package update$tspu: $(( ${#srcpkg_update_name[@]} + ${#srcpkg_name_redundant[@]} ))"
    echo "    total source package update$tspu: $(( ${#srcpkg_update_file[@]} + ${#srcpkg_name_redundant[@]} ))"
    echo "redundant source package update$snr: ${#srcpkg_name_redundant[@]}"
    #echo " download source package update$sun: ${#srcpkg_update_name[@]}"
    echo " download source package update$suf: ${#srcpkg_update_file[@]}"
  else
    #echo "          source package update$sun: ${#srcpkg_update_name[@]}"
    echo "          source package update$suf: ${#srcpkg_update_file[@]}"
  fi
  echo
  # single string
  #echo "     source package update name$sun: $srcpkg_update_name"
  # array - if package contains spaces
  #echo "     source package update name$sun:" "${srcpkg_update_name[@]}"
  #echo "     source package update name$sun: ${srcpkg_update_name[*]}"
  # requires newline below
  echo "     source package update name$sun:"
  #echo
  # newline
  # coreutils (printf)
  #printf "%s\n" "${srcpkg_update_name[@]}"
  # built-in
  for nl in "${srcpkg_update_name[@]}"; do
    #echo -e "$nl\n"
    echo "$nl"
  done
  echo
  if [[ -n ${srcpkg_name_redundant[*]} ]]; then
    #echo "  redundant source package name$snr: ${srcpkg_name_redundant[*]}"
    # requires newline below
    echo "  redundant source package name$snr:"
    #echo
    # newline
    # coreutils (printf)
    #printf "%s\n" "${srcpkg_name_redundant[@]}"
    # built-in
    for nl in "${srcpkg_name_redundant[@]}"; do
      #echo -e "$nl\n"
      echo "$nl"
    done
    echo
  fi
  # array (full PATH)
  #echo "     source package update file$suf:" "${srcpkg_update_file[@]}"
  #echo "     source package update file$suf: ${srcpkg_update_file[*]}"
  # requires newline below
  echo "     source package update file$suf:"
  #echo
  # newline
  # coreutils (printf)
  #printf "%s\n" "${srcpkg_update_file[@]}"
  # built-in
  for nl in "${srcpkg_update_file[@]}"; do
    #echo -e "$nl\n"
    echo "$nl"
  done
  echo
  # single string
  #echo "      source package update URL$suu: $srcpkg_update_url"
  # array - to (potentially) reverse
  #echo "      source package update URL$suu: ${srcpkg_update_url[@]}"
  #echo "      source package update URL$suu: ${srcpkg_update_url[*]}"
  # requires newline below
  echo "      source package update URL$suu:"
  #echo
  # newline
  # coreutils (printf)
  #printf "%s\n" "${srcpkg_update_url[@]}"
  # built-in
  for nl in "${srcpkg_update_url[@]}"; do
    #echo -e "$nl\n"
    echo "$nl"
  done
  echo
  #if [[ -n ${srcpkg_update_timestamp[@]} ]]; then
  if [[ -n ${srcpkg_update_timestamp[*]} ]]; then
    # array - use both string (_str) and array
    #echo "source package update date/time: ${srcpkg_update_timestamp[@]}"
    #echo "source package update date/time: ${srcpkg_update_timestamp[*]}"
    #echo "source package update timestamp$sut: ${srcpkg_update_timestamp[@]}"
    #echo "source package update timestamp$sut: ${srcpkg_update_timestamp[*]}"
    # requires newline below
    echo "source package update timestamp$sut:"
    #echo
    # newline
    # coreutils (printf)
    #printf "%s\n" "${srcpkg_update_timestamp[@]}"
    # built-in
    for nl in "${srcpkg_update_timestamp[@]}"; do
      #echo -e "$nl\n"
      echo "$nl"
    done
    echo
  fi
  while :; do
    # automation
    if [[ -n $SRCPKG_AUTO ]]; then
      REPLY=f
    # skip initial (plural) prompt if 1 (singular)
    #elif [[ ${#srcpkg_update_name[@]} == 1 ]]; then
    elif [[ ${#srcpkg_update_file[@]} == 1 ]]; then
      REPLY=y
    else
      #read -n 1 -p "convert/deobfuscate source package update(s) Git repository to working directory?: (Y/n/a/f): "
      read -n 1 -p "convert/deobfuscate source package update(s) to Git working directory?: (Y/n/a/f): "
      echo
    fi
    case ${REPLY,,} in
    y|"")
      for conv_srcpkg in "${srcpkg_update_file[@]}"; do
        while :; do
          #read -n 1 -p "convert/deobfuscate $conv_srcpkg Git repository to working directory?: (Y/n/f): "
          read -n 1 -p "convert/deobfuscate $conv_srcpkg to Git working directory?: (Y/n/f): "
          echo
          case ${REPLY,,} in
          y|"")
            conv_srcpkg_array+=("$conv_srcpkg")
            break
            ;;
          f)
            #conv_srcpkg_array+=("-f" "$conv_srcpkg")
            conv_srcpkg_array+=(-f "$conv_srcpkg")
            break
            ;;
          n)
            break
            ;;
          esac
        done
      done
      break
      ;;
    n)
      break
      ;;
    a)
      conv_srcpkg_array=("${srcpkg_update_file[@]}")
      break
      ;;
    f)
      for conv_srcpkg in "${srcpkg_update_file[@]}"; do
        #conv_srcpkg_array+=("-f" "$conv_srcpkg")
        conv_srcpkg_array+=(-f "$conv_srcpkg")
      done
      break
      ;;
    esac
  done
  #if [[ -s srcpkg2git.sh ]]; then
  if [[ -s $cdir/srcpkg2git.sh ]]; then
    #she=./srcpkg2git.sh
    she=$cdir/srcpkg2git.sh
  elif [[ -s ${0%/*}/srcpkg2git.sh ]]; then
    she=${0%/*}/srcpkg2git.sh
  elif hash srcpkg2git 2>/dev/null; then
    #she=srcpkg2git
    she=$(command -v srcpkg2git 2>/dev/null)
  elif [[ -s $HOME/srcpkg2git/srcpkg2git.sh ]]; then
    she=$HOME/srcpkg2git/srcpkg2git.sh
  fi
  #if [[ -n $conv_srcpkg_array && -s $cdir/srcpkg2git.sh ]]; then
  #if [[ -n ${conv_srcpkg_array[@]} && -s $cdir/srcpkg2git.sh ]]; then
  #if [[ -n ${conv_srcpkg_array[*]} && -s $cdir/srcpkg2git.sh ]]; then
  if [[ -n ${conv_srcpkg_array[*]} && -n $she ]]; then
    [[ ${#conv_srcpkg_array[@]} == 1 ]] && csa=" " || csa=s
    # potential false plural if -f (force)
    #[[ ${#conv_srcpkg_array[@]} == 2 && ${conv_srcpkg_array[0]} == -f ]] && csa=" "
    [[ ${#conv_srcpkg_array[@]} == 2 && $conv_srcpkg_array == -f ]] && csa=" "
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]}) Git repository to working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]}) to Git working directory ..."
    # suffix replace -f
    #echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/%-f/\\e[1m(force)\\e[0m}) Git repository to working directory ..."
    #echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/%-f/\\e[1m(force)\\e[0m}) to Git working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/%-f/}) Git repository to working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/%-f/}) to Git working directory ..."
    # prefix replace -f
    #echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/#-f/\\e[1m(force)\\e[0m}) Git repository to working directory ..."
    #echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/#-f/\\e[1m(force)\\e[0m}) to Git working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/#-f/}) Git repository to working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[@]/#-f/}) to Git working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]}) Git repository to working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]}) to Git working directory ..."
    # suffix replace -f
    #echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/%-f/\\e[1m(force)\\e[0m}) Git repository to working directory ..."
    #echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/%-f/\\e[1m(force)\\e[0m}) to Git working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/%-f/}) Git repository to working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/%-f/}) to Git working directory ..."
    # prefix replace -f
    #echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/#-f/\\e[1m(force)\\e[0m}) Git repository to working directory ..."
    echo -e "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/#-f/\\e[1m(force)\\e[0m}) to Git working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/#-f/}) Git repository to working directory ..."
    #echo "converting/deobfuscating source package$csa (${conv_srcpkg_array[*]/#-f/}) to Git working directory ..."
    echo
    #"$cdir/srcpkg2git.sh" "${conv_srcpkg_array[@]}"
    "$she" "${conv_srcpkg_array[@]}"
  fi
else
  echo "no source package update(s)"
  #echo "no new source package(s)"
  echo
fi
#echo
