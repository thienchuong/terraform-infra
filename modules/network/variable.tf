#############################################
#                   VPC                     #
#############################################
variable "vpcs" {
  type = list(any)
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

variable "env" {
  type = string
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

#############################################
#                   EKS                     #
#############################################
variable "cluster_name" {
  type    = string
  default = "management"
}
