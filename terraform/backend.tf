
terraform {
  backend "s3" {
    bucket       = "cloudops-portal-terraform-state-706421610833"
    key          = "cloudops/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
