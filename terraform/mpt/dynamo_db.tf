resource "aws_dynamodb_table" "parking_table" {
  name                        = var.mpt_table_name
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false



  hash_key  = var.mpt_partition_key_name
  range_key = var.mpt_sort_key_name

  # Partition Key ( "Development" )
  attribute {
    name = var.mpt_partition_key_name
    type = "S"
  }

  # Sort Key ("Area")
  attribute {
    name = var.mpt_sort_key_name
    type = "S"
  }



  //global_secondary_index {
  //  name        = "${var.conn_status_table_sort_key_name}-index"
  // hash_key    = var.conn_status_table_sort_key_name
  // range_key   = var.conn_status_table_attr_status_key_name
  // projection_type = "ALL"

  //}



  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }
}

# VPC Gateway Endpoint for DynamoDB
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-southeast-1.dynamodb" # Endpoint for DynamoDB
  vpc_endpoint_type = "Gateway"

  # Attach the endpoint to the route tables of the private subnets
  route_table_ids = [
    aws_route_table.private_route_table.id # You'll need to associate this with your private route table
  ]

  tags = {
    Name = "${var.vpc_name}_dynamodb_endpoint"
  }
}

# Assuming you have a route table associated with your private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  depends_on = [aws_vpc.main]
}

# Associate the route table with each private subnet
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}


