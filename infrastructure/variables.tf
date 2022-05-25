variable "region" {
  type        = string
  description = "AWS region."
  default = "eu-central-1"
}

variable "env" {
  type = string
  description = "infrastructure environment"
  default = "dev"
}

variable "ami_for_cluster" {
  type = string
  description = "ami image for launching instances"
  default = "ami-004f5de8d7e98daf3" #ami-003916df34ebf74d4
}

variable "docker_image_tag" {
  type = string
  description = "default docker image tag"
  default = "latest"
}