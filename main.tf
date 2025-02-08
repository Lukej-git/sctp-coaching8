locals {
 name_prefix = "luke-coach8"
}

locals {
 selected_subnet_ids = var.public_subnet ? data.aws_subnets.public.ids : data.aws_subnets.private.ids
}

resource "aws_iam_role" "db_reader_role" {
  name = "${local.name_prefix}-db-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


data "aws_iam_policy_document" "db_read_list_all" {
 statement {
    #Policy Actions to allow EC2 to scan from DynamoDB tables
   effect    = "Allow"
   actions   = [
            "dynamodb:BatchGetItem",
            "dynamodb:DescribeImport",
            "dynamodb:ConditionCheckItem",
            "dynamodb:DescribeContributorInsights",
            "dynamodb:Scan",
            "dynamodb:ListTagsOfResource",
            "dynamodb:Query",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTimeToLive",
            "dynamodb:DescribeGlobalTableSettings",
            "dynamodb:PartiQLSelect",
            "dynamodb:DescribeTable",
            "dynamodb:GetShardIterator",
            "dynamodb:DescribeGlobalTable",
            "dynamodb:GetItem",
            "dynamodb:DescribeContinuousBackups",
            "dynamodb:DescribeExport",
            "dynamodb:GetResourcePolicy",
            "dynamodb:DescribeKinesisStreamingDestination",
            "dynamodb:DescribeBackup",
            "dynamodb:GetRecords",
            "dynamodb:DescribeTableReplicaAutoScaling"
            ]
   resources = ["*"] # Input relevant arn HERE
 }

 statement {
    #Policy Actions to allow EC2 to list from DynamoDB tables
   effect    = "Allow"
   actions   = [
                "dynamodb:ListContributorInsights",
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:ListGlobalTables",
                "dynamodb:ListTables",
                "dynamodb:DescribeReservedCapacity",
                "dynamodb:ListBackups",
                "dynamodb:GetAbacStatus",
                "dynamodb:ListImports",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeEndpoints",
                "dynamodb:ListExports",
                "dynamodb:ListStreams"
                ]

   resources = ["*"] # Input relevant arn HERE
 }

 statement {
    #Policy Actions to allow EC2 Description
   effect    = "Allow"
   actions   = ["ec2:Describe*"]
   resources = ["*"]
 }

 statement {
    #Policy Actions to allow EC2 Description
   effect    = "Allow"
   actions   = ["ec2:Describe*"]
   resources = ["*"]
 }

 statement {
    #Policy Actions to allow S3 bucket listing
   effect    = "Allow"
   actions   = ["s3:ListBucket*"]
   resources = ["*"]
 }
}


resource "aws_iam_policy" "db_reader" {
 name = "${local.name_prefix}-db_reader-policy"

 ## Option 1: Attach data block policy document
 policy = data.aws_iam_policy_document.db_read_list_all.json

}


resource "aws_iam_role_policy_attachment" "attach_example" {
 role       = aws_iam_role.db_reader_role.name
 policy_arn = aws_iam_policy.db_reader.arn
}


resource "aws_iam_instance_profile" "db_reader_profile" {
 name = "${local.name_prefix}-profile"
 role = aws_iam_role.db_reader_role.name
}

resource "aws_security_group" "db_reader" {
 name_prefix = "${local.name_prefix}-dbreader"
 description = "Allow traffic to dbreader"
 vpc_id      = data.aws_vpc.selected.id


# Allow HTTP traffic from anywhere
  ingress {
   from_port        = 443
   to_port          = 443
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
 }

 # Allow SSH access only from anywhere
 ingress {
   from_port        = 22
   to_port          = 22
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
 }


 egress {
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
 }


 lifecycle {
   create_before_destroy = true
 }
}


resource "aws_instance" "db_reader" {
 count                  = 1
 ami                    = data.aws_ami.latest.id
 instance_type          = var.instance_type
 key_name               = var.key_name
 subnet_id              = local.selected_subnet_ids[count.index % length(local.selected_subnet_ids)]
 vpc_security_group_ids = [aws_security_group.db_reader.id]
 iam_instance_profile   = aws_iam_instance_profile.db_reader_profile.name
 user_data              = templatefile("${path.module}/init-script.sh", {
   file_content = "dbreader-#${count.index}"})


 associate_public_ip_address = true
 tags = {
   Name = "${local.name_prefix}-dbreader-${count.index}"
 }
}

resource "aws_s3_bucket" "luke_bucket" {
  bucket = "${local.name_prefix}-test-bucket"

  tags = {
    Name        = "Luke_bucket"
    Environment = "Dev"
  }
}
