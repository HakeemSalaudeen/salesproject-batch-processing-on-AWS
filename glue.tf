resource "aws_glue_catalog_database" "salesproject-Database" {
  name = "salesproject-database"
}

resource "aws_glue_crawler" "salesproject-crawler" {
  database_name = aws_glue_catalog_database.salesproject-Database.arn
  name          = "salesproject-crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.salesproject-datalake.bucket}"
  }

}

resource "aws_glue_connection" "salesproject-redshift-connection" {
  name            = "Redshift-salesproject-connection-v4"
  connection_type = "JDBC"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:redshift://${aws_redshiftserverless_workgroup.salesproject-workgroup.endpoint[0].address}:5439/salesproject"
    PASSWORD            = jsondecode(aws_secretsmanager_secret_version.redshift_credentials.secret_string)["password"]
    USERNAME            = jsondecode(aws_secretsmanager_secret_version.redshift_credentials.secret_string)["username"]
  }

  physical_connection_requirements {
    availability_zone      = aws_subnet.salesproject-privatesubnet-a.availability_zone
    subnet_id              = aws_subnet.salesproject-privatesubnet-a.id
    security_group_id_list = [aws_security_group.salesproject-redshift-sg.id]
  }
}
