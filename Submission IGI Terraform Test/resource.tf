# A S3 bucket with private default ACL
resource "aws_s3_bucket" "test_bucket"{
  bucket = "${var.bucket_name}"
  region = "us-east-1"

  tags {
    Name = "sample.useast1"
    key = "environment"
    value = "${var.env}"
  }

  versioning {
    enabled = "${var.opt_versioning}"
  }

  logging {
    target_bucket = "${var.bucket_name}-logger"
    target_prefix = "log/"
  }
}

# A S3 bucket for logging purposes
resource "aws_s3_bucket" "test_bucket_logs"{
  bucket = "${var.bucket_name}-logger"
  acl = "log-delivery-write"
}

# IAM account user
resource "aws_iam_user" "user" {
  name = "testuser_${var.iam_username}"
}

# IAM  user access_keys
resource "aws_iam_access_key" "user_keys" {
  user = "${aws_iam_user.user.name}"
}

# S3 bucket policies to read and write
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.test_bucket.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "${aws_iam_user.user.arn}"
        },
        "Action": [ "s3:*" ],
        "Resource": [
          "${aws_s3_bucket.test_bucket.arn}",
          "${aws_s3_bucket.test_bucket.arn}/*"
        ]
      }
    ]
  }
  POLICY
}

# Redshift cluster depending on S3
resource "aws_redshift_cluster" "test_redshift" {
  cluster_identifier = "${var.redshift_test_cluster_name}"
  database_name = "${var.test_db_name}"
  master_username = "${var.REDSHIFT_USERNAME}"
  master_password = "${var.REDSHIFT_PASSWORD}"
  node_type = "${var.node_type}"
  cluster_type = "multi-node"
  number_of_nodes = "${var.numberofnodes_redshift}"
  port = "${var.redshift_port}"
  publicly_accessible = "false"
  depends_on = ["aws_s3_bucket.test_bucket"]

  tags {
    key                 = "environment"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  iam_roles = ["${var.redshift_iam_roles}"]
}

# Assigning VPC for Redshift cluster
resource "aws_vpc" "redshift_VPC_assigned" {
  cidr_block = "${var.redshift_cidr_range}"
}

# Assigning subnet for Redshift cluster
resource "aws_subnet" "test_redshift_subnet_a"{
  cidr_block = "${var.test_redshift_subnet_a}"
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.redshift_VPC_assigned.id}"

  tags{
    Name = "redshift-subnet-a"
  }
}

# List of all subnets associated with Redshift cluster
resource "aws_redshift_subnet_group" "test_redshift_subnet" {
  name = "test_redshift_subnet_group"
  subnet_ids = ["${aws_subnet.test_redshift_subnet_a.id}"]

  tags{
    environment = "test"
  }
}

# Security group for redshift cluster
resource "aws_security_group" "test_sg" {
  vpc_id = "${aws_vpc.redshift_VPC_assigned.id}"
}

# Inbound rules for redshift cluster
resource "aws_security_group_rule" "ingress_redshift"{
  type = "ingress"
  from_port = "${var.redshift_port}"
  to_port = "${var.redshift_port}"
  protocol = "tcp"
  cidr_blocks = ["${var.rs_sg_cidr}"]
  security_group_id = "${aws_security_group.test_sg.id}"
}
