terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}
resource "random_pet" "this" {}

resource "aws_iam_user" "lb" {
  count = 3
  name  = "${random_pet.this.id}-${var.org-name}-${count.index}"
}

import {
  to = aws_iam_user.lb[0]
  id = "trusting-camel-kplabs-0"
}

import {
  to = aws_iam_user.lb[1]
  id = "trusting-camel-kplabs-1"
}

import {
  to = aws_iam_user.lb[2]
  id = "trusting-camel-kplabs-2"
}

# This policy must be associated with all IAM users created through this code.

resource "aws_iam_user_policy" "lb_ro" {
  count = 3
  name  = "ec2-describe-policy-${count.index}"
  user  = aws_iam_user.lb[count.index].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_s3_bucket" "example" {
  for_each = toset(var.s3_buckets)
  bucket   = "${random_pet.this.id}-${each.value}"
}

import {
  to = aws_s3_bucket.example["kplabs-1"]
  id = "trusting-camel-kplabs-1"
}

import {
  to = aws_s3_bucket.example["kplabs-2"]
  id = "trusting-camel-kplabs-2"
}


resource "aws_s3_object" "object" {
  for_each = toset(var.s3_buckets)
  bucket   = aws_s3_bucket.example[each.key].id
  key      = var.s3_base_object
}

resource "aws_security_group" "example" {
  name = var.sg_name
}

import {
  to = aws_security_group.example
  id = "sg-04d947f344404324b"
}


resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.example.id

  cidr_ipv4   = "10.0.0.0/8"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

import {
  to = aws_vpc_security_group_ingress_rule.example
  id = "sgr-0145528e5e9c65cc1"
}
