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

module "security_groups" {
  for_each = local.current_security_groups
  source   = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version  = "1.2.0"
  tf_org   = "NYL-PROD"
  appid    = var.appid
  tags     = var.tags

  security_group = {
    name        = var.security_group_names[var.env][each.key]
    description = each.value.description
    vpc_id      = data.aws_vpc.current.id
    ingress     = each.value.ingress
    egress      = each.value.egress
  }
}
