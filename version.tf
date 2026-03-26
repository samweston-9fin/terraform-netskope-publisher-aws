terraform {
  required_providers {
    netskope = {
      version = "~> 0.3.2"
      source  = "netskopeoss/netskope"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.1"
    }
  }
  required_version = ">= 1.14.0"
}
