terraform {
  backend "s3" {
    bucket = "rstudio-infra-tfstate"
    key    = "dev/rstudio/infrastructure.tfstate"
    region = "eu-central-1"
#    shared_credentials_file = "~/.aws/credentials"
  }
  required_version = ">= 0.13.7"
}

provider "aws" {
  region = var.region
}