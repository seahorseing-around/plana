resource "aws_vpc" "plana_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Plan A VPC"
  }
}

# priv & pub created separately so they can be referenced individually
resource "aws_subnet" "plana_public" {
  for_each          = var.pub_subnets
  vpc_id            = aws_vpc.plana_vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.value["name"]
  }
}

resource "aws_subnet" "plana_private" {
  for_each          = var.priv_subnets
  vpc_id            = aws_vpc.plana_vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.value["name"]
  }
}

# enables internet connections in to VPC
resource "aws_internet_gateway" "plana_ig" {
  vpc_id = aws_vpc.plana_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

# used for outbound connectivity only 
# not resiliant on one Subnet - would want to look at this soln in more detail
resource "aws_nat_gateway" "plana_ng" {
  subnet_id         = values(aws_subnet.plana_public)[0].id
  connectivity_type = "public"
  allocation_id     = aws_eip.plana_eip.id

  tags = {
    Name = "PlanA gw NAT"
  }

  depends_on = [aws_internet_gateway.plana_ig]
}

resource "aws_eip" "plana_eip" {
  vpc = true

}

# Custom Route table, used by Private subnets
# anywhere -> intenet gateway
# (default route from VPC -> local is created implicitly)
resource "aws_route_table" "plana_routes" {
  vpc_id = aws_vpc.plana_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.plana_ig.id
  }

  tags = {
    Name = "PlanA-Routes"
  }
}

# Add route tp nat gateway for outbound internet traffic
resource "aws_route" "ng_route" {
  route_table_id         = aws_vpc.plana_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.plana_ng.id
}

# private subnets routed to main route table to grant access within VPC
resource "aws_route_table_association" "plana_rt_assoc_priv" {
  for_each       = aws_subnet.plana_private
  subnet_id      = each.value.id
  route_table_id = aws_vpc.plana_vpc.main_route_table_id
}

# pubic subnets have routes to internet via IGW
resource "aws_route_table_association" "plana_rt_assoc_pub" {
  for_each       = aws_subnet.plana_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.plana_routes.id
}