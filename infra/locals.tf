# locals.tf

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = var.manager
  }

  all_ipv4_cidr = "0.0.0.0/0"
  all_protocols = "-1"
  any_port      = 0
  tcp_protocol  = "tcp"
  https_port    = 443
}
