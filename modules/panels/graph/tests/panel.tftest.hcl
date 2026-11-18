variables {
  title      = "Test"
  datasource = { uid = "ds-uid", type = "grafana-testdata-datasource" }
  gridPos    = { x = 0, y = 0, w = 12, h = 6 }
}

run "defaults" {
  command = plan

  assert {
    condition     = output.panel.type == "timeseries"
    error_message = "Default panel type must be timeseries."
  }

  assert {
    condition     = output.panel.datasource == { uid = "ds-uid", type = "grafana-testdata-datasource" }
    error_message = "Datasource must be passed through as { uid, type }."
  }

  assert {
    condition     = output.panel.options.legend.displayMode == "list" && !contains(keys(output.panel), "legend")
    error_message = "Legend must live under options, not at the panel root."
  }

  assert {
    condition     = output.panel.targets == [{ refId = "A" }]
    error_message = "Default targets must be a single query A."
  }
}
