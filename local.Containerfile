FROM alpine:latest
ARG workdir=/tmp/srcpkg2git
WORKDIR $workdir
ENV SRCPKG_AUTO=1
RUN apk update

# dependencies
# srcpkg-dl, srcpkg2git, git-remote, git-credential-bashelper + git-credential-shelper, git-commit (all)
RUN apk add bash
# srcpkg-dl
RUN apk add curl grep libxml2-dev
# srcpkg2git
RUN apk add git tar
# git-remote, git-credential-bashelper + git-credential-shelper, git-commit (git-*)
#RUN apk add git

# optional dependencies
# srcpkg-dl, srcpkg2git, git-remote + git-commit
#RUN apk add coreutils openssl util-linux vim
RUN apk add coreutils
# srcpkg2git
RUN apk add findutils

# local programs
COPY --chmod=755 srcpkg-dl.sh /usr/bin/srcpkg-dl
COPY --chmod=755 srcpkg2git.sh /usr/bin/srcpkg2git
COPY --chmod=755 git-commit.sh /usr/bin/git-commit
COPY --chmod=755 git-remote.sh /usr/bin/git-remote
COPY --chmod=755 git-credential-bashelper.sh /usr/bin/git-credential-bashelper
#COPY --chmod=755 git-credential-shelper.sh /usr/bin/git-credential-shelper
# local configs
COPY --chmod=644 srcpkg-dl.conf git-remote.conf /etc/

# copy/configure password file (pwdfile/passwdfile) - git-remote.conf
#ARG pwdfile=pwdfile
#ARG pwdfile=passwdfile
#RUN apk add sed
#COPY --chmod=644 $pwdfile .
#RUN sed -i '$d' /etc/git-remote.conf
#RUN echo "[[ -z \$git_remote_password_file ]] && git_remote_password_file=\"$workdir/${pwdfile##*/}\"" >> /etc/git-remote.conf

#CMD ["srcpkg-dl"]
CMD ["srcpkg-dl", "--auto"]
