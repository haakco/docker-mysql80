FROM mysql:8.0

ENV LANG="en_US.UTF-8" \
    LC_ALL="C.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TERM="xterm" \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="Africa/Johannesburg"

RUN apt-get update && \
    apt-get install -y \
      bzip2 \
      curl \
      git gnupg2 \
      htop \
      iotop \
      libdbi-perl \
      libdbd-mysql-perl \
      libterm-readkey-perl \
      libio-socket-ssl-perl \
      lsb-release \
      logrotate \
      pbzip2 pv procps \
      vim \
      wget \
      xz-utils \
      pixz \
    && \
    git clone https://github.com/major/MySQLTuner-perl.git /MySQLTuner-perl && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb \
    -O /percona-release.deb && \
  dpkg -i /percona-release.deb && \
  percona-release enable tools && \
  percona-release enable original && \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install  -y \
    percona-toolkit \
    qpress \
    percona-xtrabackup-24 \
    && \
  rm -rf /percona-release.deb && \
  apt-get -y autoremove && \
  apt-get -y clean && \
  /bin/rm -rf /var/lib/apt/lists/* && \
  /bin/rm -rf /tmp/*

RUN wget https://github.com/maxbube/mydumper/releases/download/v0.9.5/mydumper_0.9.5-2.xenial_amd64.deb -O /mydumper.xenial_amd64.deb && \
    dpkg -i /mydumper.xenial_amd64.deb && \
    rm /mydumper.xenial_amd64.deb && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ADD ./files/mysqlScripts /mysqlScripts

RUN chmod u+x \
      /MySQLTuner-perl/*.pl \
      /mysqlScripts/*.sh \
      /mysqlScripts/*.pl \
      && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql && \
    rm -rf /files

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
