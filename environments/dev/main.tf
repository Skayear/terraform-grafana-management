provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_api_key
}

resource "grafana_data_source" "testdata" {
  name       = "TestData"
  type       = "grafana-testdata-datasource"
  is_default = false
}

resource "grafana_folder" "terraform" {
  title = "Terraform Dashboards"
}

# The folder used to live inside the example dashboard module.
moved {
  from = module.terraform_example_dashboard.grafana_folder.example
  to   = grafana_folder.terraform
}

locals {
  testdata = {
    uid  = grafana_data_source.testdata.uid
    type = grafana_data_source.testdata.type
  }
}

module "terraform_example_dashboard" {
  source = "./terraform_example_dashboard"

  folder_uid = grafana_folder.terraform.uid
  datasource = local.testdata
}

module "panel_showcase_dashboard" {
  source = "./panel_showcase_dashboard"

  folder_uid = grafana_folder.terraform.uid
  datasource = local.testdata
}

# Folders and dashboards exported from Grafana with scripts/export_grafana.py.
module "dashboards" {
  source = "../../modules/dashboards"

  path = "${path.module}/dashboards"
}
