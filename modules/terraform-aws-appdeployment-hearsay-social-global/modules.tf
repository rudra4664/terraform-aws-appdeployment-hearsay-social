module "cloud_migration_green_instance_profile" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-instance-profile-windows"
  version = "1.2.0"
  tf_org  = "NYL-PROD"
  lob     = var.lob
  env     = var.env
  name    = "cloud-migration-green"
}
