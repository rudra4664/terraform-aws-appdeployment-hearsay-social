output "instance_profile_name" {
  description = "Name of the green instance profile."
  value       = module.cloud_migration_green_instance_profile.aws_iam_instance_profile.name
}
