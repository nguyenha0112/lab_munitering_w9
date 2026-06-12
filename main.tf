data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_iam_role" "cloudwatch_agent" {
  name = "xbrain-monitoring-lab-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Lab = "AWS-Monitoring-Xbrain" }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.cloudwatch_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.cloudwatch_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "cloudwatch_agent" {
  name = "xbrain-monitoring-lab-instance-profile"
  role = aws_iam_role.cloudwatch_agent.name
}

resource "aws_instance" "monitoring" {
  ami                  = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_agent.name
  user_data            = file("${path.module}/user-data.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "xbrain-monitoring-lab-ec2"
    Lab  = "AWS-Monitoring-Xbrain"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cloudwatch_agent,
    aws_iam_role_policy_attachment.ssm
  ]
}

resource "aws_sns_topic" "cpu_alerts" {
  name = "xbrain-monitoring-lab-alerts"
  tags = { Lab = "AWS-Monitoring-Xbrain" }
}

resource "aws_sns_topic_subscription" "email" {
  count = var.notification_email == "" ? 0 : 1

  topic_arn = aws_sns_topic.cpu_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "xbrain-monitoring-lab-high-cpu"
  alarm_description   = "Email when EC2 CPU is greater than 80 percent for 5 minutes."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 80
  period              = 300
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = aws_instance.monitoring.id
  }

  alarm_actions = [aws_sns_topic.cpu_alerts.arn]
  ok_actions    = [aws_sns_topic.cpu_alerts.arn]

  tags = { Lab = "AWS-Monitoring-Xbrain" }
}
