# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "aws" {
  assume_role {
    role_arn = var.deploy_role
  }
  region = var.region
}