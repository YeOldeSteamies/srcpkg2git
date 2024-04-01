#!/bin/sh
# git-credential-shelper
# Copyright (C) 2018 Drake Stefani
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

if [ -s git-remote.conf ]; then
  . git-remote.conf
elif [ -s "${0%/*}/git-remote.conf" ]; then
  . "${0%/*}/git-remote.conf"
elif [ -s "$HOME/.config/git-remote.conf" ]; then
  . "$HOME/.config/git-remote.conf"
elif [ -s /etc/git-remote.conf ]; then
  . /etc/git-remote.conf
fi
[ -n "$git_remote_username" ] && echo username=$git_remote_username
if [ -n "$git_remote_password" ]; then
  echo password=$git_remote_password
elif [ -s "$git_remote_password_file" ] && hash head 2>/dev/null; then
  echo password=$(head -n 1 "$git_remote_password_file")
elif [ -s "$git_remote_password_file" ] && hash cat 2>/dev/null; then
  echo password=$(cat "$git_remote_password_file")
fi
