provider "grafana" {
  url  = "http://localhost:3000"
  auth = var.grafana_api_key
}

resource "grafana_data_source" "testdata" {
  name = "TestData"
  type = "testdata"
  is_default = false
}


module "terraform_example_dashboard" {
  source = "./terraform_example_dashboard"
  datasource_uid = grafana_data_source.testdata.uid
}