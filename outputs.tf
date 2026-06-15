output "instance_id" {
  value = aws_instance.monitoring.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.cpu_alerts.arn
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "email_confirmation" {
  value = var.notification_email == "" ? "Set notification_email in terraform.tfvars." : "Confirm the subscription from your email inbox."
}

output "cloudtrail_name" {
  value = aws_cloudtrail.root_login.name
}

output "cloudtrail_log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail.name
}

output "root_login_alarm_name" {
  value = aws_cloudwatch_metric_alarm.root_login.alarm_name
}

output "root_login_console_links" {
  value = {
    cloudtrail_trail = "https://${var.aws_region}.console.aws.amazon.com/cloudtrailv2/home?region=${var.aws_region}#/trails/xbrain-root-login-trail"
    log_group        = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logsV2:log-groups/log-group/xbrain-root-login-cloudtrail"
    metric_filters   = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logsV2:log-groups/log-group/xbrain-root-login-cloudtrail/metric-filters"
    alarm            = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#alarmsV2:alarm/RootAccountLoginAlarm"
    sns              = "https://${var.aws_region}.console.aws.amazon.com/sns/v3/home?region=${var.aws_region}#/topics/${aws_sns_topic.cpu_alerts.arn}"
  }
}
