# User credentials that are fetched from tfvars file (not included in the submission)
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}

# S3 bucket Variables
variable "bucket_name" {}
variable "env" {}
variable "opt_versioning" {
  default = false
}

# IAM Variables
variable "iam_username" {}

# Redshift Variables
variable "redshift_test_cluster_name" {}
variable "test_db_name" {}
variable "REDSHIFT_USERNAME" {}
variable "REDSHIFT_PASSWORD" {}
variable "node_type" {
  default = "dc2.large"
}
variable "numberofnodes_redshift" {}
variable "redshift_port" {
  default = 5439
}

# List all IAM roles associated with Redshift cluster
variable "redshift_iam_roles" {
  type = "list"
  default = []
}

variable "redshift_vpc" {}

variable "subnets" {
  type = "list"
}

variable "redshift_cidr_range"{
  type = "list"
}

variable "test_redshift_subnet_a"{
  type = "list"
}

variable "rs_sg_cidr" {}
