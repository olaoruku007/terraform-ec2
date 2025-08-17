# Subnet name → ID mapping
locals {
  public_subnets = {
    terraform-pro1 = aws_subnet.terraform-pro1.id
    terraform-pro2 = aws_subnet.terraform-pro2.id
    terraform-pro3 = aws_subnet.terraform-pro3.id
  }

  private_subnets = {
    terraform-pro4 = aws_subnet.terraform-pro4.id
    terraform-pro5 = aws_subnet.terraform-pro5.id
  }
}

# Select subnets based on deploy_in variable
locals {
  selected_subnets = (
    var.deploy_in == "public"  ? local.public_subnets :
    var.deploy_in == "private" ? local.private_subnets :
    merge(local.public_subnets, local.private_subnets)
  )
}

# Expand each subnet configuration into multiple instances
locals {
  expanded_instances = flatten([
    for subnet_name, subnet_id in local.selected_subnets : [
      for i in range(lookup(var.subnet_configs[subnet_name].count, 1)) : {
        subnet_name   = subnet_name
        subnet_id     = subnet_id
        index         = i
        ami           = lookup(var.subnet_configs[subnet_name], "ami", var.default_ami)
        instance_type = lookup(var.subnet_configs[subnet_name], "instance_type", var.default_instance_type)
        key_name      = lookup(var.subnet_configs[subnet_name], "key_name", null)
        user_data     = lookup(var.subnet_configs[subnet_name], "user_data", null)
      }
    ]
  ])
}

# Unique map for instances
locals {
  instance_map = {
    for inst in local.expanded_instances :
    "${inst.subnet_name}-${inst.index}" => inst
  }
}

# Deploy EC2 instances
resource "aws_instance" "ec2_dynamic" {
  for_each = local.instance_map

  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  key_name      = each.value.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = each.value.user_data

  tags = {
    Name = "EC2-${each.value.subnet_name}-${each.value.index}"
  }
}
