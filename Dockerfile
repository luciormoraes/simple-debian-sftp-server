FROM debian:latest

RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:sftppassword' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN echo "Match User sftpuser" >> /etc/ssh/sshd_config
RUN echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config
RUN echo "    PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN echo "    ChrootDirectory /" >> /etc/ssh/sshd_config
RUN echo "    PermitTunnel no" >> /etc/ssh/sshd_config
RUN echo "    AllowAgentForwarding no" >> /etc/ssh/sshd_config
RUN echo "    AllowTcpForwarding no" >> /etc/ssh/sshd_config
RUN echo "    X11Forwarding no" >> /etc/ssh/sshd_config

RUN useradd -m -d /home/sftpuser -s /usr/sbin/nologin sftpuser
RUN mkdir /home/sftpuser/.ssh
COPY sftp_key.pub /home/sftpuser/.ssh/authorized_keys
RUN chown -R sftpuser:sftpuser /home/sftpuser

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
