output "panel" {
  description = "Panel definition to include in a dashboard's config_json panels list."
  value = {
    type       = "barchart"
    title      = var.title
    gridPos    = var.gridPos
    datasource = var.datasource
    targets    = var.targets
    fieldConfig = {
      defaults  = {}
      overrides = []
    }
    options = {
      orientation        = var.orientation
      stacking           = var.stacking
      showValue          = var.showValue
      groupWidth         = 0.7
      barWidth           = 0.97
      xTickLabelRotation = 0
      legend = {
        showLegend  = var.showLegend
        displayMode = "list"
        placement   = var.placement
      }
      tooltip = {
        mode = "single"
        sort = "none"
      }
    }
  }
}
