variable "publisher_name" {
  description = "Publisher Name"
  type        = string
}

variable "aws_instance_type" {
  description = "AWS Instance Type - t3.medium is the reccomended instance size."
  default     = "t3.medium"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Publisher Assigned Public IP or Not"
  type        = bool
  default     = false
}

variable "aws_monitoring" {
  description = "Enable Detailed Monitoring of AWS Instance"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "Enable EBS Optimized"
  type        = bool
  default     = true
}

variable "aws_key_name" {
  description = "AWS SSH Key Name"
  type        = string
}

variable "aws_subnet" {
  description = "AWS Subnet Id"
  type        = string
}

variable "aws_security_group" {
  description = "AWS Security Group Id"
  type        = string
}

variable "ami_id" {
  description = "Publisher AMI ID - Latest will be used if this is not speciified."
  default     = ""
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile name to attach to the EC2 instance. When use_ssm is true and this is left null, an IAM role with the AmazonSSMManagedInstanceCore policy and a matching instance profile are created automatically."
  default     = null
  type        = string
}

variable "http_endpoint" {
  description = "Metadata Service enabled or disabled"
  type        = string
  default     = "enabled"
}

variable "http_tokens" {
  description = "Metadata Service V2 optional or reuqired - Use SSM set to required"
  type        = string
  default     = "required"
}

variable "use_ssm" {
  description = "Use SSM to register the Publisher instead of passing the token via user_data. Recommended when http_tokens is set to required (IMDSv2). When enabled without an iam_instance_profile, an IAM role and instance profile with AmazonSSMManagedInstanceCore are created automatically."
  type        = bool
  default     = true
}
