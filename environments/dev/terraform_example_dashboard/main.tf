resource "grafana_folder" "example" {
  title = "Terraform Dashboards"
}

resource "grafana_dashboard" "example" {
  folder = grafana_folder.example.uid

  config_json = jsonencode({
    title   = "Example Dashboard (Terraform)"
    uid     = "example-terraform-dashboard"
    schemaVersion = 38
    version = 1

    panels = [
      module.text_welcome_example.text_welcome_example
    ]
  })
}

#######################
# Grafana Panels
#######################

module "text_welcome_example" {
  source = "./panels/text_welcome_example"
}