deploy_role = "arn:aws:iam::874843396208:role/ch-terragrunt-plana"

vpc_cidr = "10.0.0.0/23"
pub_subnets = {
  sub-1 = {
    az   = "eu-central-1a"
    cidr = "10.0.0.0/27"
    name = "PlanA Public A"
  }
  sub-2 = {
    az   = "eu-central-1b"
    cidr = "10.0.0.32/27"
    name = "PlanA Public B"
  }
}

priv_subnets = {
  sub-1 = {
    az   = "eu-central-1a"
    cidr = "10.0.0.64/27"
    name = "PlanA Private A"
  }
  sub-2 = {
    az   = "eu-central-1b"
    cidr = "10.0.0.96/27"
    name = "PlanA Private B"
  }
}

traffic_dist_map = {
  blue = {
    blue  = 100
    green = 0
  }
  blue-90 = {
    blue  = 90
    green = 10
  }
  both = {
    blue  = 50
    green = 50
  }
  green-90 = {
    blue  = 10
    green = 90
  }
  green = {
    blue  = 0
    green = 100
  }
}

num_tasks = {
  blue = {
    blue  = 2
    green = 0
  }
  both = {
    blue  = 2
    green = 2
  }
  green = {
    blue  = 0
    green = 2
  }
}