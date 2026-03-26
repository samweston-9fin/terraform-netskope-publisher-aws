terraform {
  required_providers {
    netskope = {
      version = "~> 0.3.0"
      source  = "netskopeoss/netskope"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.0"
    }
  }
  required_version = ">= 1.14.0"
}
