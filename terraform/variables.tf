variable "cidr_block" {
  type        = string
  description = "cidr block"
  default     = "14.0.0.0/16"

}

variable "vpc_name" {

  type        = string
  description = "vpc name"
  default     = "MEASUREMENTS_VPC_TF"

}



variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["14.0.1.0/24", "14.0.2.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "ingress_cidr" {
  type        = list(string)
  description = "Ingress cidr"
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr" {
  type        = list(string)
  description = "egress cidr"
  default     = ["0.0.0.0/0"]
}


variable "mpt_table_name" {
  type        = string
  description = "dynamodb table name"
  default     = "MPT_TF"
}

variable "mpt_partition_key_name" {

  type        = string
  description = "dynamodb table partition key"
  default     = "device_id"

}

variable "mpt_sort_key_name" {

  type        = string
  description = "dynamodb table sort key"
  default     = "timestamp"

}

variable "record_lambda_function_name" {

  type        = string
  description = "name of record lambda function"
  default     = "RECORD_MPT_TF"

}

variable "get_lambda_function_name" {

  type        = string
  description = "name of get lambda function"
  default     = "GET_MPT_TF"

}

variable "record_lambda_zip_filename" {

  type        = string
  description = "name of zipped lambda"
  default     = "record_mpt.zip"

}

variable "get_lambda_zip_filename" {

  type        = string
  description = "name of zipped lambda"
  default     = "get_mpt.zip"

}





