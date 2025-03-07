resource "aws_s3_bucket" "salesproject-datalake" {
  bucket = "salesproject-datalake"

  tags = {
    Name = "salesproject"
  }
}


resource "aws_s3_bucket" "salesproject-backup" {
  bucket = "salesproject-backup"

  tags = {
    Name = "salesproject"
  }
}