#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Cloud Service Provider Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Amazon Web Services (AWS)
brew_install "awscli" "Installing AWS CLI" false

brew_install "aws-sam-cli" "Installing AWS SAM CLI" false

brew_install "aws-cdk" "Installing AWS CDK" false

pip_install "boto3" "Installing AWS SDK for Python"

pip_install "aws-shell" "Installing AWS Shell"

pip_install "cloudformation-cli" "Installing CloudFormation CLI"

pip_install "ecs-cli" "Installing ECS CLI"

pip_install "aws-elastic-beanstalk-cli" "Installing Elastic Beanstalk CLI"

# Google Cloud Platform (GCP)
brew_install "google-cloud-sdk" "Installing Google Cloud SDK" false

execute "gcloud components install beta" \
    "Installing GCloud Beta Components"

execute "gcloud components install kubectl" \
    "Installing kubectl for GKE"

pip_install "google-cloud" "Installing Google Cloud Python Libraries"

pip_install "google-cloud-ai-platform" "Installing AI Platform SDK"

pip_install "firebase-admin" "Installing Firebase Admin SDK"

brew_install "firebase-cli" "Installing Firebase CLI" false

# Microsoft Azure
brew_install "azure-cli" "Installing Azure CLI" false

pip_install "azure-mgmt-resource" "Installing Azure Resource Manager"

pip_install "azure-mgmt-compute" "Installing Azure Compute Management"

pip_install "azure-mgmt-storage" "Installing Azure Storage Management"

pip_install "azure-mgmt-network" "Installing Azure Network Management"

pip_install "azure-cognitiveservices-vision-computervision" "Installing Azure Computer Vision"

pip_install "azure-ai-ml" "Installing Azure ML SDK"

brew_install "azure-functions-core-tools@4" "Installing Azure Functions Core Tools" false

# Oracle Cloud Infrastructure (OCI)
brew_install "oci-cli" "Installing OCI CLI" false

pip_install "oci" "Installing OCI SDK for Python"

pip_install "oci-cli-dev" "Installing OCI CLI Developer Tools"

pip_install "oracle-autonomous-database" "Installing Oracle Autonomous Database SDK"

pip_install "oracle-nosql" "Installing Oracle NoSQL SDK"

# IBM Cloud
brew_install "ibmcloud-cli" "Installing IBM Cloud CLI" false

execute "ibmcloud plugin install container-service" \
    "Installing IBM Container Service Plugin"

execute "ibmcloud plugin install cloud-functions" \
    "Installing IBM Cloud Functions Plugin"

pip_install "ibm-watson" "Installing IBM Watson SDK"

pip_install "ibm-cloud-sdk-core" "Installing IBM Cloud SDK Core"

# Cloud Development Tools
brew_install "terraform" "Installing Terraform" false

brew_install "pulumi" "Installing Pulumi" false

brew_install "kubernetes-cli" "Installing Kubernetes CLI" false

brew_install "helm" "Installing Helm" false

brew_install "docker" "Installing Docker" false

# Cloud Monitoring and Management
pip_install "cloudwatch-monitoring" "Installing CloudWatch Monitoring Tools"

pip_install "stackdriver-monitoring" "Installing Stackdriver Monitoring Tools"

pip_install "azure-monitor" "Installing Azure Monitor"

# Multi-Cloud Tools
pip_install "apache-libcloud" "Installing Apache Libcloud"

pip_install "cloud-custodian" "Installing Cloud Custodian"

pip_install "cloudmapper" "Installing CloudMapper"
