resource "azurerm_servicebus_namespace" "service_bus" {
  #checkov:skip=CKV_AZURE_199:CMK may nt be required
  #checkov:skip=CKV_AZURE_201:CMK may nt be required
  name                          = var.service_bus_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  capacity                      = var.capacity
  premium_messaging_partitions  = var.premium_messaging_partitions
  local_auth_enabled            = var.local_auth_enabled
  minimum_tls_version           = "1.2"
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundant                = var.sku == "Premium" ? var.zone_redundant : null

  network_rule_set {
    default_action                = var.network_rule_set.default_action
    public_network_access_enabled = var.network_rule_set.public_network_access_enabled
    ip_rules                      = var.network_rule_set.ip_rules
    trusted_services_allowed      = var.network_rule_set.trusted_services_allowed

    dynamic "network_rules" {
      for_each = var.network_rule_set.virtual_network_rules == null ? {} : var.network_rule_set.virtual_network_rules
      content {
        subnet_id                            = virtual_network_rule.value["id"]
        ignore_missing_vnet_service_endpoint = virtual_network_rule.value["ignore_missing_vnet_service_endpoint"]
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "service_bus_diagnostics" {
  name                       = "${var.log_analytics_workspace_name}-security-logging"
  target_resource_id         = azurerm_servicebus_namespace.service_bus.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  enabled_log {
    category = "ApplicationMetricsLogs"
  }

  enabled_log {
    category = "DiagnosticErrorLogs"
  }

  enabled_log {
    category = "OperationalLogs"
  }

  enabled_log {
    category = "RuntimeAuditLogs"
  }

  enabled_log {
    category = "VNetAndIPFilteringLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_servicebus_namespace_authorization_rule" "service_bus_auth_rule" {
  for_each     = { for k in var.servicebus_authorization_rules : k.name => k if k != null }
  name         = each.value["name"]
  namespace_id = azurerm_servicebus_namespace.service_bus.id
  listen       = each.value["listen"]
  send         = each.value["send"]
  manage       = each.value["manage"]
}

resource "azurerm_servicebus_queue" "service_bus_queue" {
  for_each                                = { for k in var.servicebus_queues : k.name => k if k != null }
  name                                    = each.value["name"]
  namespace_id                            = azurerm_servicebus_namespace.service_bus.id
  lock_duration                           = each.value["lock_duration"]
  max_message_size_in_kilobytes           = each.value["max_message_size_in_kilobytes"]
  max_size_in_megabytes                   = each.value["max_size_in_megabytes"]
  requires_duplicate_detection            = each.value["requires_duplicate_detection"]
  requires_session                        = each.value["requires_session"]
  default_message_ttl                     = each.value["default_message_ttl"]
  dead_lettering_on_message_expiration    = each.value["dead_lettering_on_message_expiration"]
  duplicate_detection_history_time_window = each.value["duplicate_detection_history_time_window"]
  max_delivery_count                      = each.value["max_delivery_count"]
  status                                  = each.value["status"]
  enable_batched_operations               = each.value["enable_batched_operations"]
  auto_delete_on_idle                     = each.value["auto_delete_on_idle"]
  enable_partitioning                     = each.value["enable_partitioning"]
  enable_express                          = each.value["enable_express"]
  forward_to                              = each.value["forward_to"]
  forward_dead_lettered_messages_to       = each.value["forward_dead_lettered_messages_to"]
}

resource "azurerm_servicebus_queue_authorization_rule" "service_bus_auth_rule" {
  for_each = { for k in var.servicebus_queues_authorization_rules : k.name => k if k != null }
  name     = each.value["name"]
  queue_id = azurerm_servicebus_queue.service_bus_queue[(each.value["queue_reference"])].id
  listen   = each.value["listen"]
  send     = each.value["send"]
  manage   = each.value["manage"]
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = { for k in var.private_endpoints : k.name => k if k != null }
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = each.value["location"]
  subnet_id           = each.value["subnet_id"]

  private_service_connection {
    name                           = each.value["private_service_connection_name"]
    private_connection_resource_id = azurerm_servicebus_namespace.service_bus.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  private_dns_zone_group {
    name                 = "customdns"
    private_dns_zone_ids = each.value["private_dns_zone_ids"]
  }
}
