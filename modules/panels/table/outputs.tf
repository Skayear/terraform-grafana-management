output "panel" {
  description = "Panel definition to include in a dashboard's config_json panels list."
  value = {
    type       = "table"
    title      = var.title
    gridPos    = var.gridPos
    datasource = var.datasource
    targets    = var.targets
    fieldConfig = {
      defaults  = {}
      overrides = []
    }
    options = {
      showHeader = var.showHeader
      sortBy     = var.sortBy
      cellHeight = "sm"
    }
  }
}
