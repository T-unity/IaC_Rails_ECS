# enter your app name
variable "app_name" {
  default = "WIP"
}

terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

### プロバイダー
provider "aws" {
  region  = "ap-northeast-1"
}

### Cloudwatch Logs
resource "aws_s3_bucket" "sample_alb_logs" {
  bucket = "${var.app_name}-alb-logs"
}
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/app/logs"
}

### VPC
resource "aws_vpc" "base_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-VPC"
  }
}

### インターネットゲートウェイ
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.base_vpc.id

  tags = {
    Name = "${var.app_name}-IGW"
  }
}

### subnet
# public 1a
resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.base_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-1a"
  }
}
# public 1c
resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.base_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-1c"
  }
}
