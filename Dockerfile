FROM amazon/aws-cli

ARG KUBE_VERSION="1.21.2"

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cluster-info"]
