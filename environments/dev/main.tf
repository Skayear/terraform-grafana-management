provider "grafana" {
  url  = "http://localhost:3000"
  auth = var.grafana_api_key
}

module "terraform_example_dashboard" {
  source = "./terraform_example_dashboard"
}