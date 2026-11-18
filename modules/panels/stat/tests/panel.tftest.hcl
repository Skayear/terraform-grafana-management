variables {
  title      = "Test"
  datasource = { uid = "ds-uid", type = "grafana-testdata-datasource" }
  gridPos    = { x = 0, y = 0, w = 12, h = 6 }
}

run "defaults" {
  command = plan

  assert {
    condition     = output.panel.type == "stat"
    error_message = "Panel type must be stat."
  }

  assert {
    condition     = output.panel.fieldConfig.defaults.thresholds.steps[0].value == null
    error_message = "The base threshold step must have value null."
  }

  assert {
    condition     = output.panel.options.reduceOptions.calcs == tolist(["lastNotNull"])
    error_message = "Default reducer must be lastNotNull."
  }
}
