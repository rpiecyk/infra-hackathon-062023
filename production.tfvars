# TBD
hackathon_project = "hackathon-team-1-388910"
main_region       = "europe-west4"
environment       = "production"

subnets = [
  {
    subnet_name           = "production-subnet-01"
    subnet_cidr           = "10.0.1.0/24"
    subnet_region         = "europe-west4"
    subnet_private_access = "true"
  },
  {
    subnet_name           = "production-subnet-02"
    subnet_cidr           = "10.0.2.0/24"
    subnet_region         = "europe-west"
    subnet_private_access = "true"
  },
  {
    subnet_name           = "production-subnet-03"
    subnet_cidr           = "10.0.3.0/24"
    subnet_region         = "europe-west4"
    subnet_private_access = "true"
  }
]