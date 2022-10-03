module "core" {
  source           = "./core"
  vpc_cidr         = var.vpc_cidr
  priv_subnets     = var.priv_subnets
  pub_subnets      = var.pub_subnets
  app_name         = var.app_name
  traffic_dist_map = var.traffic_dist_map
  mode             = var.mode
}

module "ecs" {
  source    = "./ecs"
  num_tasks = var.num_tasks
  tasks     = var.tasks

  app_name     = var.app_name
  cluster_id   = module.core.cluster_id
  blue_tg      = module.core.blue_tg
  green_tg     = module.core.green_tg
  ecs_sg       = module.core.ecs_sg
  priv_subnets = module.core.priv_subnets
}

output "alb_nginx_url" {
  value = module.core.alb_nginx_url
}
