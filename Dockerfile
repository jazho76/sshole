FROM alpine:3.24

# Install vulnerable version
RUN apk add --no-cache build-base linux-headers openssl-dev zlib-dev
WORKDIR /tmp
RUN wget -qO- https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.3p1.tar.gz | tar xz \
    && cd openssh-10.3p1 \
    && ./configure --prefix=/usr --sysconfdir=/etc/ssh --without-pam \
    && make -j$(nproc) \
    && make install

# Setup SSH server and users
RUN ssh-keygen -A \
    && adduser -D user \
    && echo 'user:test' | chpasswd \
    && adduser -D other \
    && echo 'other:*' | chpasswd -e

CMD ["/usr/sbin/sshd", "-D", "-e"]
