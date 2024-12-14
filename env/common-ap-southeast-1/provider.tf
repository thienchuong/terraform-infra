terraform { 
  cloud { 
    organization = "toni-assignment" 
    workspaces { 
      name = "common-ap-southeast-1" 
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
}


provider "aws" {
  region = "ap-southeast-1"
}
