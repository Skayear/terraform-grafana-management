output "panel" {
  description = "Panel definition to include in a dashboard's config_json panels list."
  value = {
    type       = "piechart"
    title      = var.title
    gridPos    = var.gridPos
    datasource = var.datasource
    targets    = var.targets
    fieldConfig = {
      defaults  = {}
      overrides = []
    }
    options = {
      pieType       = var.pieType
      displayLabels = var.displayLabels
      reduceOptions = {
        calcs  = var.calcs
        fields = ""
        values = false
      }
      legend = {
        showLegend  = var.showLegend
        displayMode = "list"
        placement   = var.placement
        values      = []
      }
      tooltip = {
        mode = "single"
        sort = "none"
      }
    }
  }
}
