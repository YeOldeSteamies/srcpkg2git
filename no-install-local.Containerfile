FROM alpine:latest
ARG workdir=/tmp/srcpkg2git
ENV workdir=$workdir
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
COPY --chmod=755 srcpkg-dl.sh srcpkg2git.sh git-commit.sh git-remote.sh git-credential-bashelper.sh .
#COPY --chmod=755 srcpkg-dl.sh srcpkg2git.sh git-commit.sh git-remote.sh git-credential-bashelper.sh git-credential-shelper.sh .
# local configs
COPY --chmod=644 srcpkg-dl.conf git-remote.conf .

# copy/configure password file (pwdfile/passwdfile) - git-remote.conf
#ARG pwdfile=pwdfile
#ARG pwdfile=passwdfile
#RUN apk add sed
#COPY --chmod=644 $pwdfile .
#RUN sed -i '$d' ./git-remote.conf
#RUN echo "[[ -z \$git_remote_password_file ]] && git_remote_password_file=\"$workdir/${pwdfile##*/}\"" >> ./git-remote.conf

#CMD ["./srcpkg-dl.sh"]
#CMD ["bash", "./srcpkg-dl.sh"]
#CMD ["bash", "srcpkg-dl.sh"]
#CMD ["bash", "/tmp/srcpkg2git/srcpkg-dl.sh"]
#CMD ["bash", "$workdir/srcpkg-dl.sh"]
#CMD ["./srcpkg-dl.sh", "--auto"]
#CMD ["bash", "./srcpkg-dl.sh", "--auto"]
CMD ["bash", "srcpkg-dl.sh", "--auto"]
#CMD ["bash", "/tmp/srcpkg2git/srcpkg-dl.sh", "--auto"]
#CMD ["bash", "$workdir/srcpkg-dl.sh", "--auto"]
