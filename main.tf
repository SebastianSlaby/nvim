terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.0"
    }
  }
}



provider "aws" {
  access_key = "AWS ACCESS KEY"
  secret_key = "AWS SECRET KEY"
  region     = "AWS REGION"
}

resource "aws_alb_listener" "name" {
}

