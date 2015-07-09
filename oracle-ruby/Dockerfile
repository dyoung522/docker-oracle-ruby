# OracleLinux running Ruby

FROM oraclelinux:6.6

MAINTAINER Donovan Young <dyoung522@gmail.com>

LABEL Description="This is a base image including only OracleLinux and Ruby" \
      Version="0.1.0"

# Update the system
RUN yum -y update && yum -y upgrade

# Install required dependencies
RUN yum -y install git which tar

# Install RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl -sSL https://get.rvm.io | /bin/bash -s stable

# Install Ruby 1.9.3
RUN /usr/local/rvm/bin/rvm install ruby-1.9.3

# If no commands were provided, simply run a login shell
ENTRYPOINT ["/bin/bash","-l"]

