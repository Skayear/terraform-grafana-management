provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_api_key
}

resource "grafana_data_source" "testdata" {
  name       = "TestData"
  type       = "grafana-testdata-datasource"
  is_default = false
}

module "terraform_example_dashboard" {
  source = "./terraform_example_dashboard"

  datasource = {
    uid  = grafana_data_source.testdata.uid
    type = grafana_data_source.testdata.type
  }
}
