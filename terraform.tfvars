aws_region              = "us-east-1"
aws_profile             = "dev"
allocated_storage       = "40"
instance_class          = "t2.small"
storage_type            = "gp2"
vpc_id                  = "*****************"
subnet_group            = ""
subnet_id               = "*****************"
allowed_cidr_blocks     = [""]
disable_api_termination = "true"
key_name                = "*******"
private_key             = "************"
availability_zone       = "us-east-2a"
private_ip              = ""
hostname                = ""
fqdn                    = ""
domain_name             = ""
salt_master             = ""
sg_name                 = "sgcode"
iam_policy_name         = "policycode"
iam_role_name           = "rolecode"
iam_resource_name       = "code"
dns_zone_id             = ""
dns_ptr_record          = ""
dns_ptr_zone_id         = ""
ami                     = "ami-0cb0e9fe779689eb3"

tags                    = {
    business-function       = "Code Challenge"
    project                 = "Code"
    application_name        = "Code"
    department              = "engineering"
    team                    = "Infastructure"
    status                  = "development"
    Name                    = "Code"
}
s3_tags               = {
    Name                =
  }
}
