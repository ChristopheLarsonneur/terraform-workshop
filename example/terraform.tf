terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-3"
}

provider "aws" {
  alias = "aws-eu-west-1"
  region = "eu-west-1"
}

/* Example

resource "aws_instance" "web" {
  instance_type="t2.micro"
  ami = "ami-008bee6a174790b72"
  tags = {
    Name = "HelloWorld"
  }
}

*/