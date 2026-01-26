variable "region1" {
  description = "main region"
  type        = string
  default     = "us-east-1"
}

variable "az1" {
  description = "availability zone 1"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "availability zone 2"
  type        = string
  default     = "us-east-1b"
}

variable "on-prem-vpn" {
  description = "on-premise vpn range"
  default     = "0.0.0.0/0"
}

variable "domain" {
  description = "main domain"
  default     = "victorponce.site"
}

variable "ubuntu24" {
  description = "ubuntu 24.04 LTS"
  default     = "ami-0ecb62995f68bb549"
}