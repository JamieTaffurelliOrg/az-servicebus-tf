# az-servicebus-tf
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.104 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.104 |
| <a name="provider_azurerm.logs"></a> [azurerm.logs](#provider\_azurerm.logs) | ~> 3.104 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.service_bus_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_servicebus_namespace.service_bus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.service_bus_auth_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_queue.service_bus_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue_authorization_rule.service_bus_auth_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azurerm_log_analytics_workspace.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The capacity of the service bus | `number` | `0` | no |
| <a name="input_local_auth_enabled"></a> [local\_auth\_enabled](#input\_local\_auth\_enabled) | Enable SAS auth | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the service bus to deploy | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Resource Group of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_network_rule_set"></a> [network\_rule\_set](#input\_network\_rule\_set) | Network rules for service bus | <pre>object({<br>    default_action                = optional(string, "Deny")<br>    public_network_access_enabled = optional(bool, false)<br>    ip_rules                      = optional(list(string))<br>    trusted_services_allowed      = optional(bool, true)<br>    virtual_network_rules = optional(map(object({<br>      subnet_id                            = string<br>      ignore_missing_vnet_service_endpoint = optional(bool, false)<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_premium_messaging_partitions"></a> [premium\_messaging\_partitions](#input\_premium\_messaging\_partitions) | Number of partitions for premium service bus | `number` | `0` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Private endpoints | <pre>list(object({<br>    name                            = string<br>    location                        = string<br>    subnet_id                       = string<br>    private_service_connection_name = string<br>    private_dns_zone_ids            = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group of the service bus to deploy | `string` | n/a | yes |
| <a name="input_service_bus_name"></a> [service\_bus\_name](#input\_service\_bus\_name) | The name of the service bus to deploy | `string` | n/a | yes |
| <a name="input_servicebus_authorization_rules"></a> [servicebus\_authorization\_rules](#input\_servicebus\_authorization\_rules) | Namespace auth rules | <pre>list(object({<br>    name   = string<br>    listen = optional(bool, false)<br>    send   = optional(bool, false)<br>    manage = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_servicebus_queues"></a> [servicebus\_queues](#input\_servicebus\_queues) | Service bus queues | <pre>list(object({<br>    name                                    = string<br>    lock_duration                           = optional(string, "PT1M")<br>    max_message_size_in_kilobytes           = optional(number)<br>    max_size_in_megabytes                   = optional(number, 1024)<br>    requires_duplicate_detection            = bool<br>    requires_session                        = bool<br>    default_message_ttl                     = optional(string)<br>    dead_lettering_on_message_expiration    = bool<br>    duplicate_detection_history_time_window = optional(string, "PT10M")<br>    max_delivery_count                      = optional(number, 10)<br>    status                                  = optional(string, "Active")<br>    enable_batched_operations               = optional(bool, true)<br>    auto_delete_on_idle                     = optional(string)<br>    enable_partitioning                     = bool<br>    enable_express                          = optional(bool, false)<br>    forward_to                              = optional(string)<br>    forward_dead_lettered_messages_to       = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_servicebus_queues_authorization_rules"></a> [servicebus\_queues\_authorization\_rules](#input\_servicebus\_queues\_authorization\_rules) | Queue auth rules | <pre>list(object({<br>    name            = string<br>    queue_reference = string<br>    listen          = optional(bool, false)<br>    send            = optional(bool, false)<br>    manage          = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku of the service bus to deploy | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | n/a | yes |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Enable zone redundancy, only for premium | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->