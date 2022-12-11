terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #  Lock version to prevent unexpected problems
      version = "4.38.0"
    }
  }
}