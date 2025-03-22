FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 python3-pip && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]