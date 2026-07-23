variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix for tags and resources"
  type        = string
  default     = "tf-ansible"
}

variable "instance_type" {
  description = "EC2 Instance type (Free Tier Safe)"
  type        = string
  default     = "t3.micro"
}