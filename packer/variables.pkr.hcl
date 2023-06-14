variable "hackathon_project" {
  type    = string
  default = "my-project"
}

variable "zone" {
  type    = string
  default = "euroipe-west4-"
}

variable "builder_sa" {
  type    = string
  default = "packer@my-project.iam.gserviceaccount.com"
}
