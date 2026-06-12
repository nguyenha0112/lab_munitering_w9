# Evidence Pack

Region su dung: `Oregon (us-west-2)`.

## Lab 1 - CloudWatch Agent

### Evidence 1: Terraform apply

Chay:

```powershell
terraform apply
```

Chup terminal co dong `Apply complete` va Terraform outputs.

### Evidence 2: IAM policy

Mo:

`IAM > Roles > xbrain-monitoring-lab-ec2-role > Permissions`

Chup man hinh va danh dau dong `CloudWatchAgentServerPolicy`.

### Evidence 3: Agent running

Mo:

`Systems Manager > Run Command > Command history`

Chay lenh status CloudWatch Agent, sau do chup output co:

```json
{
  "status": "running",
  "configstatus": "configured"
}
```

### Evidence 4: Custom metrics

Mo:

`CloudWatch > Metrics > All metrics > XBrain/EC2`

Chup `mem_used_percent`, `disk_used_percent`, InstanceId va bieu do co du lieu.

## Lab 2 - CPU Alarm va SNS

### Evidence 5: SNS confirmed

Mo:

`SNS > Subscriptions`

Chup protocol `Email` va status `Confirmed`.

### Evidence 6: Alarm configuration

Mo:

`CloudWatch > Alarms > xbrain-monitoring-lab-high-cpu > Details`

Danh dau:

- `CPUUtilization`
- Greater than `80`
- Period `5 minutes`
- Evaluation `1 out of 1`
- SNS notification action

### Evidence 7: Alarm triggered

Chay:

```powershell
.\trigger-cpu.ps1
```

Cho 6-10 phut. Chup trang alarm co trang thai do `In alarm` va bieu do CPU vuot
80%.

### Evidence 8: Email alert

Chup email co subject, alarm name, trang thai `ALARM`, timestamp va region.
Che dia chi email ca nhan neu nop cong khai.

## Cach chup va danh dau

1. Nhan `Win + Shift + S`.
2. Chon `Rectangular snip`.
3. Chup ca breadcrumb, ten tai nguyen, region va gia tri can chung minh.
4. Mo Snipping Tool, dung but mau do khoanh gia tri quan trong.
5. Luu anh ben ngoai repository hoac chen link anh vao file nay sau khi chup.
6. Khong chup access key, secret key, mat khau hoac thong tin thanh toan.
