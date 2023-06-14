variable "project_id" {
  description = "The ID of the project where subnets will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network for subnets"
  type        = string
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets with parameters"
}
