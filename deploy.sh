##
## Script to deploy the cloudformation templates.
##

aws configure set region ap-southeast-2

# Validate before trying to deploy.

set -e # Exit script in case of failure
aws cloudformation validate-template \
  --template-body file://templates/phase1_network.yaml
aws cloudformation validate-template \
  --template-body file://templates/phase1a_application.yaml
aws cloudformation validate-template \
  --template-body file://templates/phase1b_application.yaml
set +e # Do not exit script in case of failure

# Try create and then try update every stack. Command failure is ok.

aws cloudformation create-stack \
  --stack-name network \
  --template-body file://templates/phase1_network.yaml

aws cloudformation update-stack \
  --stack-name network \
  --template-body file://templates/phase1_network.yaml

aws cloudformation create-stack \
  --stack-name application \
  --template-body file://templates/phase1a_application.yaml \
  --parameters ParameterKey=NetworkStackName,ParameterValue=network \
  --capabilities CAPABILITY_IAM

aws cloudformation update-stack \
  --stack-name application \
  --template-body file://templates/phase1a_application.yaml \
  --parameters ParameterKey=NetworkStackName,ParameterValue=network \
  --capabilities CAPABILITY_IAM

aws cloudformation create-stack \
  --stack-name application-autoscale \
  --template-body file://templates/phase1b_application.yaml \
  --parameters ParameterKey=NetworkStackName,ParameterValue=network \
               ParameterKey=ApplicationStackName,ParameterValue=application \
               ParameterKey=AmazonLinuxAMIID,ParameterValue=ami-0f9aa134051df6443 \
  --capabilities CAPABILITY_IAM

aws cloudformation update-stack \
  --stack-name application-autoscale \
  --template-body file://templates/phase1b_application.yaml \
  --parameters ParameterKey=NetworkStackName,ParameterValue=network \
               ParameterKey=ApplicationStackName,ParameterValue=application \
               ParameterKey=AmazonLinuxAMIID,ParameterValue=ami-0f9aa134051df6443 \
  --capabilities CAPABILITY_IAM