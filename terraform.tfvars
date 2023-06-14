hackathon_project = "hackathon-team-1-388910"
main_region       = "europe-west1"
environment       = "staging"

kafka_image_name     = "packer-kafka-20230613191956"
zookeeper_image_name = "packer-zookeeper-20230613190418"

subnets = [
  {
    subnet_name           = "staging-subnet-01"
    subnet_cidr           = "10.0.101.0/24"
    subnet_region         = "europe-west1"
    subnet_private_access = "true"
  },
  {
    subnet_name           = "staging-subnet-02"
    subnet_cidr           = "10.0.102.0/24"
    subnet_region         = "europe-west4"
    subnet_private_access = "true"
  },
  {
    subnet_name           = "serverless-subnet"
    subnet_cidr           = "10.0.201.0/28"
    subnet_region         = "europe-west1"
    subnet_private_access = "true"
  },

]