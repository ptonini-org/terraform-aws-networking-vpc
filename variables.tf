variable "name" {}

variable "cidr_block" {}

variable "zones" {
  type = list(string)
}

variable "nat_gateway" {
  default  = false
  nullable = false
}

variable "default_security_group" {
  type = object({
    ingress_rules = optional(map(object({
      from_port        = number
      to_port          = optional(number)
      protocol         = optional(string)
      cidr_blocks      = optional(set(string))
      ipv6_cidr_blocks = optional(set(string))
      prefix_list_ids  = optional(set(string))
      security_groups  = optional(set(string))
      self             = optional(bool)
    })), { self = { protocol = -1, from_port = 0, self = true } })
    egress_rules = optional(map(object({
      from_port        = number
      to_port          = optional(number)
      protocol         = optional(string)
      cidr_blocks      = optional(set(string))
      ipv6_cidr_blocks = optional(set(string))
      prefix_list_ids  = optional(set(string))
      security_groups  = optional(set(string))
      self             = optional(bool)
    })), { all = { protocol = -1, from_port = 0, cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] } })
  })
  default  = {}
  nullable = false
}

variable "main_table_routes" {
  type = map(object({
    cidr_block           = string
    network_interface_id = optional(string)
    gateway_id           = optional(string)
  }))
  default  = {}
  nullable = false
}

variable "peering_requests" {
  type = map(object({
    account_id = string
    vpc = object({
      id         = string
      cidr_block = string
    })
  }))
  default  = {}
  nullable = false
}

variable "peering_acceptors" {
  type = map(object({
    peering_request = object({
      id = string
    })
    vpc = object({
      id         = string
      cidr_block = string
    })
  }))
  default  = {}
  nullable = false
}

variable "flow_logs" {
  type = object({
    bucket_name          = optional(string)
    bucket_kms_key_id    = optional(string)
    log_destination      = optional(string)
    log_destination_type = optional(string, "s3")
    traffic_type         = optional(string, "ALL")
    destination_options = optional(object({
      file_format        = optional(string, "parquet")
      per_hour_partition = optional(bool, true)
    }), {})
  })
  default = null
}
