module "global" {
  source = "./modules/terraform-aws-global"
  env    = var.env
  lob    = var.lob

  providers = {
    aws = aws.us-east-1
  }
}

module "regional_us_east_1" {
  source                  = "./modules/terraform-aws-regional"
  appid                   = var.appid
  env                     = var.env
  green_instances         = var.green_instances[var.env]
  hearsay_cidrs           = var.hearsay_cidrs[var.env]
  hearsay_cidrs_2         = var.hearsay_cidrs_2[var.env]
  hearsay_winrm_cidrs     = var.hearsay_winrm_cidrs[var.env]
  hearsay_winrm_tls_cidrs = var.hearsay_winrm_tls_cidrs[var.env]
  instance_profile_name   = module.global.instance_profile_name
  lob                     = var.lob
  security_group_names    = var.security_group_names
  tags                    = var.tags
  vpc_access_https_cidrs  = var.vpc_access_https_cidrs[var.env]

  providers = {
    aws = aws.us-east-1
  }
}
