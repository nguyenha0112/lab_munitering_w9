# Lab 2 - Installing the CloudWatch Agent on EC2

Region: `Oregon (us-west-2)`

## Evidence 1 - Terraform Apply

![Terraform apply](image-4.png)

## Evidence 2 - IAM Role Policy

IAM role for EC2 includes the required CloudWatch Agent policy.

![IAM role policy](image.png)

## Evidence 3 - CloudWatch Agent Running

CloudWatch Agent status shows `running` and `configured`.

![CloudWatch Agent status](image-1.png)

## Evidence 4 - Custom Metrics

Custom namespace `XBrain/EC2` shows memory and disk metrics.

![Custom CloudWatch metrics](image-2.png)
