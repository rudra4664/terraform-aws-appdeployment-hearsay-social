variable "appid" {
  description = "Application ID governance tag. Must begin with APP-."
  type        = string
}

variable "env" {
  description = "Environment (dev, qa, stage, prod or test)."
  type        = string
}

variable "green_instances" {
  description = "Green (OS-upgraded) instances to build in the current environment."

  type = map(object({
    availability_zone   = string
    instance_type       = string
    name                = string
    root_volume_size    = number
    root_volume_type    = string
    security_groups     = list(string)
    strategic_ami_build = string
    strategic_os_type   = string

    additional_volumes = map(object({
      device_name = string
      size        = number
      snapshot_id = optional(string)
      type        = string
    }))
  }))
}

variable "hearsay_cidrs" {
  description = "CIDRs for the hearsay rules, for the current environment."
  type        = set(string)
}

variable "hearsay_cidrs_2" {
  description = "CIDRs for the hearsay cidrs 2 rules, for the current environment."
  type        = set(string)
}

variable "hearsay_winrm_cidrs" {
  description = "CIDRs for the hearsay winrm rules, for the current environment."
  type        = set(string)
}

variable "hearsay_winrm_tls_cidrs" {
  description = "CIDRs for the hearsay winrm tls rules, for the current environment."
  type        = set(string)
}

variable "instance_profile_name" {
  description = "Name of the instance profile, provided by the global module."
  type        = string
}

variable "lob" {
  description = "Line of Business."
  type        = string
}

variable "tags" {
  description = "Application-specific tags merged on top of mandatory governance tags."
  type        = map(string)
}

variable "vpc_access_https_cidrs" {
  description = "CIDRs for the vpc access https rules, for the current environment."
  type        = set(string)
}
