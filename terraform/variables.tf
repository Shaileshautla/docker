variable "region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "The name of your AWS EC2 Key Pair"
  type        = string
}
