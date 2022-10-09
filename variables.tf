variable "cluster_name" {}

variable "cluster_version" {}

variable "default_node_size" {}

variable "node_count" {
    type        = number
    default     = 3
}

variable "region" {}

variable "letsencrypt_email" {}

variable "domains" {}