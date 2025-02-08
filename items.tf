# Insert the first book item into DynamoDB
resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.bookinventory.name  

  hash_key  = "ISBN"
  range_key = "Genre"

  item = jsonencode({
    ISBN   = { S = "978-0134685991" }
    Genre  = { S = "Technology" }
    Title  = { S = "Effective Java" }
    Author = { S = "Joshua Bloch" }
    Stock  = { N = "1" }  # Explicitly specify as a number string
  })
}

# Insert the second book item into DynamoDB
resource "aws_dynamodb_table_item" "item2" {
  table_name = aws_dynamodb_table.bookinventory.name  

  hash_key  = "ISBN"
  range_key = "Genre"

  item = jsonencode({
    ISBN   = { S = "978-0134685009" }
    Genre  = { S = "Technology" }
    Title  = { S = "Learning Python" }
    Author = { S = "Mark Lutz" }
    Stock  = { N = "2" }  # Explicitly specify as a number string
  })
}

# Insert the third book item into DynamoDB
resource "aws_dynamodb_table_item" "item3" {
  table_name = aws_dynamodb_table.bookinventory.name  

  hash_key  = "ISBN"
  range_key = "Genre"

  item = jsonencode({
    ISBN   = { S = "974-0134789698" }
    Genre  = { S = "Fiction" }
    Title  = { S = "The Hitchhiker" }
    Author = { S = "Douglas Adams" }
    Stock  = { N = "10" }  # Explicitly specify as a number string
  })
}

# Insert the fourth book item into DynamoDB
resource "aws_dynamodb_table_item" "item4" {
  table_name = aws_dynamodb_table.bookinventory.name  

  hash_key  = "ISBN"
  range_key = "Genre"

  item = jsonencode({
    ISBN   = { S = "982-01346653457" }
    Genre  = { S = "Fiction" }
    Title  = { S = "Dune" }
    Author = { S = "Frank Herbert" }
    Stock  = { N = "8" }  # Explicitly specify as a number string
  })
}

# Insert the fifth book item into DynamoDB
resource "aws_dynamodb_table_item" "item5" {
  table_name = aws_dynamodb_table.bookinventory.name  

  hash_key  = "ISBN"
  range_key = "Genre"

  item = jsonencode({
    ISBN   = { S = "978-01346854325" }
    Genre  = { S = "Technology" }
    Title  = { S = "System Design" }
    Author = { S = "Mark Lutz" }
    Stock  = { N = "0" }  # Explicitly specify as a number string
  })
}