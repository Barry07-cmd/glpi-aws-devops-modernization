terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "glpi-tfstate-barry-devopsprojaws"
    key          = "envs/dev/terraform.tfstate"
    region       = "eu-north-1"
    profile      = "glpi"
    encrypt      = true
    use_lockfile = true
  }
}
