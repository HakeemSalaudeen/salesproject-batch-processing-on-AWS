data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#create iam role for glue 
resource "aws_iam_role" "glue_role" {
  name               = "glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

data "aws_iam_policy_document" "glue_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:ListBucket",
    "s3:GetBucketLocation"]
    resources = ["${aws_s3_bucket.salesproject-datalake.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "redshift:BatchInsert",
      "redshift:GetClusterCredentials",
      "redshift:DescribeClusters",
    "redshift:ExecuteStatement"]
    resources = ["${aws_redshiftserverless_namespace.salesproject-dw.arn}"]
  }

  statement {
    effect = "Allow"
    actions = [
    "secretsmanager:GetSecretValue"]
    resources = ["${aws_secretsmanager_secret.salesproject-redshiftcredentials.arn}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:GetDatabase"
    ]
    resources = ["${aws_glue_catalog_database.salesproject-Database.arn}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DescribeNetworkInterfaces"
    ]
    resources = ["*"]
  }
}


## iam policy
resource "aws_iam_policy" "glue-policy" {
  name        = "glue-policy"
  description = "policy for glue to assume role"
  policy      = data.aws_iam_policy_document.glue_policy.json
}


#role attachment
resource "aws_iam_role_policy_attachment" "glue-attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue-policy.arn
}

