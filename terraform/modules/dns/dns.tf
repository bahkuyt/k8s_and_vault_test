// terraform hack to make this module wait until prerequisite modules are complete
resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

provider "azurerm" {
   features {}
}

//DNSs RG
data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

data "azurerm_dns_zone" "dns" {
  name                = var.dns_zone_name
  resource_group_name = data.azurerm_resource_group.rg.name
}


// DNS "A" records
resource "azurerm_dns_a_record" "vault" {
  name                = "vault"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}

resource "azurerm_dns_a_record" "hello" {
  name                = "hello"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}

resource "azurerm_dns_a_record" "argocd" {
  name                = "argocd"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}

resource "azurerm_dns_a_record" "tracing" {
  name                = "tracing"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}

resource "azurerm_dns_a_record" "grafana" {
  name                = "grafana"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}

resource "azurerm_dns_a_record" "kiali" {
  name                = "kiali"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}

resource "azurerm_dns_a_record" "tekton-triggers" {
  name                = "tekton-triggers"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}
resource "azurerm_dns_a_record" "tekton" {
  name                = "tekton"
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [var.ingress_external_ip]
}