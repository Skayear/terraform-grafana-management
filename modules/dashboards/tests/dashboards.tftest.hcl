mock_provider "grafana" {}

variables {
  path = "./tests/fixtures"
}

run "reads_folder_tree" {
  command = plan

  assert {
    condition     = keys(grafana_folder.level1) == ["team-a"] && keys(grafana_folder.level2) == ["team-a-services"]
    error_message = "Folders must be split by nesting depth."
  }

  assert {
    condition     = grafana_folder.level2["team-a-services"].title == "Servicios"
    error_message = "Folder title must come from _folder.json."
  }

  assert {
    condition     = length(grafana_folder.level3) == 0 && length(grafana_folder.level4) == 0
    error_message = "No folders expected below level 2."
  }

  assert {
    condition     = toset(keys(grafana_dashboard.this)) == toset(["home", "overview", "svc-api"])
    error_message = "Dashboards must be keyed by UID and _folder.json files must be skipped."
  }

  assert {
    condition     = grafana_dashboard.this["home"].folder == null
    error_message = "Top-level dashboards must go to the General folder."
  }
}

run "links_parents" {
  command = apply

  assert {
    condition     = grafana_folder.level2["team-a-services"].parent_folder_uid == grafana_folder.level1["team-a"].uid
    error_message = "Nested folders must point to their parent folder."
  }

  assert {
    condition     = grafana_dashboard.this["svc-api"].folder == grafana_folder.level2["team-a-services"].uid
    error_message = "Dashboards must be placed in the folder of their directory."
  }

  assert {
    condition     = grafana_folder.level1["team-a"].prevent_destroy_if_not_empty
    error_message = "Folders must refuse to be destroyed while they still hold dashboards."
  }
}
