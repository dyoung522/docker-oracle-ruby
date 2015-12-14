# OracleLinux running Ruby
FROM dyoung522/oraclelinux-dev:6.6

MAINTAINER Donovan Young <dyoung522@gmail.com>

ENV RUBY_MAJOR      1.9
ENV RUBY_VERSION    1.9.3-p551
ENV RUBY_SOURCE_URL http://ftp.ruby-lang.org/pub/ruby/${RUBY_MAJOR}/ruby-${RUBY_VERSION}.tar.gz

## Intall Ruby
RUN yum -y -q install readline readline-devel \
                      openssl openssl-devel \
                      libyaml libyaml-devel \
                      zlib zlib-devel \
                      gdbm-devel libffi-devel \
                      ncurses-devel \
                      tar \
                      which && \

    yum -y -q clean all && \
    mkdir -p /usr/src/ruby && \
    curl -fSL -o ruby.tar.gz $RUBY_SOURCE_URL && \
    tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 && \
    rm ruby.tar.gz && \
    cd /usr/src/ruby && \
    autoconf && \
    ./configure --disable-install-doc && \
    make -j"$(nproc)" && \
    make install && \
    cd $HOME && rm -rf /usr/src/ruby

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_APP_CONFIG $GEM_HOME
ENV PATH $GEM_HOME/bin:$PATH

RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc" && \
    gem install bundler && \
    bundle config --global path "$GEM_HOME" && \
    bundle config --global bin "$GEM_HOME/bin"

## Metadata (put at the end so changes don't invalidate caches)
LABEL Description="OracleLinux and Ruby ${RUBY_VERSION}" \
      Version="0.3.1"
