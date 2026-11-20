terraform {

  # Setup for storage of state in s3 bucket
  # (have to be in the root module)
  backend "s3" {
    bucket  = "terraform-state-687285458549-eu-north-1-an"
    key     = "terraform-state-687285458549-eu-north-1-an/dev/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}