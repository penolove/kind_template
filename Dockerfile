FROM python:3.6-slim-stretch

ARG KUBECTL_VERSION="v1.15.0"
ENV KUBECTL_VERSION=${KUBECTL_VERSION}
ARG KIND_VERSION="v0.7.0"
ENV KIND_VERSION=${KIND_VERSION}

ENV DEBIAN_FRONTEND=noninteractive LANGUAGE=C.UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    LC_CTYPE=C.UTF-8 LC_MESSAGES=C.UTF-8

# Install basic apt dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
           apt-utils \
           build-essential \
           curl \
           dirmngr \
           freetds-bin \
           freetds-dev \
           git \
           gosu \
           libffi-dev \
           libkrb5-dev \
           libpq-dev \
           libsasl2-2 \
           libsasl2-dev \
           libsasl2-modules \
           libssl-dev \
           locales  \
           netcat \
           nodejs \
           rsync \
           sasl2-bin \
           sudo \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN curl -Lo kubectl \
  "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && mv kubectl /usr/local/bin/kubectl

RUN curl -Lo kind \
   "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64" \
   && chmod +x kind \
   && mv kind /usr/local/bin/kind


# Note missing man directories on debian-stretch
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -pv /usr/share/man/man1 \
    && mkdir -pv /usr/share/man/man7 \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
      gnupg \
      apt-transport-https \
      ca-certificates \
      software-properties-common \
      krb5-user \
      ldap-utils \
      less \
      lsb-release \
      net-tools \
      openjdk-8-jdk \
      openssh-client \
      openssh-server \
      postgresql-client \
      python-selinux \
      sqlite3 \
      tmux \
      unzip \
      vim \
      iputils-ping \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" \
    && apt-get update \
    && apt-get -y install --no-install-recommends docker-ce \
    && apt-get autoremove -yqq --purge \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && bash get_helm.sh
