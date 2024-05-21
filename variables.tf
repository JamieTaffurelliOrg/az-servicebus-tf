variable "service_bus_name" {
  type        = string
  description = "The name of the service bus to deploy"
}

variable "location" {
  type        = string
  description = "The location of the service bus to deploy"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group of the service bus to deploy"
}

variable "sku" {
  type        = string
  description = "The sku of the service bus to deploy"
}

variable "capacity" {
  type        = number
  default     = 0
  description = "The capacity of the service bus"
}

variable "premium_messaging_partitions" {
  type        = number
  default     = 0
  description = "Number of partitions for premium service bus"
}

variable "local_auth_enabled" {
  type        = bool
  default     = false
  description = "Enable SAS auth"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public network access"
}

variable "zone_redundant" {
  type        = bool
  default     = true
  description = "Enable zone redundancy, only for premium"
}

variable "network_rule_set" {
  type = object({
    default_action                = optional(string, "Deny")
    public_network_access_enabled = optional(bool, false)
    ip_rules                      = optional(list(string))
    trusted_services_allowed      = optional(bool, true)
    virtual_network_rules = optional(map(object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    })))
  })
  description = "Network rules for service bus"
}

variable "servicebus_authorization_rules" {
  type = list(object({
    name   = string
    listen = optional(bool, false)
    send   = optional(bool, false)
    manage = optional(bool, false)
  }))
  default     = []
  description = "Namespace auth rules"
}

variable "servicebus_queues" {
  type = list(object({
    name                                    = string
    lock_duration                           = optional(string, "PT1M")
    max_message_size_in_kilobytes           = optional(number)
    max_size_in_megabytes                   = optional(number, 1024)
    requires_duplicate_detection            = bool
    requires_session                        = bool
    default_message_ttl                     = optional(string)
    dead_lettering_on_message_expiration    = bool
    duplicate_detection_history_time_window = optional(string, "PT10M")
    max_delivery_count                      = optional(number, 10)
    status                                  = optional(string, "Active")
    enable_batched_operations               = optional(bool, true)
    auto_delete_on_idle                     = optional(string)
    enable_partitioning                     = bool
    enable_express                          = optional(bool, false)
    forward_to                              = optional(string)
    forward_dead_lettered_messages_to       = optional(string)
  }))
  default     = []
  description = "Service bus queues"
}

variable "servicebus_queues_authorization_rules" {
  type = list(object({
    name            = string
    queue_reference = string
    listen          = optional(bool, false)
    send            = optional(bool, false)
    manage          = optional(bool, false)
  }))
  default     = []
  description = "Queue auth rules"
}

variable "private_endpoints" {
  type = list(object({
    name                            = string
    location                        = string
    subnet_id                       = string
    private_service_connection_name = string
    private_dns_zone_ids            = list(string)
  }))
  default     = []
  description = "Private endpoints"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
