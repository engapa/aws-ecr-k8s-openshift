#!/bin/bash

set -e

oc_login() {

  OC_TOKEN=${OC_TOKEN:-$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)}

  if [[ -z $OC_SERVER || -z $OC_TOKEN ]]; then
    echo 'OC_SERVER (by default: https://openshift.default.svc.cluster.local) and OC_TOKEN are required values to connect to Openshift cluster.' && exit 1;
  fi

  oc login $OC_SERVER --token=$OC_TOKEN --certificate-authority="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

}

oc_secret2sa() {

  if [ "${DOCKER_LOGIN_TYPE}" == 'auto' ]; then
    source cmd.sh
    export DOCKER_LOGIN_USERNAME=$(get_username)
    export DOCKER_LOGIN_EMAIL=$(get_email)
    export DOCKER_LOGIN_PASSWORD=$(get_password)
    export DOCKER_LOGIN_REGISTRY=$(get_registry_url)
  elif [[ -z $DOCKER_LOGIN_PASSWORD || -z $DOCKER_LOGIN_REGISTRY ]]; then
    echo 'DOCKER_LOGIN_PASSWORD and DOCKER_LOGIN_REGISTRY are required values.' && exit 1;
  fi

  if [ -z $PROJECTS ]; then
    echo 'Not found a valid value for environment variable PROJECTS' && exit 1
  elif [ "${PROJECTS}" == "all" ]; then
    OC_ARG_PROJECTS=$(oc get projects --no-headers -o custom-columns=NAME:.metadata.name)
  else
    OC_ARG_PROJECTS=${PROJECTS}
  fi

  OC_ARG_SA=${SERVICE_ACCOUNTS:-'default'}

  OC_ARG_FOR=${OPTION_FOR:-'pull'}

  for project in $OC_ARG_PROJECTS; do
    oc project $project
    oc get secret $SECRET_NAME && oc delete secret $SECRET_NAME
    oc secrets new-dockercfg $SECRET_NAME \
       --docker-username=$DOCKER_LOGIN_USERNAME \
       --docker-email=$DOCKER_LOGIN_EMAIL \
       --docker-password=$DOCKER_LOGIN_PASSWORD
    for sa in ${OC_ARG_SA[@]}; do
       oc secrets link $sa $SECRET_NAME --for=$OC_ARG_FOR -n $project
    done
  done

}

oc login && oc_secret2sa
