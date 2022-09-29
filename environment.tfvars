deploy_role = "arn:aws:iam::874843396208:role/ch-terragrunt-plana"
num_tasks = 2

vpc_cidr = "10.0.0.0/23"
pub_subnets = {
    sub-1 = {
        az = "eu-central-1a"
        cidr = "10.0.0.0/27"
        name = "PlanA Public A"
      }
    sub-2 = {
        az = "eu-central-1b"
        cidr = "10.0.0.32/27"
        name = "PlanA Public B"
    }
}

priv_subnets = {
    sub-1 = {
        az = "eu-central-1a"
        cidr = "10.0.0.64/27"
        name = "PlanA Private A"
      }
    sub-2 = {
        az = "eu-central-1b"
        cidr = "10.0.0.96/27"
        name = "PlanA Private B"
    }
}