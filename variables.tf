variable "key_name" {
  type        = string
  description = "The name for ssh key, used for aws_launch_configuration"
  default = "ec2"
}

variable "db_password" {
  default = "northone"
}

variable "db_username" {
  default = "northone"
}

variable "task_role_arn" {
  type = "string"
  description = "attach task role here to talk to rds"
  default = **
}

variable "certificate" {
  type = "string"
  description = "ARN OF THE CERT"
  default = **
}