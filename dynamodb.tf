resource "aws_dynamodb_table" "dynamic_string" {
  name         = "dynamic-content"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "dynamic-content"
  }
}

resource "aws_dynamodb_table_item" "root_html" {
  table_name = aws_dynamodb_table.dynamic_string.name
  hash_key   = aws_dynamodb_table.dynamic_string.hash_key

  item = jsonencode({
    id      = { S = "root" }
    content = { S = "<h1>The saved string is dynamic string</h1>" }
  })
}
