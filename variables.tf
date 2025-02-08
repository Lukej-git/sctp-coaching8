variable "instance_type" {
 description = "Instance type of ec2"
 type        = string
 default     = "t2.micro"
}


variable "instance_count" {
 description = "Count of ec2 instance"
 type        = number
 default     = 1
}


variable "vpc_id" {
 description = "Virtual private cloud id"
 type        = string
 default     = "vpc-012814271f30b4442"
}


variable "public_subnet" {
 description = "Choice of deploying to public or private subnet"
 type        = bool
 default     = true
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "luke-vpc-keypair"
}