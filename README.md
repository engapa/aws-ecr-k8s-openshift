# openshift-aws-ecr

Autologin on AWS ECR within Kubernetes and Openshift clusters, which on RBAC is activated

The main component is a CronJob because of this resource let's perform a job under a cron scheduler.

## AWS Credentials, service accounts and secrets

AWS credentials are saved as secrets.

The container of the CronJob will use these secrets to get login parameters for the ECR service.
Finally, another secrets will be generated in each project and associated to the desired service accounts to pull (or push) images from/to AWS ECR.

## kubernetes

Kubernetes resources are under the [k8s directory](k8s)

## openshift

Find out resources at [openshift directory](openshift)
