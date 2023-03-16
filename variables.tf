variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the subnets. Changing this forces new resources to be created."
  nullable    = false
}

variable "subnets" {
  type = map(object(
    {
      address_prefixes = optional(list(string)) # (Deprecated) This field is deprecated and will be removed in 2.0.0, please use address_space instead. The address spaces to use for the subnet.
      address_space    = optional(list(string)) # (Required) The address spaces to use for the subnet.
      nat_gateway = optional(object({
        id = string # (Required) The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.
      }))
      network_security_group = optional(object({
        id = string # (Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.
      }))
      private_endpoint_network_policies_enabled     = optional(bool, true) # (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.
      private_link_service_network_policies_enabled = optional(bool, true) # (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.
      route_table = optional(object({
        id = string # (Required) The ID of the Route Table which should be associated with the Subnet. Changing this forces a new association to be created.
      }))
      service_endpoints           = optional(set(string)) # (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.
      service_endpoint_policy_ids = optional(set(string)) # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
      delegations = optional(list(
        object(
          {
            name = string # (Required) A name for this delegation.
            service_delegation = object({
              name    = string                 # (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments` and `PaloAltoNetworks.Cloudngfw/firewalls`.
              actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
            })
          }
        )
      ))
    }
  ))
  description = "Subnets to create"
  validation {
    condition     = alltrue([for name, subnet in var.subnets : subnet.address_prefixes != null || subnet.address_space != null])
    error_message = "Either one of `address_prefixes` or `address_space` must be set."
  }
  validation {
    condition     = alltrue([for name, subnet in var.subnets : subnet.address_prefixes == null || subnet.address_space == null])
    error_message = "Cannot set both `address_prefixes` and `address_space`."
  }
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = " (Required) The address space that is used the virtual network. You can supply more than one address space."
  nullable    = false
  validation {
    condition     = length(var.virtual_network_address_space) > 0
    error_message = "Please provide at least one cidr as address space."
  }
}

variable "virtual_network_location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces new resources to be created."
  nullable    = false
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
  nullable    = false
}

variable "virtual_network_bgp_community" {
  type        = string
  description = "(Optional) The BGP community attribute in format `<as-number>:<community-value>`."
  default     = null
}

variable "virtual_network_ddos_protection_plan" {
  type = object({
    id     = string #  (Required) The ID of DDoS Protection Plan.
    enable = bool   # (Required) Enable/disable DDoS Protection Plan on Virtual Network.
  })
  description = "AzureNetwork DDoS Protection Plan."
  default     = null
}

variable "virtual_network_dns_servers" {
  type = object({
    dns_servers = list(string)
  })
  description = "(Optional) List of IP addresses of DNS servers"
  default     = null
}

variable "virtual_network_edge_zone" {
  type        = string
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
  default     = null
}

variable "virtual_network_flow_timeout_in_minutes" {
  type        = number
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between `4` and `30`minutes."
  default     = null
  validation {
    condition     = var.virtual_network_flow_timeout_in_minutes == null ? true : (var.virtual_network_flow_timeout_in_minutes >= 4 && var.virtual_network_flow_timeout_in_minutes <= 30)
    error_message = "Possible values for `var.virtual_network_flow_timeout_in_minutes` are between `4` and `30`minutes."
  }
}

variable "virtual_network_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the virtual network."
  default     = null
}
