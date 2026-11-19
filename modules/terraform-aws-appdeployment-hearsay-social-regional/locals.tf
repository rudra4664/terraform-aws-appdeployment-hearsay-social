locals {
  subnet_ids_by_az = { for subnet in data.aws_subnet.compute : subnet.availability_zone => subnet.id }
  vpc_cidrs        = data.aws_vpc.current.cidr_block_associations[*].cidr_block

  requested_security_groups = toset(flatten([for instance in values(var.green_instances) : instance.security_groups]))

  security_group_ids = {
    cyberark_instance_access = module.cyberark_instance_access_sg.resources.aws_security_group.id
    hearsay_instance_access  = module.hearsay_instance_access_sg.resources.aws_security_group.id
    onprem_win_access        = one(module.onprem_win_access_sg[*].resources.aws_security_group.id)
    outbound_access          = one(module.outbound_access_sg[*].resources.aws_security_group.id)
    vpc_access               = module.vpc_access_sg.resources.aws_security_group.id
  }

  cyberark_cidrs = [
    "10.41.16.148/32",
    "10.41.24.199/32",
    "10.6.0.0/19",
    "10.7.0.0/19",
    "10.73.17.67/32",
    "10.73.24.117/32",
  ]

  cyberark_rdp_cidrs = [
    "10.162.32.230/32",
    "10.162.32.231/32",
    "10.184.6.0/24",
    "10.186.29.0/24",
    "10.188.29.0/24",
    "10.41.16.143/32",
    "10.41.16.144/32",
    "10.41.16.145/32",
    "10.41.16.148/32",
    "10.41.16.53/32",
    "10.41.16.55/32",
    "10.41.20.47/32",
    "10.41.20.48/32",
    "10.41.24.198/32",
    "10.41.24.199/32",
    "10.41.28.41/32",
    "10.6.0.0/19",
    "10.7.0.0/19",
    "10.73.16.103/32",
    "10.73.17.38/32",
    "10.73.17.59/32",
    "10.73.17.60/32",
    "10.73.17.61/32",
    "10.73.17.67/32",
    "10.73.20.100/32",
    "10.73.20.99/32",
    "10.73.24.116/32",
    "10.73.24.117/32",
    "10.73.28.21/32",
    "10.73.32.19/32",
    "10.73.32.30/32",
    "10.73.36.33/32",
  ]

  shared_cidrs = [
    "10.0.0.0/8",
  ]

  vpc_access_ingress_rules = {
    all-traffic = {
      protocol    = "-1"
      from_port   = null
      to_port     = null
      description = "All traffic within VPC CIDR"
      cidrs       = local.vpc_cidrs
    }

    https = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      description = "Harness CIDR"
      cidrs       = var.vpc_access_https_cidrs
    }
  }

  onprem_win_access_ingress_rules = {
    rdp = {
      protocol    = "tcp"
      from_port   = 3389
      to_port     = 3389
      description = "RDP from 10.0.0.0/8 for Windows remote access"
      cidrs       = local.shared_cidrs
    }

    winrm = {
      protocol    = "tcp"
      from_port   = 5985
      to_port     = 5985
      description = "WinRM over HTTP from 10.0.0.0/8 for Windows remote management"
      cidrs       = local.shared_cidrs
    }

    winrm-tls = {
      protocol    = "tcp"
      from_port   = 5986
      to_port     = 5986
      description = "WinRM over HTTPS from 10.0.0.0/8 for Windows remote management"
      cidrs       = local.shared_cidrs
    }
  }

  outbound_access_ingress_rules = {
    icmp--1 = {
      protocol    = "icmp"
      from_port   = -1
      to_port     = -1
      description = "Allow all inbound ICMP types from 10.0.0.0/8"
      cidrs       = local.shared_cidrs
    }

    rdp = {
      protocol    = "tcp"
      from_port   = 3389
      to_port     = 3389
      description = "RDP from 10.0.0.0/8 for Windows remote access"
      cidrs       = local.shared_cidrs
    }
  }

  cyberark_ingress_rules = {
    rdp = {
      protocol    = "tcp"
      from_port   = 3389
      to_port     = 3389
      description = "RDP from the configured CyberArk RDP CIDRs"
      cidrs       = local.cyberark_rdp_cidrs
    }

    rpc = {
      protocol    = "tcp"
      from_port   = 135
      to_port     = 135
      description = "Windows RPC endpoint mapper access from CyberArk CIDRs"
      cidrs       = local.cyberark_cidrs
    }

    rpc-high = {
      protocol    = "tcp"
      from_port   = 1024
      to_port     = 65535
      description = "Windows RPC dynamic port access from CyberArk CIDRs"
      cidrs       = local.cyberark_cidrs
    }

    smb = {
      protocol    = "tcp"
      from_port   = 445
      to_port     = 445
      description = "SMB access from CyberArk CIDRs"
      cidrs       = local.cyberark_cidrs
    }
  }

  hearsay_ingress_rules = {
    app-7520 = {
      protocol    = "tcp"
      from_port   = 7520
      to_port     = 7520
      description = "Hearsay application traffic on TCP 7520 from configured Hearsay CIDRs"
      cidrs       = var.hearsay_cidrs
    }

    app-8000 = {
      protocol    = "tcp"
      from_port   = 8000
      to_port     = 8000
      description = "Hearsay application traffic on TCP 8000 from configured Hearsay CIDRs"
      cidrs       = var.hearsay_cidrs
    }

    app-8005 = {
      protocol    = "tcp"
      from_port   = 8005
      to_port     = 8005
      description = "Hearsay application traffic on TCP 8005 from configured Hearsay CIDRs"
      cidrs       = var.hearsay_cidrs
    }

    https = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      description = "HTTPS access from configured Hearsay CIDRs"
      cidrs       = var.hearsay_cidrs_2
    }

    ssh = {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      description = "SSH access from configured Hearsay CIDRs"
      cidrs       = var.hearsay_cidrs_2
    }

    winrm = {
      protocol    = "tcp"
      from_port   = 5985
      to_port     = 5985
      description = "WinRM over HTTP from configured Hearsay WinRM CIDRs"
      cidrs       = var.hearsay_winrm_cidrs
    }

    winrm-tls = {
      protocol    = "tcp"
      from_port   = 5986
      to_port     = 5986
      description = "WinRM over HTTPS from configured Hearsay WinRM TLS CIDRs"
      cidrs       = var.hearsay_winrm_tls_cidrs
    }
  }

  vpc_access_ingress = merge([
    for key, rule in local.vpc_access_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)

  onprem_win_access_ingress = merge([
    for key, rule in local.onprem_win_access_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)

  outbound_access_ingress = merge([
    for key, rule in local.outbound_access_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)

  cyberark_ingress = merge([
    for key, rule in local.cyberark_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)

  hearsay_ingress = merge([
    for key, rule in local.hearsay_ingress_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        description = rule.description
        ip_protocol = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)
}
