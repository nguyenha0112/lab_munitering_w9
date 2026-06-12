# Lab 1 - Install CloudWatch Agent on EC2

## Muc tieu

- Tao EC2 Amazon Linux bang Terraform.
- Tao IAM role cho EC2.
- Gan `CloudWatchAgentServerPolicy`.
- Cai dat va khoi dong CloudWatch Agent bang `user_data`.
- Gui metric RAM va disk len CloudWatch.

## Tai nguyen Terraform

- `aws_instance.monitoring`
- `aws_iam_role.cloudwatch_agent`
- `aws_iam_instance_profile.cloudwatch_agent`
- `aws_iam_role_policy_attachment.cloudwatch_agent`
- `aws_iam_role_policy_attachment.ssm`

File [user-data.sh](user-data.sh) thuc hien:

```bash
dnf install -y amazon-cloudwatch-agent

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

systemctl enable amazon-cloudwatch-agent
systemctl restart amazon-cloudwatch-agent
```

Custom namespace: `XBrain/EC2`

Metrics:

- `mem_used_percent`
- `disk_used_percent`

## Trien khai

```powershell
terraform init
terraform plan
terraform apply
```

## Kiem tra

```powershell
$id = terraform output -raw instance_id

aws ssm send-command `
  --region us-west-2 `
  --instance-ids $id `
  --document-name AWS-RunShellScript `
  --parameters 'commands=["/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status"]'
```

Ket qua hien tai: agent `running`, cau hinh `configured`.
