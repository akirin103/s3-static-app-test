terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  tags = {
    SystemName  = var.system_name
    Environment = var.env
  }
}
