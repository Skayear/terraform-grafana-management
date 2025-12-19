module "graph_welcome_example" {
  source = "../../../../../modules/panels/graph"
  title = "Welcome Graph - Example"
  datasource = {
    type = var.datasource_uid
  }
  gridPos = {
    x = 0
    y = 0
    w = 12
    h = 6
  }

  targets = [
    {
      "refId": "A"
    }
  ]

}