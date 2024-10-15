# git
git_bin := $(shell command -v git 2>/dev/null)
#git_remote_url := $(shell git remote -v 2>/dev/null)
git_remote_url = $(shell git remote -v 2>/dev/null)
remote_url := https://github.com/YeOldeSteamies/srcpkg2git.git

# install/target path variables
# system
system_bin_dir := /usr/bin
system_config_dir := /etc
system_icon_dir_1 := /usr/local/share/icons
system_icon_dir_2 := /usr/share/icons
system_icon_dir_3 := /usr/share/pixmaps
ifneq ($(wildcard $(system_icon_dir_1)),)
system_icon_dir := $(system_icon_dir_1)
else ifneq ($(wildcard $(system_icon_dir_2)),)
system_icon_dir := $(system_icon_dir_2)
else ifneq ($(wildcard $(system_icon_dir_3)),)
system_icon_dir := $(system_icon_dir_3)
else
system_icon_dir := $(system_icon_dir_2)
#system_icon_dir := $(system_icon_dir_3)
endif
system_license_dir := /usr/share/licenses/srcpkg2git
system_local_bin_dir := /usr/local/bin
# user
user_bin_dir := $(HOME)/bin
user_config_dir := $(HOME)/.config
user_home_dir := $(HOME)/srcpkg2git
user_icon_dir := $(HOME)/.icons
user_license_dir := $(HOME)/.local/share/licenses/srcpkg2git
user_local_bin_dir := $(HOME)/.local/bin
#systemd_system_unit_dir := $(shell pkg-config --define-variable=prefix=$(prefix) --variable=systemdsystemunitdir \
  systemd 2>/dev/null || echo $(libdir)/systemd/system)
#systemd_user_unit_dir := $(shell pkg-config --define-variable=prefix=$(prefix) --variable=systemduserunitdir \
  systemd 2>/dev/null || echo $(libdir)/systemd/user)
# systemd global (system/user)
systemd_global_dir := /etc/systemd/user
systemd_global_dir_2 := /usr/lib/systemd/user
# systemd system
systemd_system_system_dir := /etc/systemd/system
systemd_system_dir := $(systemd_system_system_dir)
systemd_system_system_dir_2 := /usr/lib/systemd/system
systemd_system_dir_2 := $(systemd_system_system_dir_2)
# systemd user
systemd_user_user_dir := $(HOME)/.local/share/systemd/user
systemd_user_dir := $(systemd_user_user_dir)
systemd_user_user_dir_2 := $(HOME)/.config/systemd/user
systemd_user_dir_2 := $(systemd_user_user_dir_2)
# XDG desktop entry system
xdg_system_dir := /usr/local/share/applications
xdg_system_dir_2 := /usr/share/applications
# XDG desktop entry user
xdg_user_dir := $(HOME)/.local/share/applications

# default remote_url (DO NOT EDIT)
ifeq ($(remote_url),)
#ifndef remote_url
remote_url := https://github.com/YeOldeSteamies/srcpkg2git.git
endif

# default user_home_dir (DO NOT EDIT)
ifeq ($(user_home_dir),)
#ifndef user_home_dir
user_home_dir := $(HOME)/srcpkg2git
endif

#.PHONY: help uninstall uninstall-all update
#.PHONY: help uninstall uninstall-all
.PHONY: help uninstall

#update: .git/
update:
ifneq ($(wildcard .git/),)
	@echo "updating srcpkg2git (git): $(PWD)"
ifeq ($(git_bin),)
#ifndef git_bin
	@#echo "error: git not found! git required!"
	@#echo "install git to continue"
	@echo "warning: git not found! git recommended!"
	@echo "install git to update"
	@echo
else ifeq ($(git_remote_url),)
#else ifndef git_remote_url
ifneq ($(remote_url),)
#ifdef remote_url
	@echo "setting git remote: $(remote_url)"
	@#git remote remove origin 2>/dev/null
	@#git remote add origin $(remote_url)
	@#$(git_bin) remote remove origin 2>/dev/null
	@#$(git_bin) remote add origin $(remote_url)
# set git remote prompt
	@# set git remote prompt
	@echo
	@#echo "set git remote? [Y/n]:"
	@read -n 1 -p "set git remote? [Y/n]: " input; echo; \
	  if [ "$$input" != "n" ] && [ "$$input" != "N" ]; then \
	    $(git_bin) remote remove origin 2>/dev/null; \
	    $(git_bin) remote add origin $(remote_url) && \
	    echo "set git remote: $(remote_url)"; \
	  else \
	    echo "set git remote aborted!"; \
	  fi
endif
endif
# should always be true
ifneq ($(git_remote_url),)
#ifdef git_remote_url
ifeq ($(PWD),$(user_home_dir))
	@#git pull --rebase
	@#git pull || git pull --rebase
	@#$(git_bin) pull --rebase
	@$(git_bin) pull || $(git_bin) pull --rebase
else
	@#git pull
	@$(git_bin) pull
endif
endif
else ifneq ($(PWD),$(user_home_dir))
# git clone remote prompt
	@# git clone remote prompt
	@echo "git clone remote: $(remote_url)"
	@echo "         to path: $(PWD)/srcpkg2git"
	@echo
	@read -n 1 -p "git clone remote? [Y/n]: " input; echo; \
	  if [ "$$input" != "n" ] && [ "$$input" != "N" ]; then \
	    $(git_bin) clone $(remote_url) && \
	    echo "git clone complete: $(PWD)/srcpkg2git" && \
	    #rm -v Makefile && \
	    rm -v "$(PWD)/Makefile" && \
	    echo "replaced: $(PWD)/Makefile" && \
	    echo "    with: $(PWD)/srcpkg2git/Makefile" && \
	    echo "$(PWD)/Makefile -> $(PWD)/srcpkg2git/Makefile"; \
	  else \
	    echo "git clone aborted!"; \
	  fi
endif
ifeq ($(PWD),$(user_home_dir))
	@make install-user-home-update
endif

help:
	@echo
	@echo "srcpkg2git Makefile help"
	@echo
	@echo "make usage:"
	@echo "make [help|install|uninstall[-all]|update]"
	@echo
	@echo "make -> make update"
	@echo
	@echo "make install usage:"
	@echo "make install[-systemd][-system[-bin|-local-bin|-package]]"
	@echo "make install[-systemd][-user[-bin|-home|-home-git|-home-update|-local-bin]]"
	@echo
	@echo "make install-system -> install-system-local-bin"
	@echo "make install[-user] -> install-user-local-bin"
	@echo
	@echo "make install-systemd-system -> install-systemd-system-local-bin"
	@echo "make install-systemd[-user] -> install-systemd-user-local-bin"
	@echo
	@echo "make install-systemd-user-home-common"
	@echo "make install-user-home-update"
	@echo
	@echo "see (included) local documentation for target details:"
ifneq ($(wildcard README.html),)
	@echo "file://$(PWD)/README.html"
else
	@echo "warning: $(PWD)/README.html not found!"
endif
ifneq ($(wildcard README.md),)
	@echo "file://$(PWD)/README.md"
else
	@echo "warning: $(PWD)/README.md not found!"
endif
	@echo
ifneq ($(remote_url),)
#ifdef remote_url
	@echo "remote documentation:"
	@#echo "$(remote_url)"
	@#echo "$(remote_url)/"
	@#echo "$(patsubst %.git,%,$(remote_url))"
	@#echo "$(patsubst %.git,%,$(remote_url))/-/blob/master/README.md"
	@echo "$(remote_url:.git=)"
	@echo "$(remote_url:.git=)/-/blob/master/README.md"
	@echo
endif

#install: install-system-local-bin
install: install-user-local-bin

#install-system: install
install-system: install-system-local-bin

# system package (e.g., PKGBUILD)
install-system-bin: git-commit.sh git-remote.sh srcpkg2git.sh srcpkg-dl.sh LICENSE.GPL LICENSE.MPL
	@echo "installing srcpkg2git (system): $(DESTDIR)$(system_bin_dir)"
	@echo "root required to install"
	@echo "system-bin install target intended for making system package:"
	@echo "1. conflicts with / overwrites system package manager"
	@echo "2. ignored (not removed/uninstalled) by uninstall target"
	@install -CDvm755 git-commit.sh "$(DESTDIR)$(system_bin_dir)/git-commit"
ifneq ($(wildcard git-credential-bashelper.sh),)
	@install -CDvm755 git-credential-bashelper.sh "$(DESTDIR)$(system_bin_dir)/git-credential-bashelper"
endif
ifneq ($(wildcard git-credential-shelper.sh),)
	@install -CDvm755 git-credential-shelper.sh "$(DESTDIR)$(system_bin_dir)/git-credential-shelper"
endif
ifneq ($(wildcard config/git-remote.conf.template),)
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
endif
	@install -CDvm755 git-remote.sh "$(DESTDIR)$(system_bin_dir)/git-remote"
	@install -CDvm644 LICENSE.GPL "$(DESTDIR)$(system_license_dir)/LICENSE.GPL"
	@install -CDvm644 LICENSE.MPL "$(DESTDIR)$(system_license_dir)/LICENSE.MPL"
	@install -CDvm755 srcpkg2git.sh "$(DESTDIR)$(system_bin_dir)/srcpkg2git"
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/system-bin.desktop),)
	@install -CDvm644 xdg/system-bin.desktop "$(DESTDIR)$(xdg_system_dir)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@echo "Exec=$(system_bin_dir)/srcpkg-dl --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_system_dir)/srcpkg2git.desktop"
endif
ifneq ($(wildcard config/srcpkg-dl.conf.template),)
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
endif
	@install -CDvm755 srcpkg-dl.sh "$(DESTDIR)$(system_bin_dir)/srcpkg-dl"
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(system_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (system) install complete: $(DESTDIR)$(system_bin_dir)"

install-system-local-bin: git-commit.sh git-remote.sh srcpkg2git.sh srcpkg-dl.sh LICENSE.GPL LICENSE.MPL
	@echo "installing srcpkg2git (system): $(DESTDIR)$(system_local_bin_dir)"
	@echo "root required to install"
	@install -CDvm755 git-commit.sh "$(DESTDIR)$(system_local_bin_dir)/git-commit"
ifneq ($(wildcard git-credential-bashelper.sh),)
	@install -CDvm755 git-credential-bashelper.sh "$(DESTDIR)$(system_local_bin_dir)/git-credential-bashelper"
endif
ifneq ($(wildcard git-credential-shelper.sh),)
	@install -CDvm755 git-credential-shelper.sh "$(DESTDIR)$(system_local_bin_dir)/git-credential-shelper"
endif
ifneq ($(wildcard config/git-remote.conf.template),)
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
endif
	@install -CDvm755 git-remote.sh "$(DESTDIR)$(system_local_bin_dir)/git-remote"
	@install -CDvm644 LICENSE.GPL "$(DESTDIR)$(system_license_dir)/LICENSE.GPL"
	@install -CDvm644 LICENSE.MPL "$(DESTDIR)$(system_license_dir)/LICENSE.MPL"
	@install -CDvm755 srcpkg2git.sh "$(DESTDIR)$(system_local_bin_dir)/srcpkg2git"
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/system-local-bin.desktop),)
	@install -CDvm644 xdg/system-local-bin.desktop "$(DESTDIR)$(xdg_system_dir)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@echo "Exec=$(system_local_bin_dir)/srcpkg-dl --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_system_dir)/srcpkg2git.desktop"
endif
ifneq ($(wildcard config/srcpkg-dl.conf.template),)
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
endif
	@install -CDvm755 srcpkg-dl.sh "$(DESTDIR)$(system_local_bin_dir)/srcpkg-dl"
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(system_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (system) install complete: $(DESTDIR)$(system_local_bin_dir)"

# system package (e.g., PKGBUILD)
install-system-package: git-commit.sh git-remote.sh srcpkg2git.sh srcpkg-dl.sh LICENSE.GPL LICENSE.MPL
	@echo "installing srcpkg2git (system): $(DESTDIR)$(system_bin_dir)"
	@echo "root required to install"
	@echo "system-package install target intended for making system package:"
	@echo "1. conflicts with / overwrites system package manager"
	@echo "2. ignored (not removed/uninstalled) by uninstall target"
	@install -CDvm755 git-commit.sh "$(DESTDIR)$(system_bin_dir)/git-commit"
ifneq ($(wildcard git-credential-bashelper.sh),)
	@install -CDvm755 git-credential-bashelper.sh "$(DESTDIR)$(system_bin_dir)/git-credential-bashelper"
endif
ifneq ($(wildcard git-credential-shelper.sh),)
	@install -CDvm755 git-credential-shelper.sh "$(DESTDIR)$(system_bin_dir)/git-credential-shelper"
endif
ifneq ($(wildcard config/git-remote.conf.template),)
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(system_config_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(system_config_dir)/git-remote.conf"
endif
	@install -CDvm755 git-remote.sh "$(DESTDIR)$(system_bin_dir)/git-remote"
	@install -CDvm644 LICENSE.GPL "$(DESTDIR)$(system_license_dir)/LICENSE.GPL"
	@install -CDvm644 LICENSE.MPL "$(DESTDIR)$(system_license_dir)/LICENSE.MPL"
	@install -CDvm755 srcpkg2git.sh "$(DESTDIR)$(system_bin_dir)/srcpkg2git"
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/system-bin.desktop),)
	@install -CDvm644 xdg/system-bin.desktop "$(DESTDIR)$(xdg_system_dir_2)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@echo "Exec=$(system_bin_dir)/srcpkg-dl --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_system_dir_2)/srcpkg2git.desktop"
endif
ifneq ($(wildcard config/srcpkg-dl.conf.template),)
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(system_config_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(system_config_dir)/srcpkg-dl.conf"
endif
	@install -CDvm755 srcpkg-dl.sh "$(DESTDIR)$(system_bin_dir)/srcpkg-dl"
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(system_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (system) install complete: $(DESTDIR)$(system_bin_dir)"

#install-user: install
install-user: install-user-local-bin

install-user-local-bin: git-commit.sh git-remote.sh srcpkg2git.sh srcpkg-dl.sh LICENSE.GPL LICENSE.MPL
	@echo "installing srcpkg2git (user): $(DESTDIR)$(user_local_bin_dir)"
	@install -CDvm755 git-commit.sh "$(DESTDIR)$(user_local_bin_dir)/git-commit"
ifneq ($(wildcard git-credential-bashelper.sh),)
	@install -CDvm755 git-credential-bashelper.sh "$(DESTDIR)$(user_local_bin_dir)/git-credential-bashelper"
endif
ifneq ($(wildcard git-credential-shelper.sh),)
	@install -CDvm755 git-credential-shelper.sh "$(DESTDIR)$(user_local_bin_dir)/git-credential-shelper"
endif
ifneq ($(wildcard config/git-remote.conf.template),)
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
endif
	@install -CDvm755 git-remote.sh "$(DESTDIR)$(user_local_bin_dir)/git-remote"
	@install -CDvm644 LICENSE.GPL "$(DESTDIR)$(user_license_dir)/LICENSE.GPL"
	@install -CDvm644 LICENSE.MPL "$(DESTDIR)$(user_license_dir)/LICENSE.MPL"
	@install -CDvm755 srcpkg2git.sh "$(DESTDIR)$(user_local_bin_dir)/srcpkg2git"
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/user-local-bin.desktop),)
	@install -CDvm644 xdg/user-local-bin.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@#echo "Exec=$(user_local_bin_dir)/srcpkg-dl --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "Exec=/usr/bin/bash -c \"'\\\\\$HOME/.local/bin/srcpkg-dl' --auto\"" >> xdg/srcpkg2git-gen.desktop
# optional cosmetic user patch (sed required)
ifneq ($(shell command -v sed 2>/dev/null),)
	@sed -i '4s/$/ (user)/' xdg/srcpkg2git-gen.desktop
endif
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
endif
ifneq ($(wildcard config/srcpkg-dl.conf.template),)
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
endif
	@install -CDvm755 srcpkg-dl.sh "$(DESTDIR)$(user_local_bin_dir)/srcpkg-dl"
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(user_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (user) install complete: $(DESTDIR)$(user_local_bin_dir)"

install-user-bin: git-commit.sh git-remote.sh srcpkg2git.sh srcpkg-dl.sh LICENSE.GPL LICENSE.MPL
	@echo "installing srcpkg2git (user): $(DESTDIR)$(user_bin_dir)"
	@install -CDvm755 git-commit.sh "$(DESTDIR)$(user_bin_dir)/git-commit"
ifneq ($(wildcard git-credential-bashelper.sh),)
	@install -CDvm755 git-credential-bashelper.sh "$(DESTDIR)$(user_bin_dir)/git-credential-bashelper"
endif
ifneq ($(wildcard git-credential-shelper.sh),)
	@install -CDvm755 git-credential-shelper.sh "$(DESTDIR)$(user_bin_dir)/git-credential-shelper"
endif
ifneq ($(wildcard config/git-remote.conf.template),)
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
endif
	@install -CDvm755 git-remote.sh "$(DESTDIR)$(user_bin_dir)/git-remote"
	@#install -CDvm644 LICENSE.GPL "$(DESTDIR)$(user_bin_dir)/srcpkg2git.LICENSE.GPL"
	@#install -CDvm644 LICENSE.MPL "$(DESTDIR)$(user_bin_dir)/srcpkg2git.LICENSE.MPL"
	@install -CDvm644 LICENSE.GPL "$(DESTDIR)$(user_license_dir)/LICENSE.GPL"
	@install -CDvm644 LICENSE.MPL "$(DESTDIR)$(user_license_dir)/LICENSE.MPL"
	@install -CDvm755 srcpkg2git.sh "$(DESTDIR)$(user_bin_dir)/srcpkg2git"
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/user-bin.desktop),)
	@install -CDvm644 xdg/user-bin.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@#echo "Exec=$(user_bin_dir)/srcpkg-dl --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "Exec=/usr/bin/bash -c \"'\\\\\$HOME/bin/srcpkg-dl' --auto\"" >> xdg/srcpkg2git-gen.desktop
# optional cosmetic user patch (sed required)
ifneq ($(shell command -v sed 2>/dev/null),)
	@sed -i '4s/$/ (user)/' xdg/srcpkg2git-gen.desktop
endif
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
endif
ifneq ($(wildcard config/srcpkg-dl.conf.template),)
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
endif
	@install -CDvm755 srcpkg-dl.sh "$(DESTDIR)$(user_bin_dir)/srcpkg-dl"
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(user_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (user) install complete: $(DESTDIR)$(user_bin_dir)"

install-user-home: git-commit.sh git-remote.sh srcpkg2git.sh srcpkg-dl.sh LICENSE.GPL LICENSE.MPL
# prevent redundant install
ifeq ($(PWD),$(user_home_dir))
#ifeq ($(wildcard .git/),)
	@##make install-user-home
	@##make install-systemd-user-home
	@#make install-user-home-update
#else
	@##make install-user-home-git
	@##make install-systemd-user-home-git
	@#make update
#endif
	@make update
else
	@echo "installing srcpkg2git (user): $(DESTDIR)$(user_home_dir)"
	@install -CDvm755 git-commit.sh "$(DESTDIR)$(user_home_dir)/git-commit.sh"
ifneq ($(wildcard git-credential-bashelper.sh),)
	@install -CDvm755 git-credential-bashelper.sh "$(DESTDIR)$(user_home_dir)/git-credential-bashelper.sh"
endif
ifneq ($(wildcard git-credential-shelper.sh),)
	@install -CDvm755 git-credential-shelper.sh "$(DESTDIR)$(user_home_dir)/git-credential-shelper.sh"
endif
ifneq ($(wildcard config/git-remote.conf.template),)
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_home_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_home_dir)/git-remote.conf"
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_home_dir)/git-remote.conf.template"
endif
	@install -CDvm755 git-remote.sh "$(DESTDIR)$(user_home_dir)/git-remote.sh"
	@install -CDvm644 LICENSE.GPL "$(DESTDIR)$(user_home_dir)/LICENSE.GPL"
	@install -CDvm644 LICENSE.MPL "$(DESTDIR)$(user_home_dir)/LICENSE.MPL"
	@install -CDvm755 srcpkg2git.sh "$(DESTDIR)$(user_home_dir)/srcpkg2git.sh"
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/user-home.desktop),)
	@install -CDvm644 xdg/user-home.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@#echo "Exec=$(user_home_dir)/srcpkg-dl.sh --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "Exec=/usr/bin/bash -c \"'\\\\\$HOME/srcpkg2git/srcpkg-dl.sh' --auto\"" >> xdg/srcpkg2git-gen.desktop
# optional cosmetic user patch (sed required)
ifneq ($(shell command -v sed 2>/dev/null),)
	@sed -i '4s/$/ (user)/' xdg/srcpkg2git-gen.desktop
endif
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
endif
ifneq ($(wildcard config/srcpkg-dl.conf.template),)
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_home_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_home_dir)/srcpkg-dl.conf"
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_home_dir)/srcpkg-dl.conf.template"
endif
	@install -CDvm755 srcpkg-dl.sh "$(DESTDIR)$(user_home_dir)/srcpkg-dl.sh"
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(user_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (user) home install complete: $(DESTDIR)$(user_home_dir)"
endif

install-user-home-git: .git/
ifeq ($(git_bin),)
#ifndef git_bin
	@echo "error: git not found! git required!"
	@echo "install git to continue"
# prevent redundant install
else ifeq ($(PWD),$(user_home_dir))
	@make update
else
	@echo "git installing srcpkg2git (user): $(DESTDIR)$(user_home_dir)"
# git install (git copy + checkout)
	@# git install (git copy + checkout)
	@echo "copying srcpkg2git git: $(PWD)"
	@echo "               to path: $(DESTDIR)$(user_home_dir)"
	@#rm -fr "$(DESTDIR)$(user_home_dir)"
	@rm -fr "$(DESTDIR)$(user_home_dir)/.git/"
	@mkdir -p "$(DESTDIR)$(user_home_dir)"
	@#[ -s .gitignore ] && cp -a .gitignore "$(DESTDIR)$(user_home_dir)/.gitignore"
	@cp -ar .git/ "$(DESTDIR)$(user_home_dir)/.git/"
	@#cd "$(DESTDIR)$(user_home_dir)" && git checkout -f
	@cd "$(DESTDIR)$(user_home_dir)" && $(git_bin) checkout -f
	@echo "srcpkg2git git copy complete: $(DESTDIR)$(user_home_dir)"
# git update
#ifneq ($(git_remote_url),)
##ifdef git_remote_url
	@# git update (git pull)
	@#cd "$(DESTDIR)$(user_home_dir)" && git pull
	@#cd "$(DESTDIR)$(user_home_dir)" && git pull --rebase
	@#cd "$(DESTDIR)$(user_home_dir)" && $(git_bin) pull
	@#cd "$(DESTDIR)$(user_home_dir)" && $(git_bin) pull --rebase
	@# git update (git checkout + pull) - 2-in-1
	@#cd "$(DESTDIR)$(user_home_dir)" && git checkout -f && git pull
	@#cd "$(DESTDIR)$(user_home_dir)" && git checkout -f && git pull --rebase
	@#cd "$(DESTDIR)$(user_home_dir)" && $(git_bin) checkout -f && $(git_bin) pull
	@#cd "$(DESTDIR)$(user_home_dir)" && $(git_bin) checkout -f && $(git_bin) pull --rebase
	@#echo "srcpkg2git 'git update' complete: $(DESTDIR)$(user_home_dir)"
#endif
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/user-home.desktop),)
	@install -CDvm644 xdg/user-home.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@#echo "Exec=$(user_home_dir)/srcpkg-dl.sh --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "Exec=/usr/bin/bash -c \"'\\\\\$HOME/srcpkg2git/srcpkg-dl.sh' --auto\"" >> xdg/srcpkg2git-gen.desktop
# optional cosmetic user patch (sed required)
ifneq ($(shell command -v sed 2>/dev/null),)
	@sed -i '4s/$/ (user)/' xdg/srcpkg2git-gen.desktop
endif
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
endif
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(user_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (user) home (git) install complete: $(DESTDIR)$(user_home_dir)"
endif

install-user-home-update:
	@#echo "updating srcpkg2git (git) home install: $(DESTDIR)$(user_home_dir)"
	@echo "updating srcpkg2git (user) home install: $(DESTDIR)$(user_home_dir)"
# pregenerated XDG.desktop
ifneq ($(wildcard xdg/user-home.desktop),)
	@install -CDvm644 xdg/user-home.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
# generate XDG.desktop
else ifneq ($(wildcard xdg/srcpkg2git-gen.desktop.part),)
	@cp -f xdg/srcpkg2git-gen.desktop.part xdg/srcpkg2git-gen.desktop
	@#echo "Exec=$(user_home_dir)/srcpkg-dl.sh --auto" >> xdg/srcpkg2git-gen.desktop
	@echo "Exec=/usr/bin/bash -c \"'\\\\\$HOME/srcpkg2git/srcpkg-dl.sh' --auto\"" >> xdg/srcpkg2git-gen.desktop
# optional cosmetic user patch (sed required)
ifneq ($(shell command -v sed 2>/dev/null),)
	@sed -i '4s/$/ (user)/' xdg/srcpkg2git-gen.desktop
endif
	@echo "generated XDG desktop entry: $(PWD)/xdg/srcpkg2git-gen.desktop"
	@install -CDvm644 xdg/srcpkg2git-gen.desktop "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
endif
ifneq ($(wildcard config/git-remote.conf.template),)
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_home_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_home_dir)/git-remote.conf"
	@#install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@-cp -an config/git-remote.conf.template "$(DESTDIR)$(user_config_dir)/git-remote.conf"
	@install -CDvm644 config/git-remote.conf.template "$(DESTDIR)$(user_home_dir)/git-remote.conf.template"
endif
ifneq ($(wildcard config/srcpkg-dl.conf.template),)
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_home_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_home_dir)/srcpkg-dl.conf"
	@#install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@-cp -an config/srcpkg-dl.conf.template "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@install -CDvm644 config/srcpkg-dl.conf.template "$(DESTDIR)$(user_home_dir)/srcpkg-dl.conf.template"
endif
ifneq ($(wildcard systemd/user-home.service),)
ifneq ($(wildcard systemd/srcpkg2git.timer),)
	@#echo "installing systemd service (user): $(DESTDIR)$(systemd_user_user_dir)"
	@#install -CDvm644 systemd/user-home.service "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.service"
	@#install -CDvm644 systemd/srcpkg2git.timer "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.timer"
	@#echo "systemd service (user) home install complete: $(DESTDIR)$(systemd_user_user_dir)"
	@make install-systemd-user-home-common
endif
endif
# icon
ifneq ($(wildcard images/srcpkg2git-logo.png),)
	@install -CDvm644 images/srcpkg2git-logo.png "$(DESTDIR)$(user_icon_dir)/srcpkg2git.png"
endif
	@echo "srcpkg2git (user) home update complete: $(DESTDIR)$(user_home_dir)"

#install-systemd: install-systemd-system-local-bin
install-systemd: install-systemd-user-local-bin

#install-systemd-system: install-systemd
install-systemd-system: install-systemd-system-local-bin

# system package (e.g., PKGBUILD)
install-systemd-system-bin: install-system systemd/system-bin.service systemd/srcpkg2git.timer
	@echo "installing systemd service (system): $(DESTDIR)$(systemd_global_dir)"
	@echo "root required to install"
	@echo "systemd-system-bin install target intended for making system package:"
	@echo "1. conflicts with / overwrites system package manager"
	@echo "2. ignored (not removed/uninstalled) by uninstall target"
	@install -CDvm644 systemd/system-bin.service "$(DESTDIR)$(systemd_global_dir)/srcpkg2git.service"
	@install -CDvm644 systemd/srcpkg2git.timer "$(DESTDIR)$(systemd_global_dir)/srcpkg2git.timer"
	@echo "systemd service (system) install complete: $(DESTDIR)$(systemd_global_dir)"

install-systemd-system-local-bin: install-system systemd/system-local-bin.service systemd/srcpkg2git.timer
	@echo "installing systemd service (system): $(DESTDIR)$(systemd_global_dir)"
	@echo "root required to install"
	@install -CDvm644 systemd/system-local-bin.service "$(DESTDIR)$(systemd_global_dir)/srcpkg2git.service"
	@install -CDvm644 systemd/srcpkg2git.timer "$(DESTDIR)$(systemd_global_dir)/srcpkg2git.timer"
	@echo "systemd service (system) install complete: $(DESTDIR)$(systemd_global_dir)"

# system package (e.g., PKGBUILD)
install-systemd-system-package: install-system systemd/system-bin.service systemd/srcpkg2git.timer
	@echo "installing systemd service (system): $(DESTDIR)$(systemd_global_dir_2)"
	@echo "root required to install"
	@echo "systemd-system-package install target intended for making system package:"
	@echo "1. conflicts with / overwrites system package manager"
	@echo "2. ignored (not removed/uninstalled) by uninstall target"
	@install -CDvm644 systemd/system-bin.service "$(DESTDIR)$(systemd_global_dir_2)/srcpkg2git.service"
	@install -CDvm644 systemd/srcpkg2git.timer "$(DESTDIR)$(systemd_global_dir_2)/srcpkg2git.timer"
	@echo "systemd service (system) install complete: $(DESTDIR)$(systemd_global_dir_2)"

#install-systemd-user: install-systemd
install-systemd-user: install-systemd-user-local-bin

install-systemd-user-local-bin: install-user-local-bin systemd/user-local-bin.service systemd/srcpkg2git.timer
	@echo "installing systemd service (user): $(DESTDIR)$(systemd_user_user_dir)"
	@install -CDvm644 systemd/user-local-bin.service "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.service"
	@install -CDvm644 systemd/srcpkg2git.timer "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.timer"
	@echo "systemd service (user) install complete: $(DESTDIR)$(systemd_user_user_dir)"

install-systemd-user-bin: install-user-bin systemd/user-bin.service systemd/srcpkg2git.timer
	@echo "installing systemd service (user): $(DESTDIR)$(systemd_user_user_dir)"
	@install -CDvm644 systemd/user-bin.service "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.service"
	@install -CDvm644 systemd/srcpkg2git.timer "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.timer"
	@echo "systemd service (user) install complete: $(DESTDIR)$(systemd_user_user_dir)"

install-systemd-user-home-common: systemd/user-home.service systemd/srcpkg2git.timer
	@echo "installing systemd service (user): $(DESTDIR)$(systemd_user_user_dir)"
	@install -CDvm644 systemd/user-home.service "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.service"
	@install -CDvm644 systemd/srcpkg2git.timer "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.timer"
	@echo "systemd service (user) home install complete: $(DESTDIR)$(systemd_user_user_dir)"

install-systemd-user-home: install-user-home install-systemd-user-home-common

install-systemd-user-home-git: install-user-home-git install-systemd-user-home-common

uninstall:
	@echo "uninstalling srcpkg2git ..."
	@-rm -fv "$(DESTDIR)$(system_local_bin_dir)/git-commit" "$(DESTDIR)$(system_local_bin_dir)/git-remote" "$(DESTDIR)$(system_local_bin_dir)/srcpkg2git" \
	  "$(DESTDIR)$(system_local_bin_dir)/srcpkg-dl" "$(DESTDIR)$(user_local_bin_dir)/git-commit" "$(DESTDIR)$(user_local_bin_dir)/git-remote" \
	  "$(DESTDIR)$(user_local_bin_dir)/srcpkg2git" "$(DESTDIR)$(user_local_bin_dir)/srcpkg-dl" "$(DESTDIR)$(user_bin_dir)/git-commit" \
	  "$(DESTDIR)$(user_bin_dir)/git-remote" "$(DESTDIR)$(user_bin_dir)/srcpkg2git" "$(DESTDIR)$(user_bin_dir)/srcpkg-dl"
	@-rm -fv "$(DESTDIR)$(system_local_bin_dir)/git-credential-bashelper" "$(DESTDIR)$(system_local_bin_dir)/git-credential-shelper" \
	  "$(DESTDIR)$(user_local_bin_dir)/git-credential-bashelper" "$(DESTDIR)$(user_local_bin_dir)/git-credential-shelper" \
	  "$(DESTDIR)$(user_bin_dir)/git-credential-bashelper" "$(DESTDIR)$(user_bin_dir)/git-credential-shelper"
ifneq ($(wildcard $(user_home_dir)),)
ifneq ($(PWD),$(user_home_dir))
# remove (user) home install
	@# remove (user) home install
	@-#rm -fr "$(DESTDIR)$(user_home_dir)" "$(DESTDIR)$(system_license_dir)" "$(DESTDIR)$(user_license_dir)"
	@-#rm -fr "$(DESTDIR)$(user_home_dir)"
# silently remove .git/ and verbose remove (user) home install
	@# silently remove .git/ and verbose remove (user) home install
	@-rm -fr "$(DESTDIR)$(user_home_dir)/.git/" &>/dev/null
	@-rm -frv "$(DESTDIR)$(user_home_dir)"
else
	@echo "skipping (user) home uninstall: $(DESTDIR)$(user_home_dir)"
endif
endif
	@-rm -fr "$(DESTDIR)$(system_license_dir)" "$(DESTDIR)$(user_license_dir)"
	@-rm -fv "$(DESTDIR)$(xdg_system_dir)/srcpkg2git.desktop" "$(DESTDIR)$(xdg_user_dir)/srcpkg2git.desktop"
	@-rm -f "$(DESTDIR)$(system_icon_dir_1)/srcpkg2git.png" "$(DESTDIR)$(system_icon_dir_2)/srcpkg2git.png" "$(DESTDIR)$(system_icon_dir_3)/srcpkg2git.png" "$(DESTDIR)$(user_icon_dir)/srcpkg2git.png"
	@echo "srcpkg2git uninstall complete"
	@echo "uninstalling systemd service ..."
	@-rm -fv "$(DESTDIR)$(systemd_global_dir)/srcpkg2git.service" "$(DESTDIR)$(systemd_global_dir)/srcpkg2git.timer" \
	  "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.service" "$(DESTDIR)$(systemd_user_user_dir)/srcpkg2git.timer"
	@echo "systemd service uninstall complete"

uninstall-all: uninstall
	@echo "uninstalling srcpkg2git configuration ..."
	@-rm -fv "$(DESTDIR)$(user_config_dir)/git-remote.conf" "$(DESTDIR)$(user_config_dir)/srcpkg-dl.conf"
	@echo "srcpkg2git configuration uninstall complete"
