variable "aws_region" {
  type = "string"
}

variable "aws_profile" {
  type = "string"
}

variable "allocated_storage" {
  type = "string"
}

variable "instance_class" {
  type = "string"
}

variable "storage_type" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "subnet_group" {
  type = "string"
}

variable "subnet_id" {
  type = "string"
}

variable "allowed_cidr_blocks" {
  type = "list"
}

variable "disable_api_termination" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "availability_zone" {
  type = "string"
}

variable "private_ip" {
  type = "string"
}

variable "hostname" {
  type = "string"
}

variable "fqdn" {
  type = "string"
}

variable "sg_name" {
  type = "string"
}

variable "iam_policy_name" {
  type = "string"
}

variable "iam_role_name" {
  type = "string"
}

variable "iam_resource_name" {
  type = "string"
}

variable "dns_zone_id" {
  type = "string"
}

variable "dns_ptr_record" {
  type = "string"
}

variable "dns_ptr_zone_id" {
  type = "string"
}

variable "ami" {
  type = "string"
}

variable "salt_master" {
  type = "string"
}

variable "domain_name" {
  type = "string"
}

variable "tags" {
  type = "map"
}

variable "s3_tags" {
  type = "map"
}
