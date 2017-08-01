FROM python:alpine
MAINTAINER Enrique Garcia <engapa@gmail.com>

# Required environment variables
ENV REGISTRY_IDS='' \
    AWS_DEFAULT_REGION='' \
    AWS_ACCESS_KEY_ID='' \
    AWS_SECRET_ACCESS_KEY=''

RUN pip install -U pip awscli

ADD entrypoint.sh .

ENTRYPOINT ./entrypoint.sh
