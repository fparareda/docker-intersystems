FROM centos:6

LABEL maintainer="Ferran Parareda <ferran.parareda@gmail.com>"

# update OS + dependencies & run Caché silent instal
RUN yum -y update \
 && yum -y install which tar hostname net-tools wget \
 && yum -y clean all

ARG version=2017.2.1.801.3
ARG product=cache

ENV TMP_INSTALL_DIR=/tmp/distrib

# vars for Caché silent install
ENV ISC_PACKAGE_INSTANCENAME=$product \
    ISC_PACKAGE_INSTALLDIR="/usr/cachesys/" \
    ISC_PACKAGE_UNICODE="Y" \
    ISC_PACKAGE_CLIENT_COMPONENTS=""

# set-up and install Caché from distrib_tmp dir 
WORKDIR ${TMP_INSTALL_DIR}

ADD $product-$version-lnxrhx64.tar.gz .

RUN ./$product-$version-lnxrhx64/cinstall_silent || ./cinstall_silent \
 && ccontrol stop $ISC_PACKAGE_INSTANCENAME quietly \
 && wget -q https://github.com/daimor/ccontainermain/releases/download/0.7.1/ccontainermain -O /ccontainermain \
 && chmod +x /ccontainermain \
 && rm -rf $TMP_INSTALL_DIR

WORKDIR ${ISC_PACKAGE_INSTALLDIR}
COPY ccontrol-wrapper.sh /usr/local/bin/ccontrol
RUN chmod 777 /usr/local/bin/ccontrol

# TCP sockets that can be accessed if user wants to (see 'docker run -p' flag)
EXPOSE 57772 1972

ENTRYPOINT ["/ccontainermain", "-cconsole"]
