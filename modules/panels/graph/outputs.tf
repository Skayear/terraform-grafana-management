output "panel" {
  description = "Panel definition to include in a dashboard's config_json panels list."
  value = {
    type       = var.type
    title      = var.title
    gridPos    = var.gridPos
    datasource = var.datasource
    targets    = var.targets
    options = {
      tooltip = {
        mode      = var.mode
        sort      = var.sort
        hideZeros = var.hideZeros
      }
      legend = {
        showLegend  = var.showLegend
        displayMode = var.displayMode
        placement   = var.placement
      }
    }
  }
}
