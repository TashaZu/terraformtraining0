provider "aws" {
  profile = "default"
  region = "us-west-2"
  }

resource "aws_s3_bucket" "tf_course" {
  bucket = "tfs3-tasha-20201103"
  acl = "private"
}


