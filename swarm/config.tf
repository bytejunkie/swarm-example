terraform {
  backend "s3" {
    bucket = "byt-terraform-state-bucket"
    key    = "cloudskiff-tfstate/swarm-example.tfstate"
    region = "eu-west-2"
  }
}