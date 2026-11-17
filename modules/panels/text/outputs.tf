output "panel" {
  description = "Panel definition to include in a dashboard's config_json panels list."
  value = {
    type    = var.type
    title   = var.title
    gridPos = var.gridPos
    options = {
      mode    = var.mode
      content = var.content
      code = {
        language        = "plaintext"
        showLineNumbers = false
        showMiniMap     = false
      }
    }
  }
}
