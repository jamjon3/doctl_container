FROM digitalocean/doctl:latest

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && mv ./doctl /usr/local/bin/doctl \
  && apk update \
  && apk add \
    build-base \
    gcc \
    wget \
    git \
    openssl \
    docker \
    libffi-dev \
    libffi \
    python-dev \
    openssl-dev \
    openssl \
    curl \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    tar && \
  pip install --upgrade pip python-keyczar && \
  pip install --upgrade ansible openshift PyYAML && \
  mkdir -p /usr/local/etc/ansible/roles && \
  curl -L https://git.io/get_helm.sh | bash && \
  rm -rf /var/cache/apk/*

#     py-yaml \
#    py-setuptools \

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /usr/local/etc/ansible/roles
ENV ANSIBLE_SSH_PIPELINING True

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]