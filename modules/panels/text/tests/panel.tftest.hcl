run "markdown" {
  command = plan

  variables {
    title   = "Test"
    content = "# Hola"
    gridPos = { x = 0, y = 0, w = 24, h = 3 }
  }

  assert {
    condition     = output.panel.type == "text"
    error_message = "Panel type must be text."
  }

  assert {
    condition     = output.panel.options.mode == "markdown" && output.panel.options.content == "# Hola"
    error_message = "Content and default markdown mode must be rendered under options."
  }
}
