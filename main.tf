# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node
provider "aws" {
  region = "${var.aws_region}"
}

locals {
  s3arn = "${aws_s3_bucket.s3codelehman.arn}"
user_data = <<EOT
#!/usr/bin/env bash
set -x
apt-get install -y apache2
while [ ! -f /tmp/payload.tar.gz ] ; do sleep 5 ; done
tar -C /var/www/html -xvzf /tmp/payload.tar.gz
service apache2 restart
(echo '* * * * * /var/www/html/rotate_image.sh') | crontab -
  EOT
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                     = "${var.ami}"
  instance_type           = "t2.micro"
  key_name                = "${var.key_name}"
  subnet_id               = "${var.subnet_id}"
  security_groups         = ["${aws_security_group.security_group.id}"]
  tags                    = "${var.tags}"
  user_data               = "${base64encode(local.user_data)}"
  provisioner "file" {
  source      = "files/payload.tar.gz"
  destination = "/tmp/payload.tar.gz"
  connection {
    host        = "${aws_instance.web.public_ip}" # <---
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("files/${var.private_key}")}"
    }
  }
}

resource "aws_security_group" "security_group" {
  name              = "${var.sg_name}"
  description       = "Security groups for the server Code Challenge"
  vpc_id            = "${var.vpc_id}"
  tags              = {
    Name            = "${var.sg_name}"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Defining the IAM Policy
resource "aws_iam_policy" "iam_policy" {
  name = "${var.iam_policy_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:get*"
      ],
      "Resource": "${local.s3arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "iam_role" {
  name = "${var.iam_role_name}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "iam_attach_policy" {
  name       = "${var.iam_resource_name}"
  roles      = ["${aws_iam_role.iam_role.name}"]
  policy_arn = "${aws_iam_policy.iam_policy.arn}"
}

resource "aws_iam_instance_profile" "code-profile" {
  name  = "code-profile"
  role = "${aws_iam_role.iam_role.name}"
}

resource "aws_s3_bucket" "s3codelehman" {
  bucket = "code-lehman-code-lehman"
  acl = "public-read"
  versioning {
    enabled = true
  }
  tags                    = "${var.s3_tags}"

}
