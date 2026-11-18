variables {
  title      = "Test"
  datasource = { uid = "ds-uid", type = "grafana-testdata-datasource" }
  gridPos    = { x = 0, y = 0, w = 12, h = 6 }
}

run "donut" {
  command = plan

  variables {
    pieType = "donut"
  }

  assert {
    condition     = output.panel.type == "piechart"
    error_message = "Panel type must be piechart."
  }

  assert {
    condition     = output.panel.options.pieType == "donut" && output.panel.options.legend.placement == "right"
    error_message = "pieType and the default right legend must be rendered under options."
  }
}
