# S3 bucket ARN
output "bucket_arn" {
  value = "${aws_s3_bucket.test_bucket.arn}"
}

# Endpoint of the Redshift cluster
output "redshift_cluster_endpoint" {
  value = "${aws_redshift_cluster.test_redshift.endpoint}"
}

# Redshift Cluster ID
output "redshift_cluster_id" {
  value = "${aws_redshift_cluster.test_redshift.id}"
}
