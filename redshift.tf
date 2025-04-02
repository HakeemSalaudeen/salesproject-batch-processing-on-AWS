resource "aws_secretsmanager_secret" "salesproject-redshiftcredentials" {
  name = "salesproject-redshift/admin-credentials"
}

resource "aws_secretsmanager_secret_version" "redshift_credentials" {
  secret_id = aws_secretsmanager_secret.salesproject-redshiftcredentials.id
  secret_string = jsonencode({
    username = var.salesprojectredshift-username
    password = var.salesprojectredshift-password
  })
}

resource "aws_redshiftserverless_namespace" "salesproject-dw" {
  namespace_name      = "salesproject-dw"
  admin_username      = jsondecode(aws_secretsmanager_secret_version.redshift_credentials.secret_string)["username"]
  admin_user_password = jsondecode(aws_secretsmanager_secret_version.redshift_credentials.secret_string)["password"]
  db_name             = "salesproject"
}

resource "aws_redshiftserverless_workgroup" "salesproject-workgroup" {
  namespace_name     = aws_redshiftserverless_namespace.salesproject-dw.namespace_name
  workgroup_name     = "salesproject"
  subnet_ids         = aws_redshift_subnet_group.salesproject-redshift-subnet-group.subnet_ids
  security_group_ids = [aws_security_group.salesproject-redshift-sg.id]

  base_capacity = 8

  enhanced_vpc_routing = true
  publicly_accessible  = false
}


