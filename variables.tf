variable "main_region" {
  type        = string
  default     = ""
  description = "Used region for development env."
}

variable "hackathon_project" {
  type        = string
  default     = ""
  description = "Used project for Hackathon env."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "zookeeper_image_name" {
  type        = string
  description = "Base image for zookeeper deployed by Packer"
}

variable "kafka_image_name" {
  type        = string
  description = "Base image for kafka deployed by Packer"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of project's subnets params."
}