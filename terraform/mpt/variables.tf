

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"

}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"

}

variable "cidr_block" {
  type        = string
  description = "cidr block"


}

variable "vpc_name" {

  type        = string
  description = "vpc name"


}

variable "ingress_cidr" {
  type        = list(string)
  description = "Ingress cidr"

}

variable "egress_cidr" {
  type        = list(string)
  description = "egress cidr"

}

variable "mpt_table_name" {
  type        = string
  description = "dynamodb table name"

}

variable "mpt_partition_key_name" {

  type        = string
  description = "dynamodb table partition key"


}

variable "mpt_sort_key_name" {

  type        = string
  description = "dynamodb table sort key"


}


variable "record_lambda_function_name" {

  type        = string
  description = "name of update lambda function"


}

variable "record_lambda_zip_filename" {

  type        = string
  description = "name of zipped lambda"


}

variable "get_lambda_zip_filename" {

  type        = string
  description = "name of zipped lambda"


}





variable "get_lambda_function_name" {

  type        = string
  description = "name of get lambda function"

}
