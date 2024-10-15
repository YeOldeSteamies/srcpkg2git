#!/bin/bash
# This Source Code Form is subject to the terms of the
# Mozilla Public License, v. 2.0. If a copy of the MPL
# was not distributed with this file, You can obtain one
# at https://mozilla.org/MPL/2.0/.

cdir=$PWD
#tarc="tar.[gz|xz]"
tarc="tar[.gz|.xz]"
#srcpkg_dir="$PWD/SRCPKG2GIT"
#srcpkg_tmp="$PWD/SRCPKG2GIT_tmp"
srcpkg_dir="${cdir:-$PWD}/SRCPKG2GIT"
srcpkg_tmp="${cdir:-$PWD}/SRCPKG2GIT_tmp"
#srcpkg_url=https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources/
# moved to config (git-remote.conf)
##git_remote_url=https://github.com/YeOldeSteamies
#[[ -z $git_remote_url ]] && git_remote_url=https://github.com/YeOldeSteamies
#[[ -z $git_remote_username ]] && git_remote_username=
# use personal access token instead of password if two-factor authentication (2FA) enabled
#[[ -z $git_remote_password ]] && git_remote_password=
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

error=
valid_arg=

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
echo "  ------- SRCPKG2GIT v0.05 -------"
echo "$li  Copyright (C) 2022 $ds"
echo "  --------------------------------"
#echo
#echo -e "  \e[2m$srcpkg_url\e[0m"
echo

help() {
  #echo "usage: $0 $tarc [...]"
  echo "usage: $0 src.$tarc [...]"
  #echo "usage: $0 (src.)$tarc [...]"
  #echo " e.g.: $0 package1.$tarc package2.$tarc"
  echo " e.g.: $0 package1.src.$tarc package2.src.$tarc"
  echo
}

# help (usage/example)
for help; do
  case ${help,,} in
  -h|--help)
    help
    exit 0
    ;;
  -v|--version)
    exit 0
    ;;
  esac
done

# dependency check
for dep in git tar; do
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

cleanup() {
# shellcheck disable=2164
#cd "$srcpkg_dir" || cd "$cdir"
cd "$cdir" || cd "$srcpkg_dir"
#if [[ $PWD == "$srcpkg_tmp" ]]; then
#if [[ $PWD != "$cdir" && $PWD != "$srcpkg_dir" ]]
  ##cd "$srcpkg_dir" || cd "$cdir"
  #cd "$cdir" || cd "$srcpkg_dir"
#fi
if [[ -d $srcpkg_tmp ]]; then
  rm -fr "$srcpkg_tmp"
fi
}

# redundant/unnecessary - see: help and source package argument check 2 and 3 of 3 below
# initial source package argument check (1 of 3)
##if [[ -z $1 ]]; then
#if [[ -z $* ]]; then
  #echo -e "\e[31merror: $tarc source package(s) not provided!\e[0m"
  #echo
  #help
  #exit 2
#fi

# TODO maybe use for loop and remove shift (continue only) - maybe move help (usage/example) from above
# source package argument(s) checks (loop)
#while [[ -n $1 ]]; do
while [[ -n $* ]]; do
  # required without realpath setup
  #cd "$cdir" || exit 3
  #srcpkg=$1
  # realpath setup ($1 -> $srcpkg)
  srcpkg=
  if hash realpath 2>/dev/null; then
    srcpkg=$(realpath -e "$1" 2>/dev/null)
    # extra quiet - redundant
    #srcpkg=$(realpath -e -q "$1" 2>/dev/null)
  fi
  # fallback (built-in) realpath setup ($1 -> $srcpkg)
  if [[ -z $srcpkg ]]; then
    if [[ -e $cdir/$1 ]]; then
      srcpkg=$cdir/$1
    else
      srcpkg=$1
    fi
  fi
  # intermezzo source package argument check (2 of 3)
  if [[ -z $srcpkg ]]; then
    # shift -> continue
    shift
    continue
  fi
  case ${srcpkg,,} in
  -f|--force)
    git_force=1
    #echo "git force push enabled/toggled"
    #echo
    # shift -> continue
    shift
    continue
    ;;
  esac
  #echo
  if [[ ! -e $srcpkg ]]; then
    echo -e "\e[31merror: $tarc source package ($srcpkg) not found!\e[0m"
    #exit 4
    # shift -> continue
    shift
    continue
  fi
  valid_arg=1
  # tar[.gz|.xz] source package check/verify
  echo "checking/verifying $tarc source package ($srcpkg) ..."
  echo
  #if ! tar -tzf "$srcpkg" &>/dev/null; then
  if ! tar -tf "$srcpkg" &>/dev/null; then
    echo -e "\e[31merror: corrupt/invalid $tarc source package ($srcpkg) provided!\e[0m"
    #exit 5
    # shift -> continue
    shift
    continue
  fi
  #valid_arg=1

  # preliminary cleanup
  cleanup

  # directory setup
  for md in $srcpkg_dir $srcpkg_tmp; do
    if ! mkdir -p "$md"; then
      echo -e "\e[31merror: directory ($md) could not be made!\e[0m"
      # no point in shifting and continuing loop (exit)
      exit 6
    fi
    # redundant sanity check
    if [[ ! -d $md ]]; then
      echo -e "\e[31merror: directory ($md) not found!\e[0m"
      # no point in shifting and continuing loop (exit)
      exit 6
    fi
  done

  # unpack tar[.gz|.xz] source package
  # cd "$srcpkg_tmp" instead of tar -C "$srcpkg_tmp" (fallback - disabled)
  cd "$srcpkg_tmp" || { shift; continue; }
  echo "unpacking $tarc source package ($srcpkg) ..."
  echo
  #tar --overwrite -xzf "$srcpkg" || { shift; continue; }
  #tar --overwrite -xf "$srcpkg" || { shift; continue; }
  #tar -xzf "$srcpkg" || { shift; continue; }
  tar -xf "$srcpkg" || { shift; continue; }
  # remove first/leading (1) directory - ONLY compatible with GNU tar
  #tar --overwrite -xzf "$srcpkg" --strip-components 1 || { shift; continue; }
  #tar --overwrite -xf "$srcpkg" --strip-components 1 || { shift; continue; }
  #tar -xzf "$srcpkg" --strip-components 1 || { shift; continue; }
  #tar -xf "$srcpkg" --strip-components 1 || { shift; continue; }
  # TODO maybe make src_dir optional (fallback to git_dir)
  # find first directory
  for src_dir in */; do
    # remove ending/trailing forward slash (/) - patch for */ above
    src_dir=${src_dir::-1}
    break
    # use true instead of break to find last directory (inversion)
    #true
  done
  #if [[ -z $src_dir ]]; then
  if [[ ! -d $src_dir ]]; then
    echo -e "\e[31merror: incompatible $tarc source package ($srcpkg) provided!\e[0m"
    #echo -e "\e[31merror: source directory (\$src_dir) not found!\e[0m"
    echo -e "\e[31merror: source directory not found!\e[0m"
    #exit 7
    # shift -> continue
    shift
    continue
  fi
  #cd */ || { shift; continue; }
  cd "$src_dir" || { shift; continue; }
  # local PKGBUILD file detection
  #local_pkg_file=
  local_pkg_file=()
  if [[ -e PKGBUILD ]]; then
    if hash find 2>/dev/null; then
      # "-not -name '.*'" not required with 'find -- * -maxdepth 0' - required with 'find . -maxdepth 1' (also adds './' to each file; which must be filtered/removed)
      #find -- * -maxdepth 0 -not -type d | grep -v PKGBUILD
      #find -- * -maxdepth 0 -type f | grep -v PKGBUILD
      # SC2207
      # bash 4.x+ (4.4+)
      if type mapfile &>/dev/null; then
        mapfile -t local_pkg_file < <(find -- * -maxdepth 0 -type f -not -name PKGBUILD 2>/dev/null)
      # bash 3.x+
      elif type read &>/dev/null; then
        while IFS='' read -r line; do local_pkg_file+=("$line"); done < <(find -- * -maxdepth 0 -type f -not -name PKGBUILD 2>/dev/null)
      else
        # single string
        # shellcheck disable=2207
        #local_pkg_file=$(find -- * -maxdepth 0 -type f -not -name PKGBUILD 2>/dev/null)
        # array (split)
        # shellcheck disable=2207
        local_pkg_file=($(find -- * -maxdepth 0 -type f -not -name PKGBUILD 2>/dev/null))
      fi
    else
      # filter directory/directories acceptable/alternative: / '/' /$ '/$'
      # SC2207
      # bash 4.x+ (4.4+)
      if type mapfile &>/dev/null; then
        # shellcheck disable=2010
        mapfile -t local_pkg_file < <(ls -p | grep -v '/$' | grep -v PKGBUILD 2>/dev/null)
      # bash 3.x+
      elif type read &>/dev/null; then
        # shellcheck disable=2010
        while IFS='' read -r line; do local_pkg_file+=("$line"); done < <(ls -p | grep -v '/$' | grep -v PKGBUILD 2>/dev/null)
      else
        # single string
        # shellcheck disable=2010,2207
        #local_pkg_file=$(ls -p | grep -v '/$' | grep -v PKGBUILD 2>/dev/null)
        # array (split)
        # shellcheck disable=2010,2207
        local_pkg_file=($(ls -p | grep -v '/$' | grep -v PKGBUILD 2>/dev/null))
      fi
    fi
    #if [[ -n $local_pkg_file ]]; then
    #if [[ -n ${local_pkg_file[@]} ]]; then
    if [[ -n ${local_pkg_file[*]} ]]; then
      [[ ${#local_pkg_file[@]} == 1 ]] && lpf=" " || lpf=s
      # OBSOLETE - already done
      ##if [[ $lpf == s ]]; then
      #if [[ ${#local_pkg_file[@]} != 1 ]]; then
        # "" -> " "
        #[[ -z $lpf ]] && lpf=" "
      #fi
      #echo -e "\e[1mlocal PKGBUILD file(s) found\e[0m"
      #echo -e "\e[1mlocal PKGBUILD file$lpf found\e[0m"
      if [[ $lpf == s ]]; then
        echo -e "\e[1mlocal PKGBUILD file$lpf found\e[0m"
      else
        echo -e "\e[1mlocal PKGBUILD file found\e[0m"
      fi
      echo "     local PKGBUILD file$lpf: ${#local_pkg_file[@]}"
      #echo "local PKGBUILD file name$lpf: $local_pkg_file"
      echo "local PKGBUILD file name$lpf:" "${local_pkg_file[@]}"
      echo
    fi
  fi
  # copied/modified (partial inversion) from above (local PKGBUILD file detection)
  # lengthy Git directory detection
  #if hash find 2>/dev/null; then
    # "-not -name '.*'" not required with 'find -- * -maxdepth 0' - required with 'find . -maxdepth 1' (also adds './' to each file; which must be filtered/removed)
    ##find -- * -maxdepth 0 -not -type f
    ##find -- * -maxdepth 0 -type d
    # SC2207
    # bash 4.x+ (4.4+)
    #if type mapfile &>/dev/null; then
      #mapfile -t git_dir < <(find -- * -maxdepth 0 -type d 2>/dev/null)
    # bash 3.x+
    #elif type read &>/dev/null; then
      #while IFS='' read -r line; do git_dir+=("$line"); done < <(find -- * -maxdepth 0 -type d 2>/dev/null)
    #else
      # single string
      # shellcheck disable=2207
      ##git_dir=$(find -- * -maxdepth 0 -type d 2>/dev/null)
      # array (split)
      # shellcheck disable=2207
      #git_dir=($(find -- * -maxdepth 0 -type d 2>/dev/null))
    #fi
  #else
    # filter directory/directories acceptable/alternative: / '/' /$ '/$'
    # SC2207
    # bash 4.x+ (4.4+)
    #if type mapfile &>/dev/null; then
      # shellcheck disable=2010
      ##mapfile -t git_dir < <(ls -p | grep -v '/' 2>/dev/null)
      #mapfile -t git_dir < <(ls -d */ 2>/dev/null)
    # bash 3.x+
    #elif type read &>/dev/null; then
      # shellcheck disable=2010
      ##while IFS='' read -r line; do git_dir+=("$line"); done < <(ls -p | grep -v '/' 2>/dev/null)
      #while IFS='' read -r line; do git_dir+=("$line"); done < <(ls -d */ 2>/dev/null)
    #else
      # single string
      # shellcheck disable=2010,2207
      ##git_dir=$(ls -p | grep -v '/' 2>/dev/null)
      ##git_dir=$(ls -d */ 2>/dev/null)
      # array (split)
      # shellcheck disable=2010,2207
      ##git_dir=($(ls -p | grep -v '/' 2>/dev/null))
      #git_dir=($(ls -d */ 2>/dev/null))
    #fi
  #fi
  # TODO maybe detect/error (or support) if src_dir is valid Git (-d .git)
  #if [[ -d .git ]]; then
    # TODO WIP
    #mv "$srcpkg_tmp"/* "$srcpkg_dir"
  #fi
  # one-liner - lengthy directory detection not required
  #if [[ -z $(ls -d */ 2>/dev/null) ]]; then
  ##if [[ $(echo */) == '*/' ]]; then
  # requires/uses lengthy directory detection
  ##if [[ -n ${git_dir[*]} ]]; then
  ##if [[ -z ${git_dir[*]} ]]; then
    #echo -e "\e[31merror: incompatible $tarc source package ($srcpkg) provided!\e[0m"
    ##echo -e "\e[31merror: Git directory/repository (\$git_dir) not found!\e[0m"
    #echo -e "\e[31merror: Git directory/repository not found!\e[0m"
    ##exit 7
    # shift -> continue
    #shift
    #continue
  #fi
  # TODO maybe replace with TODO above
  # support (via skip to copy/move src_dir) if src_dir is valid Git (-d .git)
  if [[ ! -d .git ]]; then
    #echo "converting/deobfuscating $tarc source package ($srcpkg) Git repository to working directory (checkout) ..."
    echo "converting/deobfuscating $tarc source package ($srcpkg) to Git working directory (checkout) ..."
    echo
    #loop_success=0
    #loop_success=
    #loop_cnt=0
    loop_cnt=
    #loop_success_cnt=0
    loop_success_cnt=
    for git_dir in */; do
    # requires/uses lengthy directory detection
    #for git_dir in "${git_dir[@]}"; do
      # remove ending/trailing forward slash (/) - patch for */ above
      git_dir=${git_dir::-1}
      # find first directory
      #break
      # use true instead of break to find last directory (inversion)
      #true
      # loop count
      (( loop_cnt++ ))
      # Git directory check
      if [[ -s $git_dir/config && -d $git_dir/objects/pack ]]; then
        # loop until first Git directory/repository found
        #break
        # loop until all Git directories/repositories found
        cd "$git_dir" || { shift; continue; }
        #mkdir -p "$git_dir/.git" || { shift; continue; }
        mkdir -p .git || { shift; continue; }
        #mv "$git_dir"/* "$git_dir/.git" || { shift; continue; }
        # SC2035
        mv ./* .git || { shift; continue; }
        #mv -- * .git || { shift; continue; }
        git init &>/dev/null || { shift; continue; }
        git checkout -f &>/dev/null || { shift; continue; }
        if hash touch 2>/dev/null && [[ -e .git/HEAD ]]; then
          #touch -r .git/HEAD "$git_dir" 2>/dev/null
          touch -r .git/HEAD . 2>/dev/null
        fi
        #if [[ -s git-remote.sh ]]; then
        if [[ -s $cdir/git-remote.sh ]]; then
          #she=./git-remote.sh
          she=$cdir/git-remote.sh
        elif [[ -s ${0%/*}/git-remote.sh ]]; then
          she=${0%/*}/git-remote.sh
        elif hash git-remote 2>/dev/null; then
          #she=git-remote
          she=$(command -v git-remote 2>/dev/null)
        elif [[ -s $HOME/srcpkg2git/git-remote.sh ]]; then
          she=$HOME/srcpkg2git/git-remote.sh
        fi
        #if [[ -n $git_remote_url && -s $cdir/git-remote.sh ]]; then
        if [[ -n $git_remote_url && -n $she ]]; then
          # remove ending/trailing forward slash (/) - OBSOLETE - this is now already done prior to $git_dir (and $src_dir) - see: patch for */
          #git_remote_dir=${git_dir::-1}
          git_remote_dir=$git_dir
          # replace whitespace ( ) with underscore (_)
          git_remote_dir=${git_remote_dir// /_}
          git_remote_url=${git_remote_url// /_}
          while :; do
            if [[ -n $SRCPKG_AUTO ]]; then
              GIT_REPLY=f
            else
              read -p "git push $git_remote_dir to $git_remote_url? (y/N/f/[git_remote_dir]): " GIT_REPLY
              #read -p "git push $git_remote_dir to $git_remote_url/$git_remote_dir? (y/N/f/[git_remote_dir]): " GIT_REPLY
              #read -p "git push $git_remote_dir to $git_remote_url/$git_remote_dir.git? (y/N/f/[git_remote_dir]): " GIT_REPLY
              echo
            fi
            case $GIT_REPLY in
            #y|Y)
            y|Y|f|F)
              [[ $GIT_REPLY == f || $GIT_REPLY == F ]] && git_force=1
              if [[ -z $git_force ]]; then
                echo "pushing git $git_remote_dir to $git_remote_url ..."
                #echo "pushing git $git_remote_dir to $git_remote_url/$git_remote_dir ..."
                #echo "pushing git $git_remote_dir to $git_remote_url/$git_remote_dir.git ..."
                echo
                #"$cdir/git-remote.sh" "$git_remote_url" "$git_remote_dir"
                "$she" "$git_remote_url" "$git_remote_dir"
              else
                git_force=
                echo "(force) pushing git $git_remote_dir to $git_remote_url ..."
                #echo "(force) pushing git $git_remote_dir to $git_remote_url/$git_remote_dir ..."
                #echo "(force) pushing git $git_remote_dir to $git_remote_url/$git_remote_dir.git ..."
                echo
                #"$cdir/git-remote.sh" "$git_remote_url" "$git_remote_dir" -f
                "$she" "$git_remote_url" "$git_remote_dir" -f
              fi
              echo
              break
              ;;
            n|N|"")
              break
              ;;
            *)
              continue_loop=
              while :; do
                read -n 1 -p "rename and git push $git_remote_dir to $GIT_REPLY? (y/N): "
                echo
                #case $REPLY in
                case ${REPLY,,} in
                y)
                  git_remote_dir=$GIT_REPLY
                  # replace whitespace ( ) with underscore (_)
                  git_remote_dir=${git_remote_dir// /_}
                  # copied from above
                  #if [[ -z $git_force ]]; then
                    #echo "pushing git $git_remote_dir to $git_remote_url ..."
                    ##echo "pushing git $git_remote_dir to $git_remote_url/$git_remote_dir ..."
                    ##echo "pushing git $git_remote_dir to $git_remote_url/$git_remote_dir.git ..."
                    #echo
                    #"$cdir/git-remote.sh" "$git_remote_url" "$git_remote_dir"
                    #"$she" "$git_remote_url" "$git_remote_dir"
                  #else
                    #git_force=
                    #echo "(force) pushing git $git_remote_dir to $git_remote_url ..."
                    ##echo "(force) pushing git $git_remote_dir to $git_remote_url ..."
                    ##echo "(force) pushing git $git_remote_dir to $git_remote_url.git ..."
                    #echo
                    #"$cdir/git-remote.sh" "$git_remote_url" "$git_remote_dir" -f
                    #"$she" "$git_remote_url" "$git_remote_dir" -f
                  #fi
                  #echo
                  #break
                  # continue loop; allow/enable potential (re)options - yes/No, force, or rename (y/N/f/[git_remote_dir])
                  continue_loop=1
                  break
                  ;;
                n|"")
                  continue_loop=1
                  break
                  ;;
                esac
              done
              # break the loop
              #break
              # continue or break the loop
              # break or continue the loop
              #[[ -z $continue_loop ]] && break || continue
              if [[ -z $continue_loop ]]; then
                break
              else
                continue_loop=
                continue
              fi
              ;;
            esac
          done
          #echo
        fi
        #cd "$src_dir" || { shift; continue; }
        cd .. || { shift; continue; }
        # remove ending/trailing forward slash (/)
        echo "$git_dir: done"
        echo
        # alternative
        #if hash touch 2>/dev/null; then
          ##touch -r "$src_dir" "$git_dir" 2>/dev/null
          #touch -r . "$git_dir" 2>/dev/null
        #fi
        # successful loop
        #loop_success=1
        # successful loop count
        (( loop_success_cnt++ ))
      else
        git_dir=
        continue
      fi
    done
    #if [[ -z $git_dir ]]; then
    #if [[ ! -d $git_dir ]]; then
    #if [[ -z $loop_success_cnt ]]; then
    #if [[ $loop_success_cnt -le 0 ]]; then
    if (( loop_success_cnt <= 0 )); then
      # PKGBUILD tar[.gz|.xz] source package detection/support (else incompatible tar[.gz|.xz] source package)
      # no subdirectories
      #if [[ -z $git_dir && -e PKGBUILD ]]; then
      if [[ -e PKGBUILD ]]; then
        echo -e "\e[1mPKGBUILD $tarc source package ($srcpkg) provided\nrequires no Git conversion/deobfuscation; only extraction\e[0m"
        #echo -e "\e[1mPKGBUILD $tarc source package ($srcpkg) provided\nrequires no Git processing (conversion/deobfuscation); only extraction\e[0m"
        echo
        #echo "copying PKGBUILD $tarc source package ($srcpkg) ..."
        #echo "extracting PKGBUILD $tarc source package ($srcpkg) ..."
        echo "copying/extracting PKGBUILD $tarc source package ($srcpkg) ..."
        echo
      else
        echo -e "\e[33mwarning: incompatible $tarc source package ($srcpkg) provided!\e[0m"
        #echo -e "\e[33mwarning: Git directory/repository ($git_dir) and/or PKGBUILD not found!\e[0m"
        echo -e "\e[33mwarning: Git directory/repository and/or PKGBUILD not found!\e[0m"
        echo
        while :; do
          read -n 1 -p "proceed with $tarc source package ($srcpkg)? (y/N): "
          echo
          #case $REPLY in
          case ${REPLY,,} in
          y)
            echo -e "\e[1m$tarc source package ($srcpkg) provided\nrequires no Git conversion/deobfuscation; only extraction\e[0m"
            #echo -e "\e[1m$tarc source package ($srcpkg) provided\nrequires no Git processing (conversion/deobfuscation); only extraction\e[0m"
            echo
            #echo "copying $tarc source package ($srcpkg) ..."
            #echo "extracting $tarc source package ($srcpkg) ..."
            echo "copying/extracting $tarc source package ($srcpkg) ..."
            echo
            break
            ;;
          n|"")
            #exit 8
            # shift -> continue (can't continue in nested loop)
            #shift
            # can't continue in nested loop
            #continue
            # shift -> continue (nested loop workaround)
            sc=1
            break
            ;;
          esac
        done
        # nested loop workaround - shift -> continue
        if [[ -n $sc ]]; then
          sc=
          shift
          continue
        fi
      fi
      # RAW extract tar[.gz|.xz] - SECURITY RISK / OVERWRITE RISK / INEFFICIENT (RE-EXTRACT)
      #rm -fr "${srcpkg_dir:?}/${src_dir:?}"
      ##tar -xzf "$srcpkg" --directory "$srcpkg_dir"
      ##tar -xf "$srcpkg" --directory "$srcpkg_dir"
      #tar -xzf "$srcpkg" -C "$srcpkg_dir"
      #tar -xf "$srcpkg" -C "$srcpkg_dir"
      # TODO maybe make overwrite/remove/replace into a function and call here instead of this cobbled together clone from below
      # cobbled together (cloned) from below (automated/forced/reduced)
      #(
      #cd .. || { shift; continue; }
      cd "$srcpkg_tmp" || { shift; continue; }
      rm -fr "${srcpkg_dir:?}/${src_dir:?}"
      # move srcpkg_tmp to srcpkg_dir
      #mv */ .. || { shift; continue; }
      #mv "$srcpkg_tmp/$src_dir" "$srcpkg_dir" || { shift; continue; }
      # requires cd "$srcpkg_tmp" above
      mv "$src_dir" "$srcpkg_dir" || { shift; continue; }
      #)
      #if [[ -d "${srcpkg_dir:?}/${src_dir:?}" ]]; then
      if [[ -d $srcpkg_dir/$src_dir ]]; then
        echo -e "\e[1m$src_dir: done\e[0m"
        echo
      fi
      echo -e "\e[1m$src_dir: $srcpkg_dir/$src_dir\e[0m"
      echo
      # TODO maybe enable/set/use postloop cleanup below
      # retain residual empty TMPDIR
      #rm -fr "$srcpkg_tmp"/*
      # SC2115
      #rm -fr "${srcpkg_tmp:?}"/*
      #(
      #cleanup
      #)
      rm -fr "$srcpkg_tmp"
      # shift -> continue
      shift
      continue
    fi
    # ANTIQUATED/OBSOLETE
    ##mv */ .git || { shift; continue; }
    #mv "$git_dir" .git || { shift; continue; }
    ##git init || { shift; continue; }
    ##git checkout -f || { shift; continue; }
    ##git reset --hard || { shift; continue; }
    #git init &>/dev/null || { shift; continue; }
    #git checkout -f &>/dev/null || { shift; continue; }
    ##git reset --hard &>/dev/null || { shift; continue; }
    # TODO maybe add configurable toggle (remove untracked directories/files)
    # remove (Arch/pacman) untracked files
    ##for uf in .SRCINFO PKGBUILD; do
      ##rm -f "$uf"
    ##done
    # remove all untracked directories/files
    ##git clean -dfx
    # honor .gitignore
    ##git clean -df
    # remove all untracked files ONLY
    ##git clean -fx
    # honor .gitignore
    ##git clean -f
    #if hash touch 2>/dev/null && [[ -e .git/HEAD ]]; then
      ##touch -r .git/HEAD "$src_dir" 2>/dev/null
      #touch -r .git/HEAD . 2>/dev/null
    #fi
    #echo
    echo -e "\e[1m$src_dir: done\e[0m"
    echo
  fi
  # TODO maybe move this into function (see: cobbled together TODO above)
  # overwrite/remove/replace
  #cd .. || { shift; continue; }
  cd "$srcpkg_tmp" || { shift; continue; }
  sc=
  if [[ -n $SRCPKG_AUTO ]]; then
    overwrite=1
  fi
  # SC2115
  #if [[ -n $overwrite && -d ${srcpkg_dir:?}/${src_dir:?} ]]; then
  if [[ -n $overwrite && -d $srcpkg_dir/$src_dir ]]; then
    rm -fr "${srcpkg_dir:?}/${src_dir:?}"
    echo "removed (existing/prior) directory ($srcpkg_dir/$src_dir)"
    echo
  fi
  #while [[ -d ${srcpkg_dir:?}/${src_dir:?} ]]; do
  while [[ -d $srcpkg_dir/$src_dir ]]; do
    #read -n 1 -p "remove/replace (existing/prior) directory?: $srcpkg_dir/$src_dir (Y/n): "
    read -n 1 -p "remove/replace (existing/prior) directory?: $srcpkg_dir/$src_dir (Y/n/a): "
    #read -n 1 -p "remove/replace (existing/prior) directory?: $srcpkg_dir/$src_dir (Y/n/[a]): "
    echo
    #case $REPLY in
    case ${REPLY,,} in
    #y|Y|"")
    #a|A|y|Y|"")
    a|y|"")
      if [[ ${REPLY,,} == a ]]; then
        overwrite=1
      fi
      # remove old/prior directory (overwrite)
      # SC2115
      #if [[ -d ${srcpkg_dir:?}/${src_dir:?} ]]; then
      #if [[ -d $srcpkg_dir/$src_dir ]]; then
        #rm -fr "${srcpkg_dir:?}/${src_dir:?}"
      #fi
      #rm -fr "${srcpkg_dir:?}/${src_dir:?}"
      #if [[ ! -d ${srcpkg_dir:?}/${src_dir:?} ]]; then
      #if [[ ! -d $srcpkg_dir/$src_dir ]]; then
        #echo "removed (existing/prior) directory ($srcpkg_dir/$src_dir)"
      #fi
      rm -fr "${srcpkg_dir:?}/${src_dir:?}" || continue
      echo "removed (existing/prior) directory ($srcpkg_dir/$src_dir)"
      echo
      # break or loop upon (potential) remove error
      #break
      ;;
    #n|N)
    n)
      # dirty move/overwrite (break)
      #break
      # cleanup -> shift -> continue - use postloop cleanup
      #cleanup
      #exit 0
      # shift -> continue (can't continue in nested loop)
      #shift
      # can't continue in nested loop
      #continue
      # shift -> continue (nested loop workaround)
      sc=1
      break
      ;;
    esac
  done
  # nested loop workaround - shift -> continue
  if [[ -n $sc ]]; then
    sc=
    shift
    continue
  fi
  # move srcpkg_tmp to srcpkg_dir
  #mv */ .. || { shift; continue; }
  #mv "$srcpkg_tmp/$src_dir" "$srcpkg_dir" || { shift; continue; }
  # requires cd "$srcpkg_tmp" above
  mv "$src_dir" "$srcpkg_dir" || { shift; continue; }
  echo -e "\e[1m$src_dir: $srcpkg_dir/$src_dir\e[0m"

  # postliminary cleanup
  cleanup

  echo
  shift
  # redundant
  #continue
done
#echo

# concluding/final source package argument check (3 of 3)
if [[ -z $valid_arg ]]; then
  echo -e "\e[31merror: $tarc source package(s) not provided!\e[0m"
  echo
  help
  exit 2
fi

# TODO maybe add configurable toggle
# postloop cleanup
#cleanup
