module "green_instances" {
  for_each           = var.green_instances
  source             = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-ec2-instance"
  version            = "1.2.0"
  tf_org             = "NYL-PROD"
  appid              = var.appid
  env                = var.env
  lob                = var.lob
  kms_key_id         = data.aws_kms_alias.default.arn
  additional_volumes = each.value.additional_volumes

  tags = merge(var.tags, {
    Name                  = each.value.name
    TerraformResourceName = each.value.name
  })

  instance = {
    iam_instance_profile = var.instance_profile_name
    instance_type        = each.value.instance_type
    monitoring           = false
    name                 = each.value.name
    strategic_ami_build  = each.value.strategic_ami_build
    strategic_os_type    = each.value.strategic_os_type

    root_volume = {
      size = each.value.root_volume_size
      type = each.value.root_volume_type
    }
  }

  network = {
    security_group_ids = toset([for sg in each.value.security_groups : local.security_group_ids[sg]])
    subnet_id          = local.subnet_ids_by_az[each.value.availability_zone]
  }
}

module "vpc_access_sg" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.2.0"
  tf_org  = "NYL-PROD"
  appid   = var.appid
  tags    = var.tags

  security_group = {
    name        = "nyl-${var.lob}-${var.env}-vpc-access-sg-green"
    description = "Allows access between resources within VPC CIDR"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.vpc_access_ingress

    egress = {
      all-outbound = {
        description = "All outbound"
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }
}

module "onprem_win_access_sg" {
  count   = contains(local.requested_security_groups, "onprem_win_access") ? 1 : 0
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.2.0"
  tf_org  = "NYL-PROD"
  appid   = var.appid
  tags    = var.tags

  security_group = {
    name        = "nyl-${var.lob}-${var.env}-onprem-win-access-sg-green"
    description = "Allow 3389 port to Onprem cidr range for connecting to servers from VDA/VDZ"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.onprem_win_access_ingress
    egress      = {}
  }
}

module "outbound_access_sg" {
  count   = contains(local.requested_security_groups, "outbound_access") ? 1 : 0
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.2.0"
  tf_org  = "NYL-PROD"
  appid   = var.appid
  tags    = var.tags

  security_group = {
    name        = "nyl-${var.lob}-${var.env}-outbound-access-sg-green"
    description = "This has only Oubtbound Rule on all traffic"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.outbound_access_ingress

    egress = {
      all-outbound = {
        description = "All outbound"
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }
}

module "cyberark_instance_access_sg" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.2.0"
  tf_org  = "NYL-PROD"
  appid   = var.appid
  tags    = var.tags

  security_group = {
    name        = "nyl-${var.lob}-${var.env}-cyberark-instance-access-sg-green"
    description = "Cyberark SG to allow few ports for cyberark access"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.cyberark_ingress
    egress      = {}
  }
}

module "hearsay_instance_access_sg" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.2.0"
  tf_org  = "NYL-PROD"
  appid   = var.appid
  tags    = var.tags

  security_group = {
    name        = "nyl-${var.lob}-${var.env}-hearsay-instance-access-sg-green"
    description = "SG for hearsay application"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.hearsay_ingress
    egress      = {}
  }
}
