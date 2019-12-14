FROM digitalocean/doctl:latest

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && mv ./doctl /usr/local/bin/doctl \
  && apk update \
  && apk add build-base gcc wget git openssl docker py-pip libffi-dev libffi python-dev openssl-dev openssl git \
  && curl -L https://git.io/get_helm.sh | bash \
  && pip install --upgrade pip \
  && pip install ansible openshift PyYAML

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]