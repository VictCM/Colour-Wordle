locals {
  environment = terraform.workspace

  # Egress all security group rules
  egress_all = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = "true"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ingress_all = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = "true"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

}

#######################################################################################################################################
# VARIABLES
#######################################################################################################################################

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "testing-project"
}

#############################################
# EC2
#############################################

variable "ubuntu_version" {
  description = "ubuntu version"
  type        = string
  default     = "18.04"
}

variable "ubuntu_account_number" {
  description = "Ubuntu account number"
  type        = string
  default     = "099720109477"
}

variable "instance_type" {
  description = "The size of instance to launch"
  type        = string
  default     = "t3.large"
}
