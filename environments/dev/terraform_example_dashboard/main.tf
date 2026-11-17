resource "grafana_folder" "example" {
  title = "Terraform Dashboards"
}

resource "grafana_dashboard" "example" {
  folder = grafana_folder.example.uid

  config_json = jsonencode({
    title         = "Example Dashboard (Terraform)"
    uid           = "example-terraform-dashboard"
    schemaVersion = 38
    version       = 1

    panels = [
      module.text_welcome_example.panel,
      module.graph_welcome_example.panel,
    ]
  })
}

#######################
# Grafana Panels
#######################

module "text_welcome_example" {
  source = "../../../modules/panels/text"

  title   = "Welcome Text - Example"
  content = "🚀 Dashboard creado con Terraform"
  mode    = "markdown"

  gridPos = {
    x = 0
    y = 0
    w = 12
    h = 6
  }
}

module "graph_welcome_example" {
  source = "../../../modules/panels/graph"

  title      = "Welcome Graph - Example"
  datasource = var.datasource

  gridPos = {
    x = 12
    y = 0
    w = 12
    h = 6
  }
}
