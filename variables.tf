variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "notification_email" {
  description = "Email receiving CloudWatch alarm notifications."
  type        = string
  default     = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
