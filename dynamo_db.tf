locals {

  newbits = trim(var.gp_pool_subnet_mask, "/") - split("/", var.gp_pool_supernet_cidr_range_ipv4)[1]

  # Prep entries for GP gateway table
  # gateway_map = flatten([
  #   # for i in range(42) :
  #   for i in range(local.newbits) :
  #   [for j in range(length(var.availability_zones)) : {
  #     Hostname       = format(var.gp_gateway_hostname_template, i + 1, element(var.suffix_map, j))
  #     DNSPrefix      = "gw-${lower(element(var.suffix_map, j))}${format("%02d", i + 1)}"
  #     AZ             = element(var.availability_zones, j)
  #     ClientPoolIPv4 = cidrsubnet(var.gp_pool_supernet_cidr_range_ipv4, local.newbits, (i * length(var.availability_zones)) + j + var.subnets_to_skip)
  #     ClientPoolIPv6 = ""
  #     # ClientPoolIPv6 = cidrsubnet("2a0d:9b84:100::/56", 8, (i * length(var.availability_zones)) + j + 10)
  #     GP_TUNNEL_IP = split("/", cidrsubnet(var.gp_pool_supernet_cidr_range_ipv4, local.newbits, (i * length(var.availability_zones)) + j + var.subnets_to_skip))[0]
  #   }]
  # ])
  gateway_map = [for i in pow(2, local.newbits) : {
    Hostname       = ""
    DNSPrefix      = ""
    AZ             = ""
    ClientPoolIPv4 = cidrsubnet(var.gp_pool_supernet_cidr_range_ipv4, local.newbits, i)
    ClientPoolIPv6 = ""
    GP_TUNNEL_IP   = split("/", cidrsubnet(var.gp_pool_supernet_cidr_range_ipv4, local.newbits, i))[0]
  }]

}

resource "aws_dynamodb_table" "gp" {
  name           = "${var.name}-gateways"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "ClientPoolIPv4"


  attribute {
    name = "ClientPoolIPv4"
    type = "S"
  }

  tags = var.tags
}

resource "aws_dynamodb_table_item" "gp" {
  for_each   = { for i in local.gateway_map : i.Hostname => i }
  table_name = aws_dynamodb_table.gp.name
  hash_key   = aws_dynamodb_table.gp.hash_key

  item = jsonencode({
    "Hostname"       = { "S" = each.value.Hostname },
    "Serial"         = { "S" = "" },
    "InstanceId"     = { "S" = "" },
    "PublicIP"       = { "S" = "" },
    "DNSPrefix"      = { "S" = each.value.DNSPrefix },
    "AZ"             = { "S" = each.value.AZ },
    "ClientPoolIPv4" = { "S" = each.value.ClientPoolIPv4 },
    "ClientPoolIPv6" = { "S" = each.value.ClientPoolIPv6 },
    "GP_TUNNEL_IP"   = { "S" = each.value.GP_TUNNEL_IP }
    "Available"      = { "S" = "YES" }
  })

  # lifecycle {
  #   ignore_changes = [
  #     item,
  #   ]
  # }
}
