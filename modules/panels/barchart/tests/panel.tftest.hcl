variables {
  title      = "Test"
  datasource = { uid = "ds-uid", type = "grafana-testdata-datasource" }
  gridPos    = { x = 0, y = 0, w = 12, h = 6 }
}

run "stacked" {
  command = plan

  variables {
    stacking = "normal"
  }

  assert {
    condition     = output.panel.type == "barchart"
    error_message = "Panel type must be barchart."
  }

  assert {
    condition     = output.panel.options.stacking == "normal" && output.panel.options.legend.showLegend
    error_message = "Stacking and legend must be rendered under options."
  }
}
