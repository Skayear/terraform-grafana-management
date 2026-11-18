output "panel" {
  description = "Panel definition to include in a dashboard's config_json panels list."
  value = {
    type       = "gauge"
    title      = var.title
    gridPos    = var.gridPos
    datasource = var.datasource
    targets    = var.targets
    fieldConfig = {
      defaults = {
        unit = var.unit
        min  = var.min
        max  = var.max
        thresholds = {
          mode  = "absolute"
          steps = var.thresholds
        }
      }
      overrides = []
    }
    options = {
      reduceOptions = {
        calcs  = var.calcs
        fields = ""
        values = false
      }
      orientation          = "auto"
      showThresholdLabels  = false
      showThresholdMarkers = true
    }
  }
}
