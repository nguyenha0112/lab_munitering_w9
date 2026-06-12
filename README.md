# AWS Monitoring Labs with Terraform

Region: `us-west-2` (Oregon)

## Tong quan

Hai bai lab thuc hanh trien khai giam sat EC2 tren AWS bang Terraform:

| Lab | Noi dung |
|-----|----------|
| Lab 1 | Cai dat CloudWatch Agent, day custom metrics RAM va Disk |
| Lab 2 | Tao CloudWatch Alarm CPU > 80%, gui canh bao qua SNS Email |

---

## Yeu cau

- Terraform >= 1.5.0
- AWS CLI da cau hinh credentials
- Python / `terraform` trong PATH

---

## Cau truc project

```
.
├── main.tf                  # EC2, IAM Role, SNS Topic, CloudWatch Alarm
├── variables.tf             # Bien dau vao
├── outputs.tf               # Output instance_id, alarm_name, sns_arn
├── versions.tf              # Provider AWS ~> 6.0
├── user-data.sh             # Cai dat & cau hinh CloudWatch Agent
├── trigger-cpu.ps1          # Kich hoat CPU load qua SSM de test alarm
├── terraform.tfvars.example # Mau file tfvars
├── README-LAB1.md           # Huong dan Lab 1
├── README-LAB2.md           # Huong dan Lab 2
└── evidentpack.md           # Danh sach minh chung can nop
```

---

## Lab 1 - CloudWatch Agent tren EC2

Xem huong dan chi tiet: [README-LAB1.md](README-LAB1.md)

### Buoc 1: Trien khai

```powershell
terraform init
terraform plan
terraform apply
```

Terraform tao:
- EC2 `t3.micro` Amazon Linux 2023
- IAM Role gan policy `CloudWatchAgentServerPolicy` + `AmazonSSMManagedInstanceCore`
- `user-data.sh` tu dong cai CloudWatch Agent va gui metrics

### Buoc 2: Kiem tra agent

```powershell
$id = terraform output -raw instance_id

aws ssm send-command `
  --region us-west-2 `
  --instance-ids $id `
  --document-name AWS-RunShellScript `
  --parameters 'commands=["/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status"]'
```

Ket qua mong doi: `"status": "running"`, `"configstatus": "configured"`

### Buoc 3: Kiem tra custom metrics tren Console

Vao CloudWatch > Metrics > All metrics > Custom namespaces > `XBrain/EC2`

**Link nhanh:** https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#metricsV2?graph=~()&query=~'*7BXBrain*2FEC2*2CInstanceId*7D

Metrics can thay:
- `mem_used_percent`
- `disk_used_percent` (resource: `/`)

---

## Lab 2 - CPU Alarm va SNS Email

Xem huong dan chi tiet: [README-LAB2.md](README-LAB2.md)

### Buoc 1: Tao file tfvars

```hcl
# terraform.tfvars
aws_region         = "us-west-2"
notification_email = "your-email@example.com"
instance_type      = "t3.micro"
```

```powershell
terraform apply
```

### Buoc 2: Xac nhan email subscription

AWS gui email **"AWS Notification - Subscription Confirmation"`. Bam link
`Confirm subscription` trong email.

Kiem tra trang thai:

**Link nhanh:** https://us-west-2.console.aws.amazon.com/sns/v3/home?region=us-west-2#/subscriptions

Can thay: Protocol `Email`, Status `Confirmed`.

### Buoc 3: Kich hoat CPU load

```powershell
.\trigger-cpu.ps1
```

Script chay `stress-ng` 7 phut qua SSM. Cho 6-10 phut de alarm doi trang thai.

### Buoc 4: Xem alarm tren Console

**Link nhanh:** https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#alarmsV2:alarm/xbrain-monitoring-lab-high-cpu

Can thay trang thai `In alarm` (mau do) va bieu do CPU vuot 80%.

---

## Evidence Pack

Xem danh sach day du minh chung can nop: [evidentpack.md](evidentpack.md)

### Cac man hinh can chup

| # | Man hinh | Link truc tiep |
|---|----------|---------------|
| 1 | `terraform apply` thanh cong | *(chup terminal)* |
| 2 | IAM Role voi policy dinh kem | https://us-east-1.console.aws.amazon.com/iam/home#/roles/xbrain-monitoring-lab-ec2-role |
| 3 | CloudWatch Agent status `running` | *(chup output SSM command)* |
| 4 | Custom metrics `XBrain/EC2` xuat hien | https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#metricsV2 |
| 5 | SNS Subscription status `Confirmed` | https://us-west-2.console.aws.amazon.com/sns/v3/home?region=us-west-2#/subscriptions |
| 6 | Alarm config: metric, threshold, SNS action | https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#alarmsV2:alarm/xbrain-monitoring-lab-high-cpu |
| 7 | Alarm trang thai `In alarm`, bieu do CPU > 80% | https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#alarmsV2:alarm/xbrain-monitoring-lab-high-cpu |
| 8 | Email canh bao tu SNS voi trang thai `ALARM` | *(chup email)* |

---

## Don dep

```powershell
terraform destroy
```
