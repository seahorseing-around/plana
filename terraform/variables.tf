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
  type        = map(any)
  description = "Public Subnet Definitions."
}

variable "priv_subnets" {
  type        = map(any)
  description = "Private Subnet Definitions."
}

variable "traffic_dist_map" {
  type        = map(any)
  description = "ALB traffic weighting"
}

variable "mode" {
  type        = string
  description = "Mode of traffic routing, must be a value from traffic_dist_map"
}

variable "num_tasks" {
  type        = map(any)
  description = "Number of desired cntainer tasks"
}

variable "tasks" {
  type        = string
  description = "Task distribution to choose"
}

variable "deploy_role" {
  type        = string
  description = "Role used to deploy infra"
}