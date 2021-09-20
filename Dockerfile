FROM alpine

USER root
# Curl, openssl and bash

RUN set -x && \
    apk add --update --no-cache curl openssl bash && \
    rm -rf  /var/cache/apk/*

# artifactory creds as build args
ARG URL
ARG USERNAME
ARG PASSWORD

# copy check-artifact.sh
COPY check-artifact.sh .

# install terraform

ENV TERRAFORM_VERSION 1.0.7
ENV ARTIFACTORY_URL "${URL}/tools/terraform/v${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ENV EXTERNAL_URL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
RUN chmod +x check-artifact.sh && \
    ./check-artifact.sh ${ARTIFACTORY_URL} ${EXTERNAL_URL} && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform version

