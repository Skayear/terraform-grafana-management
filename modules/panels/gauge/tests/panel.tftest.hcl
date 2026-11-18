variables {
  title      = "Test"
  datasource = { uid = "ds-uid", type = "grafana-testdata-datasource" }
  gridPos    = { x = 0, y = 0, w = 12, h = 6 }
}

run "custom_range" {
  command = plan

  variables {
    unit = "percent"
    min  = 10
    max  = 50
  }

  assert {
    condition     = output.panel.type == "gauge"
    error_message = "Panel type must be gauge."
  }

  assert {
    condition = (
      output.panel.fieldConfig.defaults.unit == "percent" &&
      output.panel.fieldConfig.defaults.min == 10 &&
      output.panel.fieldConfig.defaults.max == 50
    )
    error_message = "Unit, min and max must be rendered under fieldConfig.defaults."
  }
}
