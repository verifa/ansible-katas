FROM ubuntu:22.04

RUN  apt-get update \
      && apt-get install -y dbus systemd gnupg curl systemd-sysv python3 sudo bash ca-certificates iproute2 python3-apt python3-pip aptitude \
      && apt-get clean

RUN apt-get install openssh-client openssh-server curl rsync vim -y

RUN pip3 install --upgrade pip; \
    pip3 install --upgrade virtualenv; \
    pip3 install pywinrm[kerberos]; \
    pip3 install pywinrm; \
    pip3 install jmspath; \
    pip3 install requests; \
    python3 -m pip install ansible;

RUN pip3 install molecule

# If image does have systemd set the default to be multi-user else leave it as is.
RUN if [ $(command -v systemctl) ]; then \
      systemctl set-default multi-user.target; \
    fi

RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa

RUN curl -sSL https://get.docker.com/ | sh

RUN ansible-galaxy collection install community.docker
RUN python3 -m pip install --user "molecule-plugins[docker]"
RUN apt-get install nano; \
    echo export EDITOR=nano >> ~/.bashrc

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT service ssh start && sleep infinity
