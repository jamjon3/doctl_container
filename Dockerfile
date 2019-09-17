FROM digitalocean/doctl:latest

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && curl -LO https://git.io/get_helm.sh \
  && chmod 700 get_helm.sh \
  && ./get_helm.sh \
  && rm ./get_helm.sh
