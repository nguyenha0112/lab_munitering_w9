# Lab 2 - CPU Alarm to Email via SNS

## Muc tieu

- Tao SNS Standard Topic.
- Tao email subscription.
- Tao CloudWatch Alarm cho EC2.
- Gui email khi CPU lon hon 80% trong 5 phut.

## Cau hinh alarm

| Thuoc tinh | Gia tri |
|---|---|
| Namespace | `AWS/EC2` |
| Metric | `CPUUtilization` |
| Statistic | `Average` |
| Threshold | `GreaterThanThreshold 80` |
| Period | `300` giay |
| Evaluation | `1 out of 1` |
| Alarm action | SNS topic |

## Cau hinh email

Tao `terraform.tfvars`:

```hcl
aws_region         = "us-west-2"
notification_email = "your-email@example.com"
instance_type      = "t3.micro"
```

Ap dung:

```powershell
terraform apply
```

AWS se gui email `AWS Notification - Subscription Confirmation`. Bam
`Confirm subscription` de kich hoat nhan canh bao.

## Kich hoat alarm

```powershell
.\trigger-cpu.ps1
```

Script dung SSM de chay `stress-ng` trong 7 phut. Cho khoang 6-10 phut de alarm
chuyen sang `In alarm` va SNS gui email.
