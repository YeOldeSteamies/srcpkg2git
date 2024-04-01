# <div align="center">![srcpkg2git](images/srcpkg2git-logo.png)</div>

# table of contents

- [srcpkg2git: srcpkg-dl, srcpkg2git, git-remote, git-credential-bashelper + *git-credential-shelper*, git-commit (introduction)](#srcpkg2git-srcpkg-dl-srcpkg2git-git-remote-git-credential-bashelper--git-credential-shelper-git-commit)
- [srcpkg2git rebase](#srcpkg2git-rebase)
- [programs](#programs)
  - [libraries (lib/)](#libraries-lib---included-git-programs-optional-dependencies)
- [dependencies](#dependencies)
- [optional dependencies](#optional-dependencies)
- [program order of operations](#program-order-of-operations)
- [update](#update)
  - [git update](#git-update-git-required)
  - [make update](#make-update-make-required-git-optional)
- [Makefile usage](#makefile-usage)
  - [disable Makefile install target](#disable-makefile-install-target)
  - [Makefile update target](#makefile-update-target)
- [**system install**](#system-install-not-portable---root-required)
- [**system package install**](#system-package-install-not-portable---root-required)
- [**user install**](#user-install-semi-portable)
- [**(user) home install**](#user-home-install-semi-portable-and-optional-git-install)
- [**no install**](#no-install-portable-archivable-and-optional-git-install)
  - [**git install**](#git-install)
- [**pacman package (PKGBUILD) install**](#pacman-package-pkgbuild-install)
- [**image/container (Containerfile/Dockerfile)**](#imagecontainer-containerfiledockerfile)
  - [**build/run local (local.Containerfile) image/container**](#buildrun-local-localcontainerfile-imagecontainer)
  - [**build/run remote (remote.Containerfile/remote-tag.Containerfile) image/container**](#buildrun-remote-remotecontainerfileremote-tagcontainerfile-imagecontainer)
  - [**remove image/container**](#remove-imagecontainer)
- [XDG desktop entry](#xdg-desktop-entry)
- [configuration](#configuration)
- [auto/bot mode](#autobot-mode)
- [systemd service](#systemd-service)
- [cron (crontab)](#cron-crontab)
- [uninstall](#uninstall)
- [srcpkg-dl](#srcpkg-dl)
- [srcpkg2git](#srcpkg2git-1)
  - [manually deobfuscate source package (src.tar[.gz|.xz])](#manually-deobfuscate-source-package-srctargzxz)
- [git-remote](#git-remote)
- [git-credential-bashelper + *git-credential-shelper*](#git-credential-bashelper--git-credential-shelper)
- [git-commit](#git-commit)
- [license](#license)

# srcpkg2git: srcpkg-dl, srcpkg2git, git-remote, git-credential-bashelper + *git-credential-shelper*, git-commit

<div align="center">

**[this humble project (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git) (especially the following (elaborate) Markdown documentation) is dedicated to the memory of:**

🫶 **[Aaron Swartz](https://en.wikipedia.org/wiki/Aaron_Swartz)** 🫶

**and was proudly built on March 3, 2022 to liberate all packages/repositories/software (GPL or not) from Valve's (and Collabora's and Igalia's) [private GitLab repositories](https://gitlab.steamos.cloud/) ([holo](https://gitlab.steamos.cloud/holo) and [jupiter](https://gitlab.steamos.cloud/jupiter) repositories) to a [public mirror (@gitlab.com/evlaV)](https://gitlab.com/users/evlaV/projects) (<https://gitlab.com/evlaV>) since April 1, 2022**

</div>

[SteamOS 3.x / Steam Deck public mirror (@gitlab.com/evlaV)](https://gitlab.com/users/evlaV/projects) bot (powered by [renewable](https://en.wikipedia.org/wiki/Renewable_energy) solar ☀️) is composed of [this project (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git) and additional (private) software (not included)

> additional (private) software (not included) **maintains automation, timing, power management, cryptography, file/data management (generation/modification), git and miscellaneous functions; e.g., [SteamOS 3.x / Steam Deck public mirror (@gitlab.com/evlaV)](https://gitlab.com/users/evlaV/projects) ([holo-PKGBUILD](https://gitlab.com/evlaV/holo-PKGBUILD) and [jupiter-PKGBUILD](https://gitlab.com/evlaV/jupiter-PKGBUILD) repositories)** and (if ever published) is *"incompatible"* with the [license](LICENSE.GPL) of [this project (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git)

## srcpkg2git rebase

[this repository (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git) and its affiliated [tags](https://gitlab.com/evlaV/srcpkg2git/-/tags) may occasionally be rebased, which will (destructively) remove obsolete commit history and data, but may disrupt normal git fetch/pull (merge) operations; if you receive a branch diverged error message upon git fetch/pull (merge):

```sh
git fetch
git rebase
```

or alternatively:

```sh
git pull --rebase
```

**this will result in (local) commit history and data loss**; *commit history and data loss is composed/consisting completely of obsolete data which has since been depreciated or replaced by (a) newer/later revision(s)*

## programs

- [srcpkg-dl](srcpkg-dl.sh) - source package (src.tar[.gz|.xz]) downloader
- [srcpkg2git](srcpkg2git.sh) - source package (src.tar[.gz|.xz]) to git converter/deobfuscator

### libraries (lib/) - included (git) programs (optional dependencies)

- [git-remote](lib/git-remote.sh) - setup and push local git to git remote and optionally integrate **git-credential-bashelper**
  - [git-credential-bashelper](lib/git-credential-bashelper.sh) - git credential helper (bash) - enable git authentication automation via HTTP(S)
- *[git-credential-shelper](lib/git-credential-shelper.sh)* - git credential helper (sh) - enable git authentication automation via HTTP(S)
- [git-commit](lib/git-commit.sh) - [shorthand](https://en.wikipedia.org/wiki/Shorthand) [API](https://en.wikipedia.org/wiki/API) library for making local git commit (with specified timestamp)

## dependencies

[srcpkg-dl](srcpkg-dl.sh), [srcpkg2git](srcpkg2git.sh), [git-remote](lib/git-remote.sh), [git-credential-bashelper](lib/git-credential-bashelper.sh) + *[git-credential-shelper](lib/git-credential-shelper.sh)*, [git-commit](lib/git-commit.sh):

- [bash](https://www.gnu.org/software/bash/) - GNU **B**ourne-**A**gain **SH**ell

---

[srcpkg-dl](srcpkg-dl.sh) - source package (src.tar[.gz|.xz]) downloader:

- [curl](https://curl.se/download.html) - transfer a URL
- [grep](https://www.gnu.org/software/grep/) - print lines that match patterns
- [libxml2](https://gitlab.gnome.org/GNOME/libxml2/-/releases) - XML C parser and toolkit
  - [xmllint](https://gitlab.gnome.org/GNOME/libxml2/-/releases) - command line XML tool

---

[srcpkg2git](srcpkg2git.sh) - source package (src.tar[.gz|.xz]) to git converter/deobfuscator:

- [git](https://git-scm.com/downloads) - the stupid content tracker
- [tar](https://www.gnu.org/software/tar/) - an archiving utility

---

[git-remote](lib/git-remote.sh), [git-credential-bashelper](lib/git-credential-bashelper.sh) + *[git-credential-shelper](lib/git-credential-shelper.sh)*, [git-commit](lib/git-commit.sh):

- [git](https://git-scm.com/downloads) - the stupid content tracker

---

*[git-credential-shelper](lib/git-credential-shelper.sh)* - git credential helper (sh) - enable git authentication automation via HTTP(S):

- sh ([POSIX](https://en.wikipedia.org/wiki/POSIX)) - [Bourne shell (sh)](https://en.wikipedia.org/wiki/Bourne_shell) - e.g., [Almquist shell (ash)](https://en.wikipedia.org/wiki/Almquist_shell), [Debian Almquist shell (dash)](https://en.wikipedia.org/wiki/Almquist_shell#Dash), [BusyBox](https://en.wikipedia.org/wiki/BusyBox) ([Almquist shell (ash)](https://en.wikipedia.org/wiki/Almquist_shell) or [hush shell](https://en.wikipedia.org/wiki/BusyBox#Features)), [KornShell (ksh)](https://en.wikipedia.org/wiki/KornShell), [Z shell (zsh)](https://en.wikipedia.org/wiki/Z_shell)

   or:

- *[bash](https://www.gnu.org/software/bash/)* - GNU **B**ourne-**A**gain **SH**ell

## optional dependencies

[srcpkg-dl](srcpkg-dl.sh), [srcpkg2git](srcpkg2git.sh), [git-remote](lib/git-remote.sh) + [git-commit](lib/git-commit.sh):

- [coreutils](https://www.gnu.org/software/coreutils/) - GNU core utilities
  - [base64](https://www.gnu.org/software/coreutils/) - base64 encode/decode data and print to standard output
- [openssl](https://github.com/openssl/openssl/releases) - OpenSSL command line program
- [util-linux](https://github.com/util-linux/util-linux/tags) - random collection of Linux utilities
  - [rev](https://github.com/util-linux/util-linux/tags) - reverse lines characterwise
- [vim](https://github.com/vim/vim/tags) - **V**i **IM**proved, a programmer's text editor
  - [xxd](https://github.com/vim/vim/tags) - make a hex dump or do the reverse

---

[srcpkg-dl](srcpkg-dl.sh) - source package (src.tar[.gz|.xz]) downloader:

- [coreutils](https://www.gnu.org/software/coreutils/) - GNU core utilities
  - [date](https://www.gnu.org/software/coreutils/) - print or set the system date and time
  - [sleep](https://www.gnu.org/software/coreutils/) - delay for a specified amount of time
  - [wc](https://www.gnu.org/software/coreutils/) - print newline, word, and byte counts for each file
- [srcpkg2git](srcpkg2git.sh) - source package (src.tar[.gz|.xz]) to git converter/deobfuscator

---

[srcpkg2git](srcpkg2git.sh) - source package (src.tar[.gz|.xz]) to git converter/deobfuscator:

- [coreutils](https://www.gnu.org/software/coreutils/) - GNU core utilities
  - [realpath](https://www.gnu.org/software/coreutils/) - print the resolved path
  - [touch](https://www.gnu.org/software/coreutils/) - change file timestamps
- [findutils](https://www.gnu.org/software/findutils/) - GNU basic directory searching utilities to locate files
  - [find](https://www.gnu.org/software/findutils/) - search for files in a directory hierarchy
- [git-remote](lib/git-remote.sh) - setup and push local git to git remote and optionally integrate **git-credential-bashelper**

---

[git-remote](lib/git-remote.sh) - setup and push local git to git remote and optionally integrate **git-credential-bashelper**:

- [git-credential-bashelper](lib/git-credential-bashelper.sh) - git credential helper (bash)

---

[git-credential-bashelper](lib/git-credential-bashelper.sh) + *[git-credential-shelper](lib/git-credential-shelper.sh)* - git credential helper (bash/sh) - enable git authentication automation via HTTP(S):

- [coreutils](https://www.gnu.org/software/coreutils/) - GNU core utilities
  - [head](https://www.gnu.org/software/coreutils/) - output the first part of files

or:

- [coreutils](https://www.gnu.org/software/coreutils/) - GNU core utilities
  - [cat](https://www.gnu.org/software/coreutils/) - concatenate files and print on the standard output

## program order of operations

***download source package(s) -> unpack/convert/deobfuscate source package(s) -> setup and push local git to git remote***

**[srcpkg-dl](srcpkg-dl.sh) -> [[srcpkg2git](srcpkg2git.sh)] -> [[git-remote](lib/git-remote.sh)] -> [[git-credential-bashelper](lib/git-credential-bashelper.sh)]**

or:

***unpack/convert/deobfuscate source package(s) -> setup and push local git to git remote***

**[srcpkg2git](srcpkg2git.sh) -> [[git-remote](lib/git-remote.sh)] -> [[git-credential-bashelper](lib/git-credential-bashelper.sh)]**

## update

### git update (git required)

```sh
git pull
```

or alternatively/directly:

```sh
git fetch
git rebase
```

### make update (make required, git optional)

```sh
make
```

or alternatively/directly:

```sh
make update
```

`make` sure to (re)`install` after update (e.g., `make install` i.e., `make install-user-local-bin`)

## Makefile usage

`make help` will print the following usage:

```sh
make usage:
make [help|install|uninstall[-all]|update]

make -> make update

make install usage:
make install[-systemd][-system[-bin|-local-bin|-package]]
make install[-systemd][-user[-bin|-home|-home-git|-home-update|-local-bin]]

make install-system -> install-system-local-bin
make install[-user] -> install-user-local-bin

make install-systemd-system -> install-systemd-system-local-bin
make install-systemd[-user] -> install-systemd-user-local-bin

make install-systemd-user-home-common
make install-user-home-update
```

### disable Makefile install target

disable `Makefile` install target(s) by `touch`ing the corresponding/respective file (targets: **help**, **uninstall**, ~~**uninstall-all**~~, and ~~**update**~~ are exempt i.e., **cannot be disabled**)

for example, disable target **install-system-bin**:

```sh
touch install-system-bin
```

make will no longer build or install **install-system-bin** target and will only print `make: 'install-system-bin' is up to date.` when running `make install-system-bin`

re-enable a disabled target (i.e., reverse `touch` process) by removing the corresponding/respective `touch`ed file:

```sh
rm install-system-bin
```

see: [phony targets](https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html) for more information on how/why this works

### Makefile update target

`make` or `make update` will update pre-installed **no install**, **user-home**, and (with optional `git` dependency) **user-home-git** install targets or automatically download (`git clone`) [this entire project (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git) (**no install**) in current working directory with nothing more than a (ubiquitous) [network connection](https://en.wikipedia.org/wiki/Computer_network), `git`, `make`, (included) [Makefile](Makefile) (`./Makefile`), and the `make` or `make update` command:

```sh
cd /some/path
# /some/path$
curl -O https://gitlab.com/evlaV/srcpkg2git/-/raw/master/Makefile
make
# installed to: /some/path/srcpkg2git (no install)
```

or:

```sh
make
```

or alternatively/directly:

```sh
make update
```

- creative **user-home-git** install (hack) with `Makefile` and `make` or `make update` command:

   ```sh
   cp ./Makefile ~
   cd ~
   # ~$
   make
   # installed to: ~/srcpkg2git (user-home-git install)
   ```

- i.e.:

   ```sh
   cp ./Makefile "$HOME"
   cd "$HOME"
   # ~$
   make
   # installed to: $HOME/srcpkg2git (user-home-git install)
   ```

- or install in any directory/path (other than `~` i.e., `$HOME`) for a fully portable **no install** in current working directory (`$PWD/srcpkg2git`):

   ```sh
   cp ./Makefile /some/path
   cd /some/path
   # /some/path$
   make
   # installed to: /some/path/srcpkg2git (no install)
   ```

   see: **[no install](#no-install-portable-archivable-and-optional-git-install)** for **no install** configuration setup

## system install (not portable) - root required

system install paths:

- **srcpkg2git**: `/usr/local/bin`
- **configuration**: `~/.config` i.e., `$HOME/.config`
- **systemd service**: `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`
- **XDG desktop entry**: `~/.local/share/applications` i.e., `$HOME/.local/share/applications`

install **srcpkg2git** to `/usr/local/bin` **(root required)**:

```sh
make install-system
```

or alternatively/directly:

```sh
make install-system-local-bin
```

install **srcpkg2git** to `/usr/local/bin` and **systemd service** to `/etc/systemd/user` **(root required)**:

```sh
make install-systemd-system
```

or alternatively/directly:

```sh
make install-systemd-system-local-bin
```

---

> ⚠️ **system-bin** and **systemd-system-bin** install targets are designed/intended for (and conflict with / overwrite) system package manager / making system package (not install) ⚠️

1. conflicts with / overwrites system package manager
2. ignored (not removed/uninstalled) by uninstall target

install **srcpkg2git** to `/usr/bin` **(root required)**:

```sh
# intended for making system package (not install)
make install-system-bin
```

install **srcpkg2git** to `/usr/bin` and **systemd service** to `/etc/systemd/user` **(root required)**:

```sh
# intended for making system package (not install)
make install-systemd-system-bin
```

## system package install (not portable) - root required

> ⚠️ **system-package** and **systemd-system-package** install targets are designed/intended for (and conflicts with / overwrites) system package manager / making system package (not install) ⚠️

1. conflicts with / overwrites system package manager
2. ignored (not removed/uninstalled) by uninstall target

system package install paths:

- **srcpkg2git**: `/usr/bin`
- **configuration**: `/etc`
- **systemd service**: `/usr/lib/systemd/user`
- **XDG desktop entry**: `/usr/share/applications`

install **srcpkg2git** to `/usr/bin` **(root required)**:

```sh
# intended for making system package (not install)
make install-system-package
```

install **srcpkg2git** to `/usr/bin` and **systemd service** to `/usr/lib/systemd/user` **(root required)**:

```sh
# intended for making system package (not install)
make install-systemd-system-package
```

## user install (semi-portable)

user install paths:

- **srcpkg2git**: `~/.local/bin` i.e., `$HOME/.local/bin` or `~/bin` i.e., `$HOME/bin`
- **configuration**: `~/.config` i.e., `$HOME/.config`
- **systemd service**: `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`
- **XDG desktop entry**: `~/.local/share/applications` i.e., `$HOME/.local/share/applications`

install **srcpkg2git** to `~/.local/bin` i.e., `$HOME/.local/bin`:

```sh
make install
```

or alternatively/directly:

```sh
make install-user
```

or alternatively/more directly:

```sh
make install-user-local-bin
```

install **srcpkg2git** to `~/.local/bin` i.e., `$HOME/.local/bin` and **systemd service** to `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`:

```sh
make install-systemd
```

or alternatively/directly:

```sh
make install-systemd-user
```

or alternatively/more directly:

```sh
make install-systemd-user-local-bin
```

---

install **srcpkg2git** to `~/bin` i.e., `$HOME/bin`:

```sh
make install-user-bin
```

install **srcpkg2git** to `~/bin` i.e., `$HOME/bin` and **systemd service** to `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`:

```sh
make install-systemd-user-bin
```

## (user) home install (semi-portable and optional git install)

**home install** is a user focused install which intentionally does not preserve uncommitted modifications - see the following notice

> ⚠️ destructive install/update PATH: use of this install PATH (`$HOME/srcpkg2git`) for (git) modification/development/contribution/merging (uncommitted changes) is not recommended ⚠️

**home install** has an optional alternative git install target (**user-home-git**); to easily/quickly update **srcpkg2git**, simply update [this repository (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git) (e.g., `git fetch/pull` or `make`) located at `~/srcpkg2git` i.e., `$HOME/srcpkg2git` (see: **[git install](#git-install)**)

(user) home install paths:

- **srcpkg2git**: `~/srcpkg2git` i.e., `$HOME/srcpkg2git`
- **configuration**: `~/srcpkg2git` i.e., `$HOME/srcpkg2git`
- **systemd service**: `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`
- **XDG desktop entry**: `~/.local/share/applications` i.e., `$HOME/.local/share/applications`

install **srcpkg2git** to `~/srcpkg2git` i.e., `$HOME/srcpkg2git`:

```sh
make install-user-home
```

or alternatively [git install](#git-install) **srcpkg2git** ((locally) git clone [this repository (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git)) to `~/srcpkg2git` i.e., `$HOME/srcpkg2git`:

```sh
make install-user-home-git
```

install **srcpkg2git** to `~/srcpkg2git` i.e., `$HOME/srcpkg2git` and **systemd service** to `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`:

```sh
make install-systemd-user-home
```

or alternatively [git install](#git-install) **srcpkg2git** ((locally) git clone [this repository (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git)) to `~/srcpkg2git` i.e., `$HOME/srcpkg2git` and install **systemd service** to `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`:

```sh
make install-systemd-user-home-git
```

---

when [systemd/user-home.service](systemd/user-home.service) and/or [XDG desktop entry](xdg/user-home.desktop) is **updated/modified** (re)run:

```sh
make
```

or alternatively/directly:

```sh
make update
```

or alternatively/more directly:

```sh
make install-user-home-update
```

or:

```sh
make install-systemd-user-home
```

or:

```sh
make install-systemd-user-home-git
```

---

when [systemd/user-home.service](systemd/user-home.service) is **updated/modified** (re)run:

```sh
make install-systemd-user-home-common
```

or:

```sh
make install-systemd-user-home
```

or:

```sh
make install-systemd-user-home-git
```

---

when [XDG desktop entry](xdg/user-home.desktop) is **updated/modified** (re)run:

```sh
make install-user-home
```

or:

```sh
make install-user-home-git
```

## no install (portable (archivable) and optional git install)

simply `git clone` or copy/extract/unpack [this repository (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git) ([zip](https://gitlab.com/evlaV/srcpkg2git/-/archive/master/srcpkg2git-master.zip), [tar.gz](https://gitlab.com/evlaV/srcpkg2git/-/archive/master/srcpkg2git-master.tar.gz), [tar.bz2](https://gitlab.com/evlaV/srcpkg2git/-/archive/master/srcpkg2git-master.tar.bz2), [tar](https://gitlab.com/evlaV/srcpkg2git/-/archive/master/srcpkg2git-master.tar)) somewhere/anywhere for a fully portable **no install**

or download/install in any directory/path (other than `~` i.e., `$HOME`) for a fully portable **no install** in current working directory (`$PWD/srcpkg2git`) with nothing more than a (ubiquitous) [network connection](https://en.wikipedia.org/wiki/Computer_network), `git`, `make`, (included) [Makefile](Makefile) (`./Makefile`), and the `make` or `make update` command:

```sh
cd /some/path
# /some/path$
curl -O https://gitlab.com/evlaV/srcpkg2git/-/raw/master/Makefile
make
# installed to: /some/path/srcpkg2git (no install)
```

or:

```sh
cp ./Makefile /some/path
cd /some/path
# /some/path$
make
# installed to: /some/path/srcpkg2git (no install)
```

**no install** is portable and has **[Arch Linux](https://archlinux.org/about/) / [Gentoo](https://www.gentoo.org/get-started/philosophy/)** philosophies e.g., a completely manual setup and configuration - it's up to the user to manually setup and (when necessary) update configuration

setup **[srcpkg2git configuration](#configuration)** (in configuration load order) for **no install**:

```sh
cp ./config/srcpkg-dl.conf.template ./srcpkg-dl.conf
cp ./config/git-remote.conf.template ./git-remote.conf
```

or alternatively (and more/less portable):

```sh
cp ./config/srcpkg-dl.conf.template ~/.config/srcpkg-dl.conf
cp ./config/git-remote.conf.template ~/.config/git-remote.conf
```

i.e.:

```sh
cp ./config/srcpkg-dl.conf.template "$HOME/.config/srcpkg-dl.conf"
cp ./config/git-remote.conf.template "$HOME/.config/git-remote.conf"
```

`srcpkg-dl.conf` and/or `git-remote.conf` may be configured via an editor of your choosing

### git install

(git) update **srcpkg2git** **(git install)** as easily/quickly as:

```sh
cd ~/srcpkg2git
git pull
```

i.e.:

```sh
cd "$HOME/srcpkg2git"
git pull
```

or alternatively:

```sh
git -C ~/srcpkg2git pull
```

i.e.:

```sh
git -C "$HOME/srcpkg2git" pull
```

or alternatively/directly:

```sh
make update
```

or alternatively:

```sh
make
```

## pacman package (PKGBUILD) install

pacman package (PKGBUILD) install paths:

- **srcpkg2git**: `/usr/bin`
- **configuration**: `/etc`
- **systemd service**: `/usr/lib/systemd/user`
- **XDG desktop entry**: `/usr/share/applications`

static (milestone) release (tag):

- [srcpkg2git](pacman-pkgbuild/srcpkg2git/PKGBUILD) - remote (git tag) pacman package
- [srcpkg2git-tar](pacman-pkgbuild/srcpkg2git-tar/PKGBUILD) - remote (git tag tar) pacman package

dynamic/rolling latest (milestone) release (tag):

- [srcpkg2git-git-tag](pacman-pkgbuild/srcpkg2git-git-tag/PKGBUILD) - remote (git tag) pacman package

dynamic/rolling latest ([dogfooding](https://en.wikipedia.org/wiki/Eating_your_own_dog_food)/developer) commit (branch):

- [srcpkg2git-git](pacman-pkgbuild/srcpkg2git-git/PKGBUILD) - remote (git branch) pacman package
- [srcpkg2git-local](pacman-pkgbuild/srcpkg2git-local/PKGBUILD) - local pacman package

all packages **conflict with and replace each other** i.e., are comparably identical; install (your choice of) one (1) package per (pacman) system

---

change directory to respective pacman package(s) (PKGBUILD) e.g., `cd ./pacman-pkgbuild/srcpkg2git`

make respective pacman package (PKGBUILD):

```sh
makepkg
```

install (potentially) missing dependencies (with pacman) then make respective pacman package (PKGBUILD):

```sh
makepkg -s
```

install (potentially) missing dependencies (with pacman) then make and install respective pacman package (PKGBUILD):

```sh
makepkg -is
```

install (potentially) missing dependencies (with pacman) then clean, make, and install respective pacman package (PKGBUILD):

```sh
makepkg -Cis
```

run `makepkg -h` or see: [makepkg usage](https://wiki.archlinux.org/title/Makepkg#Usage) for detailed usage instructions.

## image/container (Containerfile/Dockerfile)

Containerfile/Dockerfile (`./local.Containerfile`) install paths:

- **srcpkg2git**: `/usr/bin`
- **configuration**: `/etc`

no-install.Containerfile/no-install.Dockerfile (`./no-install-local.Containerfile`) install paths:

- **srcpkg2git**: `/tmp/srcpkg2git`
- **configuration**: `/tmp/srcpkg2git`

---

- `./srcpkg-dl.conf` and `./git-remote.conf` required

   ```sh
   cp ./config/srcpkg-dl.conf.template ./srcpkg-dl.conf
   cp ./config/git-remote.conf.template ./git-remote.conf
   ```

   or remotely:

   ```sh
   curl -o srcpkg-dl.conf https://gitlab.com/evlaV/srcpkg2git/-/raw/master/config/srcpkg-dl.conf.template -o git-remote.conf https://gitlab.com/evlaV/srcpkg2git/-/raw/master/config/git-remote.conf.template
   ```

   - `./srcpkg-dl.conf` and `./git-remote.conf` may be configured via an editor of your choosing

   ```sh
   nano ./srcpkg-dl.conf ./git-remote.conf
   vim ./srcpkg-dl.conf ./git-remote.conf
   ```

---

image/container size: **~30MB**

> image/container size subject to change (+/-) based on the size (and architecture (e.g., [x86_64](https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.1-x86_64.tar.gz), [x86](https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86/alpine-minirootfs-3.19.1-x86.tar.gz), [aarch64](https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/aarch64/alpine-minirootfs-3.19.1-aarch64.tar.gz), or [armv7](https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/armv7/alpine-minirootfs-3.19.1-armv7.tar.gz))) of current/latest container distribution (rootfs) image ([Alpine Linux](https://www.alpinelinux.org/)) and [srcpkg2git](https://gitlab.com/evlaV/srcpkg2git) and all [dependencies](#dependencies) and some/all [optional dependencies](#optional-dependencies)

<details><summary>Alpine Linux release (4/2024) | v3.19.1</summary><p>

[Alpine Linux rootfs Containerfile/Dockerfile tree (docker-alpine) v3.19](https://github.com/alpinelinux/docker-alpine/tree/v3.19):

<details><summary>x86_64</summary><p>

Alpine Linux ([x86_64](https://en.wikipedia.org/wiki/X86-64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.19/x86_64/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.1-x86_64.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>x86</summary><p>

Alpine Linux ([x86](https://en.wikipedia.org/wiki/X86-64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.19/x86/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86/alpine-minirootfs-3.19.1-x86.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>aarch64</summary><p>

Alpine Linux ([aarch64](https://en.wikipedia.org/wiki/AArch64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.19/aarch64/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/aarch64/alpine-minirootfs-3.19.1-aarch64.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>armv7</summary><p>

Alpine Linux ([armv7](https://en.wikipedia.org/wiki/ARM_architecture_family#32-bit_architecture)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.19/armv7/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/armv7/alpine-minirootfs-3.19.1-armv7.tar.gz /
CMD ["/bin/sh"]
```

</details>

</details><p>

<details><summary>Alpine Linux release (4/2023) | v3.17.3</summary><p>

[Alpine Linux rootfs Containerfile/Dockerfile tree (docker-alpine) v3.17](https://github.com/alpinelinux/docker-alpine/tree/v3.17):

<details><summary>x86_64</summary><p>

Alpine Linux ([x86_64](https://en.wikipedia.org/wiki/X86-64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.17/x86_64/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.3-x86_64.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>x86</summary><p>

Alpine Linux ([x86](https://en.wikipedia.org/wiki/X86-64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.17/x86/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86/alpine-minirootfs-3.17.3-x86.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>aarch64</summary><p>

Alpine Linux ([aarch64](https://en.wikipedia.org/wiki/AArch64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.17/aarch64/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/aarch64/alpine-minirootfs-3.17.3-aarch64.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>armv7</summary><p>

Alpine Linux ([armv7](https://en.wikipedia.org/wiki/ARM_architecture_family#32-bit_architecture)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.17/armv7/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/armv7/alpine-minirootfs-3.17.3-armv7.tar.gz /
CMD ["/bin/sh"]
```

</details>

</details><p>

<details><summary>Alpine Linux release (4/2022) | v3.15.3</summary><p>

[Alpine Linux rootfs Containerfile/Dockerfile tree (docker-alpine) v3.15](https://github.com/alpinelinux/docker-alpine/tree/v3.15):

<details><summary>x86_64</summary><p>

Alpine Linux ([x86_64](https://en.wikipedia.org/wiki/X86-64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.15/x86_64/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86_64/alpine-minirootfs-3.15.3-x86_64.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>x86</summary><p>

Alpine Linux ([x86](https://en.wikipedia.org/wiki/X86-64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.15/x86/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86/alpine-minirootfs-3.15.3-x86.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>aarch64</summary><p>

Alpine Linux ([aarch64](https://en.wikipedia.org/wiki/AArch64)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.15/aarch64/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/aarch64/alpine-minirootfs-3.15.3-aarch64.tar.gz /
CMD ["/bin/sh"]
```

</details>

<details><summary>armv7</summary><p>

Alpine Linux ([armv7](https://en.wikipedia.org/wiki/ARM_architecture_family#32-bit_architecture)) rootfs [Containerfile/Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/v3.15/armv7/Dockerfile):

```sh
FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/armv7/alpine-minirootfs-3.15.3-armv7.tar.gz /
CMD ["/bin/sh"]
```

</details>

</details><p>

### build/run local (local.Containerfile) image/container

[local.Containerfile](local.Containerfile) (`./local.Containerfile`)

> `docker` may alternatively be used instead of `podman`

1. build image (immutable)

   ```sh
   [sudo] podman build -t srcpkg2git .
   ```

   or alternatively/directly:

   ```sh
   [sudo] podman build -f ./local.Containerfile -t srcpkg2git
   ```

2. create container (mutable) from image (immutable)

   ```sh
   [sudo] podman container create --name srcpkg2git srcpkg2git
   ```

   or shorthand:

   ```sh
   [sudo] podman create --name srcpkg2git srcpkg2git
   ```

3. run image/container

   ```sh
   # automated run
   [sudo] podman run srcpkg2git
   # interactive run
   [sudo] podman run -it srcpkg2git
   # shell
   [sudo] podman run -it srcpkg2git /bin/bash
   ```

### build/run remote (remote.Containerfile/remote-tag.Containerfile) image/container

[remote.Containerfile](remote.Containerfile) (`./remote.Containerfile`)

> `docker` may alternatively be used instead of `podman`

1. build image (immutable)

   ```sh
   [sudo] podman build -f https://gitlab.com/evlaV/srcpkg2git/-/raw/master/remote.Containerfile -t srcpkg2git
   ```

   or locally:

   ```sh
   [sudo] podman build -f ./remote.Containerfile -t srcpkg2git
   ```

2. create container (mutable) from image (immutable)

   ```sh
   [sudo] podman container create --name srcpkg2git srcpkg2git
   ```

   or shorthand:

   ```sh
   [sudo] podman create --name srcpkg2git srcpkg2git
   ```

3. run image/container

   ```sh
   # automated run
   [sudo] podman run srcpkg2git
   # interactive run
   [sudo] podman run -it srcpkg2git
   # shell
   [sudo] podman run -it srcpkg2git /bin/bash
   ```

[remote-tag.Containerfile](remote-tag.Containerfile) (`./remote-tag.Containerfile`)

> `docker` may alternatively be used instead of `podman`

build image (immutable) using tag `0.1`:

```sh
[sudo] podman build --build-arg tag=0.1 -f https://gitlab.com/evlaV/srcpkg2git/-/raw/0.1/remote-tag.Containerfile -t srcpkg2git
# or alternatively
tag=0.1 [sudo] podman build --build-arg tag=$tag -f https://gitlab.com/evlaV/srcpkg2git/-/raw/$tag/remote-tag.Containerfile -t srcpkg2git
# or alternatively
export tag=0.1
[sudo] podman build --build-arg tag=$tag -f https://gitlab.com/evlaV/srcpkg2git/-/raw/$tag/remote-tag.Containerfile -t srcpkg2git
```

or locally build image (immutable) using tag `0.1`:

```sh
[sudo] podman build --build-arg tag=0.1 -f ./remote-tag.Containerfile -t srcpkg2git
```

> tag defaults to `0.1` if not provided (see the following examples)

build image (immutable) defaulting to tag `0.1`:

```sh
# tag defaults to 0.1 if not provided
[sudo] podman build -f https://gitlab.com/evlaV/srcpkg2git/-/raw/master/remote-tag.Containerfile -t srcpkg2git
```

or locally build image (immutable) defaulting to tag `0.1`:

```sh
# tag defaults to 0.1 if not provided
[sudo] podman build -f ./remote-tag.Containerfile -t srcpkg2git
```

### remove image/container

```sh
# remove image
[sudo] podman rmi -f srcpkg2git
# remove container
[sudo] podman rm -f srcpkg2git
```

see: [podman-build](https://docs.podman.io/en/latest/markdown/podman-build.1.html) and [podman-create](https://docs.podman.io/en/latest/markdown/podman-create.1.html), or [docker image build](https://docs.docker.com/reference/cli/docker/image/build/) and [docker container create](https://docs.docker.com/reference/cli/docker/container/create/) for detailed usage instructions

## XDG desktop entry

- **[system install](#system-install-not-portable---root-required)**: `/usr/local/share/applications`

---

- **[system package install](#system-package-install-not-portable---root-required)**: `/usr/share/applications`

---

- **[user install](#user-install-semi-portable)**: `~/.local/share/applications` i.e., `$HOME/.local/share/applications`

---

- **[pacman package install](#pacman-package-pkgbuild-install)**: `/usr/share/applications`

## configuration

- [srcpkg-dl](srcpkg-dl.sh)

> [config/srcpkg-dl.conf.template](config/srcpkg-dl.conf.template) (`./config/srcpkg-dl.conf.template`) is installed to / loaded from `~/.config/srcpkg-dl.conf` i.e., `$HOME/.config/srcpkg-dl.conf` and may be configured via an editor of your choosing
>
> configuration load order:
>
> 1. `./srcpkg-dl.conf` i.e., `$PWD/srcpkg-dl.conf` ([home install](#user-home-install-semi-portable-and-optional-git-install) / [no install](#no-install-portable-archivable-and-optional-git-install))
> 2. `~/.config/srcpkg-dl.conf` i.e., `$HOME/.config/srcpkg-dl.conf` ([system install](#system-install-not-portable---root-required) / [user install](#user-install-semi-portable))
> 3. `/etc/srcpkg-dl.conf` ([system package install](#system-package-install-not-portable---root-required) / [pacman package install](#pacman-package-pkgbuild-install))

---

- [git-remote](lib/git-remote.sh)

> [config/git-remote.conf.template](config/git-remote.conf.template) (`./config/git-remote.conf.template`) is installed to / loaded from `~/.config/git-remote.conf` i.e., `$HOME/.config/git-remote.conf` and may be configured via an editor of your choosing
>
> configuration load order:
>
> 1. `./git-remote.conf` i.e., `$PWD/git-remote.conf` ([home install](#user-home-install-semi-portable-and-optional-git-install) / [no install](#no-install-portable-archivable-and-optional-git-install))
> 2. `~/.config/git-remote.conf` i.e., `$HOME/.config/git-remote.conf` ([system install](#system-install-not-portable---root-required) / [user install](#user-install-semi-portable))
> 3. `/etc/git-remote.conf` ([system package install](#system-package-install-not-portable---root-required) / [pacman package install](#pacman-package-pkgbuild-install))

`srcpkg-dl.conf` and/or `git-remote.conf` may be configured via an editor of your choosing

see: **[no install](#no-install-portable-archivable-and-optional-git-install)** for **no install** configuration setup

## auto/bot mode

**enable/use auto/bot mode (no prompt)**; **include/use** `--auto` argument/option with [srcpkg-dl](srcpkg-dl.sh) and/or [srcpkg2git](srcpkg2git.sh):

```sh
# enable auto/bot mode (srcpkg-dl)
srcpkg-dl --auto [remote/local (HTML) URL/PATH ...] [option]
./srcpkg-dl.sh --auto [remote/local (HTML) URL/PATH ...] [option]
```

```sh
# enable auto/bot mode (srcpkg2git)
srcpkg2git --auto src.tar[.gz|.xz] [...]
./srcpkg2git.sh --auto src.tar[.gz|.xz] [...]
```

or alternatively set **SRCPKG_AUTO** variable and run [srcpkg-dl](srcpkg-dl.sh) and/or [srcpkg2git](srcpkg2git.sh):

```sh
# run srcpkg-dl (auto/bot mode enabled)
SRCPKG_AUTO=1 srcpkg-dl [remote/local (HTML) URL/PATH ...] [option]
SRCPKG_AUTO=1 ./srcpkg-dl.sh [remote/local (HTML) URL/PATH ...] [option]
```

```sh
# run srcpkg2git (auto/bot mode enabled)
SRCPKG_AUTO=1 srcpkg2git src.tar[.gz|.xz] [...]
SRCPKG_AUTO=1 ./srcpkg2git.sh src.tar[.gz|.xz] [...]
```

or alternatively `export` **SRCPKG_AUTO** variable and run [srcpkg-dl](srcpkg-dl.sh) and/or [srcpkg2git](srcpkg2git.sh) normally:

```sh
# enable auto/bot mode (srcpkg-dl)
export SRCPKG_AUTO=1
# run srcpkg-dl normally (auto/bot mode enabled)
srcpkg-dl [remote/local (HTML) URL/PATH ...] [option]
./srcpkg-dl.sh [remote/local (HTML) URL/PATH ...] [option]
```

```sh
# enable auto/bot mode (srcpkg2git)
export SRCPKG_AUTO=1
# run srcpkg2git normally (auto/bot mode enabled)
srcpkg2git src.tar[.gz|.xz] [...]
./srcpkg2git.sh src.tar[.gz|.xz] [...]
```

---

or use/run the respective (installed) [pregenerated](xdg/) [XDG desktop entry](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html)

or use/run the (installed) generated [XDG desktop entry](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html) (`./xdg/srcpkg2git-gen.desktop`) (automatically generated (fallback) by (included) [Makefile](Makefile) (`./Makefile`) or (included) [PKGBUILD](pacman-pkgbuild/) (`./pacman-pkgbuild/`) from (included) [xdg/srcpkg2git-gen.desktop.part](xdg/srcpkg2git-gen.desktop.part) (`./xdg/srcpkg2git-gen.desktop.part`) if respective [pregenerated](xdg/) [XDG desktop entry](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html) not found)

or manually generate [XDG desktop entry](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html) (`./xdg/srcpkg2git-gen.desktop`) **(replace the following `[/path/to/]srcpkg-dl[.sh]` with corresponding/respective srcpkg-dl full path)**:

```sh
cp -f ./xdg/srcpkg2git-gen.desktop.part ./xdg/srcpkg2git-gen.desktop
# replace '[/path/to/]srcpkg-dl[.sh]' with corresponding/respective srcpkg-dl full path
echo "Exec=[/path/to/]srcpkg-dl[.sh] --auto" >> xdg/srcpkg2git-gen.desktop
```

(optional) if user install, additionally append cosmetic patch **(sed required)**:

```sh
# optional cosmetic user patch (sed required)
sed -i '4s/$/ (user)/' xdg/srcpkg2git-gen.desktop
```

---

or install and use **[systemd service](#systemd-service)**

## systemd service

- **[system install](#system-install-not-portable---root-required)**: `/etc/systemd/user`

---

- **[system package install](#system-package-install-not-portable---root-required)**: `/usr/lib/systemd/user`

<!--
elevate privileges (e.g., `doas/sudo`) or run as root and **exclude/don't use** `--user` argument/option with `systemctl`

```sh
# elevate privileges (doas)
doas systemctl start srcpkg2git
# elevate privileges (sudo)
sudo systemctl start srcpkg2git
```

or run as root:

```sh
systemctl start srcpkg2git
```
-->

---

- **[user install](#user-install-semi-portable)**: `~/.local/share/systemd/user` i.e., `$HOME/.local/share/systemd/user`
- *alternative user install*: `~/.config/systemd/user` i.e., `$HOME/.config/systemd/user`

<!--
**include/use** `--user` argument/option and **don't elevate privileges** (e.g., `doas/sudo` or run as root) with `systemctl`

```sh
systemctl --user start srcpkg2git
```
-->

---

- **[pacman package install](#pacman-package-pkgbuild-install)**: `/usr/lib/systemd/user`

---

> removed/regressed former/prior (optional) requirement/instruction to elevate privileges (e.g., doas/sudo or run as root)
> regression was intentional; some regressed code (and documentation) was intentionally commented to denote/imply this

**all systemd install targets** (**system** and **user install**) (including **system package** and **pacman package install**) install/use **systemd [user units](https://wiki.archlinux.org/title/Systemd/User)**

**include/use** `--user` argument/option with `systemctl`

enable and start service (now):

```sh
systemctl --user enable --now srcpkg2git
```

enable service (start at next boot):

```sh
systemctl --user enable srcpkg2git
```

start service (now):

```sh
systemctl --user start srcpkg2git
```

stop service (now):

```sh
systemctl --user stop srcpkg2git
```

see: [systemd using units](https://wiki.archlinux.org/title/Systemd#Using_units) table for detailed usage instructions

## cron (crontab)

manually install (copy) respective `crontab` (included/located in `./cron/`) to `/etc/cron.d/`:

```sh
cp ./cron/srcpkg2git /etc/cron.d/
```

or:

```sh
# user-local-bin
cp ./cron/user-local-bin /etc/cron.d/srcpkg2git
```

or manually install (append last line of) respective `crontab` (included/located in `./cron/`) to `/var/spool/cron/username` **(sed required)**:

```sh
# root
sed '$!d' ./cron/srcpkg2git > /var/spool/cron/root
```

or:

```sh
# username (e.g., evlav)
sed '$!d' ./cron/srcpkg2git > /var/spool/cron/evlav
```

## uninstall

uninstall **system, user, and home installation(s)**, **systemd service(s)**, and **XDG desktop entry(ies)** **(root required for system uninstall)**:

```sh
make uninstall
```

**srcpkg2git configuration** will not be uninstalled during (default) uninstall

to additionally uninstall **srcpkg2git configuration**:

```sh
make uninstall-all
```

or manually uninstall **srcpkg2git configuration**:

```sh
rm ~/.config/srcpkg-dl.conf
rm ~/.config/git-remote.conf
```

i.e.:

```sh
rm "$HOME/.config/srcpkg-dl.conf"
rm "$HOME/.config/git-remote.conf"
```

## srcpkg-dl

automatically makes/uses (a self-contained) `SRCPKG2GIT/.DL` directory in current working directory `$PWD` (`$PWD/SRCPKG2GIT/.DL`) for source package downloading

```sh
usage:
  srcpkg-dl [remote/local (HTML) URL/PATH ...] [[--]jupiter[{-332|-333|-35|-36|-stable|-beta|-main|-staging|-rel|-aio|-all}]] [[--]holo[{-333|-35|-36|-stable|-beta|-main|-staging|-rel|-aio|-all}]] [[--]{aio|all}]

 e.g.:
  srcpkg-dl 'https://example.com/?C=M&O=D'
  srcpkg-dl '/path/to/file1.html?C=M&O=D' 'file:///path/to/file2.html?C=M&O=D'
  srcpkg-dl --jupiter-main --holo-main

 options:
  -h|--help
  ❔ show this help message and exit
  -v|--version
  ℹ️  show version information and exit

  --auto|--automate|--automatic|--bot
  🤖 enable auto/bot mode (no prompt)

  --fast-forward-update|--ff-update|
  --mask-update|--masquerade-update|--pseudo-update
  ⏩ fast forward / skip to latest package update sans/without downloading
  🥸 (AKA mask/masquerade/pseudo update)

  jupiter-332|--jupiter-332
  📦 jupiter-3.3.2
  jupiter-333|--jupiter-333
  📦 jupiter-3.3.3
  jupiter-35|--jupiter-35
  📦 jupiter-3.5
  jupiter-36|--jupiter-36
  📦 jupiter-3.6

  jupiter|--jupiter|jupiter-stable|--jupiter-stable
  📦 jupiter-stable
  jupiter-beta|--jupiter-beta
  📦 jupiter-beta
  jupiter-main|--jupiter-main
  📦 jupiter-main
  jupiter-staging|--jupiter-staging
  📦 jupiter-staging
  jupiter-rel|--jupiter-rel
  📦 jupiter-rel
  jupiter-aio|--jupiter-aio|jupiter-all|--jupiter-all
  📦 jupiter all-in-one (AIO) - all of the above (jupiter)

  holo-333|--holo-333
  📦 holo-3.3.3
  holo-35|--holo-35
  📦 holo-3.5
  holo-36|--holo-36
  📦 holo-3.6

  holo|--holo|holo-stable|--holo-stable
  📦 holo-stable
  holo-beta|--holo-beta
  📦 holo-beta
  holo-main|--holo-main
  📦 holo-main
  holo-staging|--holo-staging
  📦 holo-staging
  holo-rel|--holo-rel
  📦 holo-rel
  holo-aio|--holo-aio|holo-all|--holo-all
  📦 holo all-in-one (AIO) - all of the above (holo)

  aio|--aio|all|--all
  📦 jupiter/holo all-in-one (AIO) - all of the above (jupiter/holo)
```

## srcpkg2git

automatically makes/uses (a self-contained) `SRCPKG2GIT/[pkgname]` directory in current working directory `$PWD` (`$PWD/SRCPKG2GIT/[pkgname]`) for source package unpacking/conversion/deobfuscation

```sh
usage: srcpkg2git src.tar[.gz|.xz] [...]
 e.g.: srcpkg2git package1.src.tar[.gz|.xz] package2.src.tar[.gz|.xz]
```

### manually deobfuscate source package (src.tar[.gz|.xz])

| path | description |
| :--- | :--- |
| `$pkgname_dir_1`/ | main package directory |
| ┣━.SRCINFO | pacman package (AUR) metadata |
| ┣━PKGBUILD | pacman package build information |
| **┗━`$pkgname_dir_2`/** | **obfuscated package git** (directory name (`$pkgname_dir_2`) may be **identical to** or **differ from** (i.e., a derivative of) **main package directory** name (`$pkgname_dir_1`)) |

```sh
# (at your discretion) download and extract respective source package (src.tar[.gz|.xz]) to current working directory ($PWD) (e.g., zenity-light)
curl https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources/jupiter-main/zenity-light-3.32.0%2B55%2Bgd7bedff6-1.src.tar.gz | bsdtar -xvf-

# respective package directory name(s) (e.g., zenity-light and zenity)
pkgname_dir_1=zenity-light
pkgname_dir_2=zenity

# deobfuscate
cd "$pkgname_dir_1/$pkgname_dir_2"
mkdir -p ".git/"
mv * ".git/"
git init
git checkout -f
```

## git-remote

setup and push local git to git remote (`git_remote_url` configured in `git-remote.conf`) and optionally integrate **git-credential-bashelper** to store and use credentials (username/password) for HTTP(S) - enable git authentication automation via HTTP(S)

```sh
usage: git-remote git_remote_url [git_remote_name[.git]] [git_push_option ...]
 e.g.: git-remote https://gitlab.com/evlaV jupiter-hw-support -f
       git-remote https://gitlab.com/evlaV jupiter-hw-support.git -f

       git-remote git@gitlab.com:evlaV jupiter-hw-support -f
       git-remote git@gitlab.com:evlaV jupiter-hw-support.git -f
```

## git-credential-bashelper + *git-credential-shelper*

see: [gitcredentials](https://git-scm.com/docs/gitcredentials) for more information on how/why this works

## git-commit

(extra/unused) [shorthand](https://en.wikipedia.org/wiki/Shorthand) [API](https://en.wikipedia.org/wiki/API) library for making local git commit (with specified timestamp)

```sh
usage: git-commit git_commit_msg [git_commit_date] [git_commit_option ...]
 e.g.: git-commit "git commit message string" "April 7 13:14:15 PDT 2005" --amend --no-edit
```

## license

the contents of [this project (srcpkg2git)](https://gitlab.com/evlaV/srcpkg2git) are licensed under the [GNU General Public License Version 3 (GPLv3)](LICENSE.GPL) or the [Mozilla Public License Version 2.0 (MPL 2.0)](LICENSE.MPL) (see below)

---

**(March 25, 2023):** the [FSF](https://www.fsf.org/about/) ([rms](https://en.wikipedia.org/wiki/Richard_Stallman)) has demonstrated the following to me (in the case of Valve) regarding [defending their GPL](https://www.gnu.org/licenses/):

`"The FSF is short-handed in the legal area. Given how little it could hope to achieve, I tend to think that this would not be an efficient choice of priorities (though I'm not the one who decides nowadays). I don't think I could get a staff person to verify the origin of the copied code in less than months."`

therefore (for those *Valve would-be [entities](https://en.wikipedia.org/wiki/Entity)*), you're free to use the more *"practical/pragmatic"* (i.e., preferred) [Mozilla Public License Version 2.0 (MPL 2.0)](LICENSE.MPL) in lieu of the [GNU General Public License Version 3 (GPLv3)](LICENSE.GPL)
