# sit706-6.1p



## Creating supporting resources.

Terraform best practice dictates that the state should be remotely hosted and that state locking should be enabled. S3 and DynamoDB are being used to facilitate this. 

```
aws dynamodb create-table \
    --region ap-southeast-2 \
    --table-name terraform-lock-sit706-6.1p  \
    --attribute-definitions AttributeName=LockID,AttributeType=S \

aws s3api create-bucket 
    --bucket terraform-state-sit706-6.1p --region us-east-1
```