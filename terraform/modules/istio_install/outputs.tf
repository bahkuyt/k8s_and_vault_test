output "ingress_external_ip" {
  value = lookup(data.external.ingressgateway_ip.result, "ip")
}
 
