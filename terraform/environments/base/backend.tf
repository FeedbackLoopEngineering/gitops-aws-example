terraform {
  backend "s3" {
    # Configure via backend config file or CLI args:
    #   bucket         = "my-terraform-state"
    #   key            = "gitops-example/base.tfstate"
    #   region         = "us-east-1"
    #   dynamodb_table = "terraform-locks"
    #   encrypt        = true
  }
}
