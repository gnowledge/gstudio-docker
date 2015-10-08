# set the base image to Ubuntu 14.04
FROM ubuntu:14.04 

# file Author / Maintainer to GN 
MAINTAINER nagarjun@gnowledge.org

# file adding auser "docker" 
# -m : home directory
# -s : shell (user's login shell)
RUN useradd -ms /bin/bash docker

RUN su docker

# Setting the path for the installation directory
ENV LOG_DIR_DOCKER="/root/DockerLogs"
ENV LOG_INSTALL_DOCKER="/root/DockerLogs/$(date +%Y%b%d-%I%M%S%p)-gsd-install.log"
RUN echo "PATH="$LOG_DIR_DOCKER
RUN ls /root
RUN mkdir -p $LOG_DIR_DOCKER
RUN ls /root
RUN touch ${LOG_INSTALL_DOCKER}
RUN ls $LOG_DIR_DOCKER
RUN echo "Logs driectory and file created"  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# update the repository sources list
RUN apt-get update  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install application related packages
RUN apt-get install -y build-essential git python python-setuptools python-dev rcs emacs24 libjpeg-dev memcached libevent-dev libfreetype6-dev zlib1g-dev nginx supervisor curl g++ make  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN easy_install pip  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install application related packages
RUN apt-get install -y openssh-client openssh-server 

# install uwsgi now because it takes a little while
RUN pip install uwsgi nodeenv  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install nginx
RUN apt-get install -y python-software-properties  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN apt-get install -y software-properties-common python-software-properties  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN add-apt-repository -y ppa:nginx/stable  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN apt-get install -y sqlite3  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# for ffmpeg
RUN add-apt-repository ppa:mc3man/trusty-media  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN apt-get update  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN apt-get install -y ffmpeg gstreamer0.10-ffmpeg  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# for bash (commands) auto completion
RUN apt-get install -y bash-completion  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# for editing SCSS/SAAS stylesheets (ruby and compass)
RUN apt-get update  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN apt-get install -y ruby ruby-dev  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN gem install compass  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}


# for nodejs
RUN add-apt-repository ppa:chris-lea/node.js  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN apt-get update  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN apt-get install -y  nodejs  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN npm install -g bower  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# creating user for bower
# RUN adduser --disabled-password --gecos '' buser
# RUN adduser buser sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# RUN chown buser: /root/.config/configstore/bower-github.yml

#bower install
#RUN cd /home/docker/code/gstudio/gnowsys-ndf/
#RUN bower install

# create code directory as it can't find dirctory while coping
RUN mkdir -p /home/docker/code/
RUN ls /home/
RUN ls /home/docker/
RUN ls /home/docker/code/
RUN echo "Code driectory and file created"  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# install our code
ADD . /home/docker/code/ 

# change the working directory to "/home/docker/code"
WORKDIR "/home/docker/code/" 

# checking the present working directory
RUN pwd  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# assuming wget package is not available hence installing the same first. Via wget download bower_components directory and place it to appropriate place.
RUN apt-get install -y wget  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN wget http://www.metastudio.org/static/bower_components.tar.bz2  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN tar xvjf bower_components.tar.bz2  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN mv -v /home/docker/code/bower_components /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/static/ndf/


# copying the '.emacs' file in /root/ 
RUN cp -v /home/docker/code/emacs /root/.emacs  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}


# copying wsgi file to appropriate location
RUN cp -v /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/wsgi.py /home/docker/code/gstudio/gnowsys-ndf/wsgi.py  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
# RUN chown -R docker /home/docker/


# ENV HOME /home/docker
# USER docker


# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf  
RUN rm /etc/nginx/sites-enabled/default  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}



# RUN pip install to install pip related required packages as per requirements.txt
RUN pip install -r /home/docker/code/gstudio/requirements.txt  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}



# mongodb installation

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                ca-certificates \
                numactl  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
#       && rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

# gpg: key 7F0CEB10: public key "Richard Kreuter <richard@10gen.com>" imported
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.1 multiverse" > /etc/apt/sources.list.d/mongodb-org.list  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

RUN set -x \
        && apt-get update \
        && apt-get install -y --force-yes\
                mongodb-org-unstable \
                mongodb-org-unstable-server \
                mongodb-org-unstable-shell \
                mongodb-org-unstable-mongos \
                mongodb-org-unstable-tools \
#       && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/lib/mongodb \
        && mv /etc/mongod.conf /etc/mongod.conf.orig  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}

RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
VOLUME /data/db  



# Exposing the ports 

# Port - Mongodb
RUN echo "EXPOSE 27017"  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
EXPOSE 27017

# Port - ssh
RUN echo "EXPOSE 22"  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
EXPOSE 22  

# Port - smtp
RUN echo "EXPOSE 25"  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
EXPOSE 25  

# Port - http
RUN echo "EXPOSE 80"  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
EXPOSE 80  

# Port - for developement user {Developer}
RUN echo "EXPOSE 8000"  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
EXPOSE 8000  


# change this line for your timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}



# nltk installation and building search base
RUN pip install -U pyyaml nltk  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
RUN /home/docker/code/nltk-initialization.py  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}



# RUN service mongod start
# edit the following file to change the default superuser password
# this also does syncdb and filldb
RUN mkdir /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/management/commands/schema_files  | sed -e "s/^/$(date -R) /" 2>&1 | tee -a ${LOG_INSTALL_DOCKER}
#RUN /home/docker/code/initialize.sh



#cmd ["supervisord", "-n"]
CMD /home/docker/code/initialize.sh  | sed -e "s/^/$(date -R) /"  2>&1 | tee -a ${LOG_INSTALL_DOCKER}
