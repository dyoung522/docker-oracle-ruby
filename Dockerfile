# OracleLinux running Ruby

FROM oraclelinux:6.6

## Update the system
RUN yum -y update && yum -y upgrade

## Install required dependencies
RUN yum -y groupinstall "Development Tools" && \
    yum -y install binutils \
                   dkms \
                   git \
                   glibc-headers glibc-devel \
                   kernel-headers kernel-devel \
                   libgomp libicu \
                   tar \
                   which

ENV RUBY_MAJOR 1.9
ENV RUBY_VERSION 1.9.3
ENV RUBY_PATCH p551
ENV RUBY_SOURCE_VERSION ${RUBY_VERSION}-${RUBY_PATCH}
ENV RUBY_SOURCE_URL http://ftp.ruby-lang.org/pub/ruby/${RUBY_MAJOR}/ruby-${RUBY_SOURCE_VERSION}.tar.gz

## Intall Ruby
RUN yum -y install libreadline libreadline-dev \
                   libyaml libyaml-devel \
                   zlib zlib-devel zlib1g-dev \
                   libssl libssl-dev openssl openssl-devel libcurl4-openssl-dev


RUN mkdir -p /usr/src/ruby
RUN curl -fSL -o ruby.tar.gz $RUBY_SOURCE_URL \
    && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
    && rm ruby.tar.gz \
    && cd /usr/src/ruby \
    && autoconf \
    && ./configure --disable-install-doc \
    && make -j"$(nproc)" \
    && make install
RUN rm -rf /usr/src/ruby

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

# We should update when included from other projects
ONBUILD RUN yum -y update

## Metadata (put at the end so changes don't invalidate caches)
MAINTAINER Donovan Young <dyoung522@gmail.com>
LABEL Description="OracleLinux and Ruby ${RUBY_VERSION}" \
      Version="0.2.0"

