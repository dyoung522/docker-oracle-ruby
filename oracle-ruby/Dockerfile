# OracleLinux running Ruby

FROM oraclelinux:6.6

MAINTAINER Donovan Young <dyoung522@gmail.com>

LABEL Description="This is a base image including only OracleLinux and Ruby" \
      Version="0.1.0"

## Update the system
RUN yum -y update && yum -y upgrade

## Install required dependencies
RUN yum -y groupinstall "Development Tools" && \
    yum -y install git which tar

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.2

## Intall Ruby
# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN yum -y install libyaml-devel zlib-devel \
    && curl -fSL -o ruby.tar.gz "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p551.tar.gz" \
    && mkdir -p /usr/src/ruby \
    && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
    && rm ruby.tar.gz \
    && cd /usr/src/ruby \
    && autoconf \
    && ./configure --disable-install-doc \
    && make -j"$(nproc)" \
    && make install \
    && rm -r /usr/src/ruby

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

RUN gem install bundler \
    && bundle config --global path "$GEM_HOME" \
    && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

