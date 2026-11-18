output "panel" {
  description = "Panel definition to include in a dashboard's config_json panels list."
  value = {
    type       = "stat"
    title      = var.title
    gridPos    = var.gridPos
    datasource = var.datasource
    targets    = var.targets
    fieldConfig = {
      defaults = {
        unit = var.unit
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
      colorMode   = var.colorMode
      graphMode   = var.graphMode
      justifyMode = "auto"
      orientation = "auto"
      textMode    = "auto"
    }
  }
}
