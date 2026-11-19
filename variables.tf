variable "appid" {
  description = "Application ID governance tag. Must begin with APP-."
  type        = string
  default     = "APP-870"
}

variable "env" {
  description = "Environment (dev, qa, stage, prod or test)."
  type        = string
}

variable "green_instances" {
  description = "Green (OS-upgraded) instances to build, by environment."

  type = map(map(object({
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
  })))

  default = {
    stage = {}

    dev = { # nyl-clientprosvs-dev (073678946889)
      ap31d0163 = {
        availability_zone   = "us-east-1a"
        instance_type       = "t3.medium"
        name                = "ap31d0163-green"
        root_volume_size    = 75
        root_volume_type    = "gp3"
        security_groups     = ["cyberark_instance_access", "hearsay_instance_access", "onprem_win_access", "vpc_access"]
        strategic_ami_build = "PROD"
        strategic_os_type   = "NYL Microsoft Windows Server 2025"

        additional_volumes = {
          sdb = {
            device_name = "/dev/sdb"
            size        = 150
            snapshot_id = "snap-0f67042cbdd7a88ff"
            type        = "gp3"
          }
        }
      }
    }

    qa = { # nyl-clientprosvs-qa (631186050369)
      ap31m0072 = {
        availability_zone   = "us-east-1a"
        instance_type       = "m5.large"
        name                = "ap31m0072-green"
        root_volume_size    = 95
        root_volume_type    = "gp3"
        security_groups     = ["cyberark_instance_access", "hearsay_instance_access", "outbound_access", "vpc_access"]
        strategic_ami_build = "PROD"
        strategic_os_type   = "NYL Microsoft Windows Server 2025"

        additional_volumes = {
          sdb = {
            device_name = "/dev/sdb"
            size        = 150
            snapshot_id = "snap-07170e3747f65f0e1"
            type        = "gp3"
          }
        }
      }
    }

    prod = { # nyl-clientprosvs-prod (211125733068)
      ap31p0252 = {
        availability_zone   = "us-east-1a"
        instance_type       = "m5.large"
        name                = "ap31p0252-green"
        root_volume_size    = 75
        root_volume_type    = "gp3"
        security_groups     = ["cyberark_instance_access", "hearsay_instance_access", "vpc_access"]
        strategic_ami_build = "PROD"
        strategic_os_type   = "NYL Microsoft Windows Server 2025"

        additional_volumes = {
          sdb = {
            device_name = "/dev/sdb"
            size        = 150
            snapshot_id = null # (snapshot ID of the existing /dev/sdb volume)
            type        = "gp3"
          }
        }
      }
    }
  }
}

variable "hearsay_cidrs" {
  description = "CIDRs for the hearsay rules, by environment."
  type        = map(set(string))

  default = {
    qa = []

    dev = [
      "10.13.13.10/32",
      "10.13.13.110/32",
      "10.13.13.114/32",
      "10.13.13.134/32",
      "10.13.13.138/32",
      "10.13.13.14/32",
      "10.13.13.142/32",
      "10.13.13.226/32",
      "10.13.8.34/32",
      "10.13.8.38/32",
      "10.13.8.42/32",
      "10.13.8.46/32",
      "10.13.8.50/32",
      "10.13.8.54/32",
      "10.34.30.0/23",
      "10.40.84.177/32",
      "10.40.84.178/32",
      "10.47.253.130/32",
      "10.47.253.138/32",
      "10.47.253.144/32",
      "10.47.253.149/32",
      "10.47.253.158/32",
      "10.47.253.160/32",
      "10.47.253.163/32",
      "10.47.253.208/32",
      "10.47.253.215/32",
      "10.47.253.216/32",
      "10.47.253.240/32",
      "10.47.253.28/32",
      "10.47.254.145/32",
      "10.47.254.162/32",
      "10.47.254.53/32",
      "10.47.254.57/32",
      "10.47.254.78/32",
      "10.47.254.87/32",
      "10.47.255.121/32",
      "10.47.255.140/32",
      "10.47.255.149/32",
      "10.47.255.157/32",
      "10.47.255.161/32",
      "10.47.255.25/32",
      "10.47.255.83/32",
      "10.7.223.24/32",
      "10.7.223.25/32",
      "10.72.84.27/32",
      "10.72.84.28/32",
    ]

    prod = [
      "10.13.13.10/32",
      "10.13.13.110/32",
      "10.13.13.114/32",
      "10.13.13.134/32",
      "10.13.13.138/32",
      "10.13.13.14/32",
      "10.13.13.142/32",
      "10.13.13.226/32",
      "10.13.8.34/32",
      "10.13.8.38/32",
      "10.13.8.42/32",
      "10.13.8.46/32",
      "10.13.8.50/32",
      "10.13.8.54/32",
      "10.34.30.0/23",
      "10.40.84.177/32",
      "10.40.84.178/32",
      "10.47.253.130/32",
      "10.47.253.138/32",
      "10.47.253.144/32",
      "10.47.253.149/32",
      "10.47.253.158/32",
      "10.47.253.160/32",
      "10.47.253.163/32",
      "10.47.253.208/32",
      "10.47.253.215/32",
      "10.47.253.216/32",
      "10.47.253.240/32",
      "10.47.253.28/32",
      "10.47.254.145/32",
      "10.47.254.162/32",
      "10.47.254.53/32",
      "10.47.254.57/32",
      "10.47.254.78/32",
      "10.47.254.87/32",
      "10.47.255.121/32",
      "10.47.255.140/32",
      "10.47.255.149/32",
      "10.47.255.157/32",
      "10.47.255.161/32",
      "10.47.255.25/32",
      "10.47.255.83/32",
      "10.7.223.24/32",
      "10.7.223.25/32",
      "10.72.84.27/32",
      "10.72.84.28/32",
    ]
  }
}

variable "hearsay_cidrs_2" {
  description = "CIDRs for the hearsay cidrs 2 rules, by environment."
  type        = map(set(string))

  default = {
    dev  = ["10.41.32.26/32"]
    qa   = ["10.186.19.0/24", "10.41.24.47/32"]
    prod = []
  }
}

variable "hearsay_winrm_cidrs" {
  description = "CIDRs for the hearsay winrm rules, by environment."
  type        = map(set(string))

  default = {
    dev  = ["10.41.32.26/32"]
    qa   = ["10.186.19.0/24", "10.41.24.47/32"]
    prod = ["10.186.19.0/24", "10.234.46.0/23"]
  }
}

variable "hearsay_winrm_tls_cidrs" {
  description = "CIDRs for the hearsay winrm tls rules, by environment."
  type        = map(set(string))

  default = {
    dev  = ["10.41.32.26/32"]
    qa   = ["10.186.19.0/24", "10.41.24.47/32"]
    prod = ["10.186.19.0/24"]
  }
}

variable "lob" {
  description = "Line of Business."
  type        = string
  default     = "clientprosvs"
}

variable "tags" {
  description = "Application-specific tags merged on top of mandatory governance tags."
  type        = map(string)
}

variable "vpc_access_https_cidrs" {
  description = "CIDRs for the vpc access https rules, by environment."
  type        = map(set(string))

  default = {
    dev  = ["10.233.46.0/23"]
    qa   = []
    prod = []
  }
}
