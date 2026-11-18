variables {
  title      = "Test"
  datasource = { uid = "ds-uid", type = "grafana-testdata-datasource" }
  gridPos    = { x = 0, y = 0, w = 12, h = 6 }
}

run "sorted" {
  command = plan

  variables {
    sortBy = [{ displayName = "latencia_ms", desc = true }]
  }

  assert {
    condition     = output.panel.type == "table"
    error_message = "Panel type must be table."
  }

  assert {
    condition     = output.panel.options.sortBy[0].displayName == "latencia_ms" && output.panel.options.sortBy[0].desc
    error_message = "sortBy must be rendered under options."
  }
}
