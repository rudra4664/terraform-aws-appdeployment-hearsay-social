moved {
  from = module.cyberark_instance_access_sg_v2
  to   = module.security_groups["cyberark_instance_access"]
}

moved {
  from = module.hearsay_instance_access_sg_v2
  to   = module.security_groups["hearsay_instance_access"]
}

moved {
  from = module.onprem_win_access_sg_v2[0]
  to   = module.security_groups["onprem_win_access"]
}

moved {
  from = module.outbound_access_sg_v2[0]
  to   = module.security_groups["outbound_access"]
}

moved {
  from = module.vpc_access_sg_v2
  to   = module.security_groups["vpc_access"]
}
