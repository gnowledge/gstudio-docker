# set the base image to Ubuntu 14.04
FROM ubuntu:14.04 

# file Author / Maintainer to GN 
MAINTAINER nagarjun@gnowledge.org, mrunal@gnowledge.org, satej@gnowledge.org

# file adding auser "docker" 
# -m : home directory
# -s : shell (user's login shell)
RUN useradd -ms /bin/bash docker

RUN su docker

# Setting the path for the installation directory
ENV export DATE_LOG=$(date+%Y%m%d-%H%M%S)
ENV LOG_DIR_DOCKER="/root/DockerLogs"  LOG_INSTALL_DOCKER="/root/DockerLogs/$DATE_LOG-gsd-install.log"
RUN echo "PATH="$LOG_DIR_DOCKER   \
   &&  mkdir -p $LOG_DIR_DOCKER   \
   &&  touch ${LOG_INSTALL_DOCKER}   \
   &&  ls ${LOG_INSTALL_DOCKER}   \
   &&  echo "Logs driectory and file created"  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}    

# update the repository sources list
RUN apt-get update  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install nginx
# add all the repositories (nginx, ffmpeg and ffmpeg2theora, nodejs{bower}, )
RUN apt-get install -y python-software-properties  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  apt-get install -y software-properties-common python-software-properties  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  add-apt-repository -y ppa:nginx/stable  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   && add-apt-repository ppa:mc3man/trusty-media  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   && add-apt-repository ppa:chris-lea/node.js  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}


# update the repository sources list
RUN apt-get update  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install packages related application and ( ssh, mail {for mailbox / mail relaying}, sqlite and postgresql, ffmpeg and ffmpeg2theora, bash {commands} auto completion and crontab, SCSS/SAAS stylesheets {ruby}, nodejs{bower}, wget)
RUN apt-get install -y build-essential git python python-pip python-setuptools python-dev rcs emacs24 libjpeg-dev memcached libevent-dev libfreetype6-dev zlib1g-dev nginx supervisor curl g++ make     openssh-client openssh-server     mailutils postfix     sqlite3   libpq-dev postgresql postgresql-contrib python-psycopg2     ffmpeg gstreamer0.10-ffmpeg ffmpeg2theora     bash-completion cron     ruby ruby-dev     nodejs     wget   | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN easy_install pip  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install uwsgi now because it takes a little while
RUN pip install uwsgi nodeenv  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# for editing SCSS/SAAS stylesheets {compass}
RUN gem install compass  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# for nodejs{bower}
RUN npm install -g bower  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}


# create code directory as it can't find dirctory while coping
RUN mkdir -p /home/docker/code/   \
   &&  mkdir -p /data/   \
   &&  echo "Code driectory and file created"  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install our code
ADD . /home/docker/code/ 

# change the working directory to "/home/docker/code"
WORKDIR "/home/docker/code/" 

#bower install
RUN cd /home/docker/code/gstudio/gnowsys-ndf/   \
   &&  bower install --allow-root  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# backup all scripts and confs
RUN mkdir /root/.backup_defaults   \
   &&  cp -av /home/docker/code/confs /root/.backup_defaults/   \
   &&  cp -av /home/docker/code/scripts /root/.backup_defaults/   \
   &&  cp -av /home/docker/code/Dockerfile /home/docker/code/AUTHORS /home/docker/code/README.md /root/.backup_defaults/   

# checking the present working directory and copying of configfiles : {copying the '.emacs' file in /root/ } , {copying the 'maintenance' files in /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/templates/ } , {copying wsgi file to appropriate location}, {copying postgresql conf file to appropriate location} , 
RUN pwd  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}    \
   &&  cp -v /home/docker/code/confs/emacs /root/.emacs  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}    \
   &&  cp -v /home/docker/code/maintenance/maintenance* /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/templates/  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}    \
   &&  cp -v /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/wsgi.py /home/docker/code/gstudio/gnowsys-ndf/wsgi.py  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}    \
   &&  mv -v /etc/postgresql/9.3/main/postgresql.conf /root/postgresql.conf.bkp  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}    \
   &&  cp -v /home/docker/code/confs/postgresql.conf /etc/postgresql/9.3/main/  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}    \
   &&  mv -v /var/lib/postgresql /data/  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER} \
   &&  cp -v /home/docker/code/confs/local_settings.py.default /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py

# setup all the configfiles (nginx, supervisord and postgresql)
RUN echo "daemon off;" >> /etc/nginx/nginx.conf   \
   &&  rm /etc/nginx/sites-enabled/default  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  mv -v /etc/nginx/nginx.conf /tmp/  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  ln -s /home/docker/code/confs/nginx.conf /etc/nginx/  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  ln -s /home/docker/code/confs/nginx-app.conf /etc/nginx/sites-enabled/  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  ln -s /home/docker/code/confs/supervisor-app.conf /etc/supervisor/conf.d/  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  ln -s /data/postgresql /var/lib/postgresql   | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# RUN pip install to install pip related required packages as per requirements.txt
RUN pip install -r /home/docker/code/gstudio/requirements.txt  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

RUN echo "Size of deb packages files : "  du -hs  /var/cache/apt/archives/   \
   &&  ls -ltr  /var/cache/apt/archives/   \
   &&  du -hs  /var/cache/apt/archives/*   \
   &&  rm -rf /var/cache/apt/archives/*.deb


# mongodb installation

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mongodb   \
   &&  useradd -r -g mongodb mongodb  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

RUN apt-get update \
   &&  apt-get install -y --no-install-recommends \
                ca-certificates \
                numactl  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
#       && rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# gpg: key 7F0CEB10: public key "Richard Kreuter <richard@10gen.com>" imported
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# Mrunal : 12012016 : Changed the source for mongodb from "http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.1 multiverse" to "http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/stable multiverse" 
# CyberOrg : Changed "stable" to "3.2" as stable is 404
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org.list  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# Mrunal : 12012016 : Get the stable packages instead of unstable eg.- "mongodb-org-unstable" to "mongodb-org" 
# Mrunal : 01022016 : Install specific version of mongodb : apt-get install  mongodb-org-unstable=3.1.5 mongodb-org-unstable-shell=3.1.5 mongodb-org-unstable-mongos=3.1.5 mongodb-org-unstable-tools=3.1.5
 
RUN set -x \
        && apt-get update \
        && apt-get install -y --force-yes\
                mongodb-org=3.2.1 \
                mongodb-org-server=3.2.1 \
                mongodb-org-shell=3.2.1 \
                mongodb-org-mongos=3.2.1 \
                mongodb-org-tools=3.2.1 \
#       && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/lib/mongodb \
        && mv /etc/mongod.conf /etc/mongod.conf.orig  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
VOLUME /data



# Exposing the ports - {ssh} , {smtp} , {https (with ssl)} , {http} , {for developement user (Developer)} , {smtpd command (to test mail machanism locally)} , {imap : gnowledge} , {smtp : gnowledge} , {mongodb}
RUN echo "EXPOSE  22  25  443  80  8000  1025  143  587"  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
EXPOSE  22  25  443  80  8000  1025  143  587  27017

# {change this line for your timezone} and {nltk installation and building search base} and {creation of schema_files directory}
RUN ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  pip install -U pyyaml nltk  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  /home/docker/code/scripts/nltk-initialization.py  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}   \
   &&  mkdir /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/management/commands/schema_files  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

CMD /home/docker/code/scripts/initialize.sh  | sed -e "s/^/$(date +%Y%m%d-%H%M%S) :  /"  2>&1 | tee -a ${LOG_INSTALL_DOCKER}
