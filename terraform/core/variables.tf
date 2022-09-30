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

variable "app_name" {
  type        = string
  description = "generic String used for app"
}

variable "traffic_dist_map" {
  type        = map(any)
  description = "ALB Traffic Weighting"
}

variable "mode" {
  type = string
  description = "Green/Blue runing mode"
}