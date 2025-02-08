# DynamoDB table definition
resource "aws_dynamodb_table" "bookinventory" {
  name           = "${local.name_prefix}-bookinventory"
  billing_mode   = "PAY_PER_REQUEST"
 # Define the primary keys
  hash_key       = "ISBN"  # Partition Key
  range_key      = "Genre" # Sort Key

# Attribute definitions
  attribute {
    name = "ISBN"
    type = "S" # String
  }

  attribute {
    name = "Genre"
    type = "S" # String
  }

  # Enable server-side encryption
  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = "Dev"
    Name        = "BookInventoryTable"
  }
}