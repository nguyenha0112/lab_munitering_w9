$ErrorActionPreference = "Stop"
$instanceId = terraform output -raw instance_id

$commandId = aws ssm send-command `
  --region us-west-2 `
  --instance-ids $instanceId `
  --document-name AWS-RunShellScript `
  --comment "Trigger XBrain CPU alarm" `
  --parameters 'commands=["nohup stress-ng --cpu 2 --timeout 420s >/tmp/xbrain-stress.log 2>&1 &"]' `
  --query "Command.CommandId" `
  --output text

Write-Host "CPU load started on $instanceId."
Write-Host "SSM command: $commandId"
Write-Host "Wait 6-10 minutes for the alarm and email."
