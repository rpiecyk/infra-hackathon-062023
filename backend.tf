terraform {
  backend "gcs" {
    bucket = "state-bucket-hackathon-team-1-388910"
    prefix = "terraform/state"
  }
}
