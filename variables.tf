# General Vars
# Usually can be left as default
variable "app_name" {
  type        = string
  description = "generic String used for app"
  default     = "plana"
}

variable "region" {
  type        = string
  description = "Region to deploy app"
  default     = "eu-central-1"
}



# Environment Vars
# no default - must be specified in tfvars env file

variable "vpc_cidr" {
  type        = string
  description = "CIDR used for primary VPC."
}

variable "pub_subnets" {
  type        = map(string)
  description = "Public Subnet Definitions."
}

variable "priv_subnets" {
  type        = map(string)
  description = "Private Subnet Definitions."
}

variable "num_tasks" {
  type        = number
  description = "Number of desired cntainer tasks"
}

variable "deploy_role" {
  type        = string
  description = "Role used to deploy infra"
}