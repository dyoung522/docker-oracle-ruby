FROM oraclelinux:6.6

MAINTAINER Donovan Young <dyoung522@gmail.com>

## Update the system, Install required dependencies
RUN yum -y -q update && \
    yum -y -q groupinstall "Development Tools" && \
    yum -y -q install dkms kernel-devel libicu && \
    yum -y -q clean all

## Metadata (put at the end so changes don't invalidate caches)
LABEL Description="OracleLinux and Development environment" \
      Version="0.1.0"

