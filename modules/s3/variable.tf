variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
  
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "object_lock_enabled" {
  description = "A boolean that indicates whether this bucket has Object Lock enabled"
  type        = bool
  default     = false
}

variable "request_payer" {
  description = "Who pays for the download and request fees"
  type        = string
  default     = "BucketOwner"
}

variable "control_object_ownership" {
  description = "A boolean that indicates whether S3 Object Ownership is enabled on this bucket"
  type        = bool
  default     = false
}

variable "object_ownership" {
  description = "The AWS account ID of the owner for any objects created in the bucket"
  type        = string
}

variable "block_public_acls" {
  description = "A boolean that indicates whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "A boolean that indicates whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "A boolean that indicates whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "A boolean that indicates whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "attach_policy" {
  description = "A boolean that indicates whether to attach a bucket policy to the bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}
