#Enable SSM on EC2
resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

##Dynamodb for EC2
resource "aws_iam_policy" "dynamodb_read" {
  name = "dynamodb-read-dynamic-content"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:GetItem"
      ]
      Resource = aws_dynamodb_table.dynamic_string.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_read_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

