FROM python:3
MAINTAINER Enrique Garcia <engapa@gmail.com>

# Required environment variables
ENV REGISTRY_IDS='' \
    AWS_DEFAULT_REGION='' \
    AWS_ACCESS_KEY_ID='' \
    AWS_SECRET_ACCESS_KEY=''

RUN set -x \
    && pip install -U pip awscli

ADD cmd.sh .

RUN chmod a+x cmd.sh
