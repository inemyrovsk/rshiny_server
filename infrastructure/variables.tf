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
  default = "ami-02584c1c9d05efa69"
}

variable "docker_image_tag" {
  type = string
  description = "default docker image tag"
  default = "latest"
}
variable "docker_image_tag_shiny" {
  type = string
  description = "default docker image tag"
  default = "latest"
}