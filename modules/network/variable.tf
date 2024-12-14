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

#############################################
#                   EKS                     #
#############################################
variable "cluster_name" {
  type    = string
  default = "management"
}
