#https://github.com/c9/templates/blob/master/ws-ruby/Dockerfile
#FROM cloud9/ws-ruby

FROM cloud9/workspace

USER ubuntu

RUN bash -l -c "rvm install ruby-2.7.2 && rvm use 2.7.2 --create && rvm --default use 2.7.2"
RUN bash -l -c "NOKOGIRI_USE_SYSTEM_LIBRARIES=1 gem install rails -v 5.2.4.4"

USER root
RUN rm -rf /home/ubuntu/workspace
ADD ./files/workspace /home/ubuntu/workspace
RUN chown -R ubuntu:ubuntu /home/ubuntu

USER ubuntu
RUN bash -l -c "rails new /home/ubuntu/workspace"

USER root

ADD ./files/check-environment /.check-environment/ruby

# IDE

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true


# Define environment variables
ENV USER="ubuntu"
ENV HOME="/home/ubuntu"

USER $USER
WORKDIR $HOME
USER root
RUN usermod -aG sudo $USER

RUN rm /etc/apt/sources.list.d/mongodb.list
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && apt-get install nodejs -y

USER $USER

# Download Cloud9 Core
RUN sudo git clone https://github.com/c9/core.git /var/c9sdk \
    && sudo chown -R $USER: /var/c9sdk

SHELL ["/bin/bash", "-c"]

# Install Cloud9 Core
RUN source $HOME/.profile \
    && cd /var/c9sdk \
    && scripts/install-sdk.sh

EXPOSE 5050 8080
#ENTRYPOINT ["node", "/var/c9sdk/server.js", \
#            "-w", "/home/ubuntu/workspace", \
#            "--workspacetype=ruby", \
#            "--auth", ":", \
#            "--listen", "0.0.0.0", \
#            "--port", "5050"]

