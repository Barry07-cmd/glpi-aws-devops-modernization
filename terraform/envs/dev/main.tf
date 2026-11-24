provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      Project     = "glpi-aws-modernization"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

module "network" {
  source = "../../modules/network"
  name   = "glpi-dev"
}

module "ecr" {
  source       = "../../modules/ecr"
  name         = "glpi-modernization"
  force_delete = true
}
