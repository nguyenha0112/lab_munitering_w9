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
