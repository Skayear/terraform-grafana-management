variable "grafana_url" {
  description = "Grafana server URL"
  type        = string
}

variable "grafana_api_key" {
  description = "Grafana API Key with Admin permissions"
  type        = string
  sensitive   = true
}