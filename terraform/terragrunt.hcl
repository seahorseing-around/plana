
iam_role = "arn:aws:iam::874843396208:role/ch-terragrunt-plana"

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "plana-tf-state"
    key = "${path_relative_to_include()}/plana.tfstate"
    region         = "eu-central-1"
    encrypt        = false
    dynamodb_table = "tf-lock-table"
  }
}


generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  assume_role {
    role_arn = var.deploy_role
  }
  region = var.region
}
EOF
}

terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]

    arguments = [
      "-var-file=environment.tfvars",
      "-var-file=general.tfvars"
    ]
  }
}