# Environment Vars
# no default - must be specified in tfvars env file

variable "num_tasks" {
  type        = map(any)
  description = "Number of desired container tasks"
}

variable "tasks" {
  type = string
  description = "Num tasks to run on each stack"
}

variable cluster_id {
  type = string
}

variable "app_name" {
  type        = string
  description = "generic String used for app"
}

variable green_tg {
  type = string
}

variable blue_tg {
  type = string
}

variable ecs_sg {
  type = string
}

variable priv_subnets {
  type = list(string)
}