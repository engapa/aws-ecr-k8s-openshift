FROM engapa/aws-ecr-login:latest
MAINTAINER Enrique Garcia <engapa@gmail.com>

# Required environment variables
ENV OC_VERSION='v3.6.0'\
    OC_SERVER='https://openshift.default.svc.cluster.local'\
    OC_TOKEN=''\
    SECRET_NAME='aws-ecr-dockercfg'\
    SERVICE_ACCOUNTS='default'\
    PROJECTS='default'\
    OPTION_FOR='pull'\
    DOCKER_LOGIN_TYPE='auto'\
    DOCKER_LOGIN_USERNAME='AWS'\
    DOCKER_LOGIN_EMAIL='engapa@gmail.com'\
    DOCKER_LOGIN_PASSWRD=''\
    DOCKER_LOGIN_REGISTRY=''

RUN apt-get update\
    && apt-get install jq

ADD oc_install.sh oc_secret2sa.sh ./

RUN chmod a+x oc_install.sh oc_secret2sa.sh \
    && ./oc_install.sh

CMD ./oc_secret2sa.sh
