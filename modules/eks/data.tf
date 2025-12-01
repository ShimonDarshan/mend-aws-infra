# Data sources for account and region information
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}
