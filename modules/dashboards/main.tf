locals {
  # Folders: one directory per folder, named by UID, holding a _folder.json.
  folders = {
    for f in fileset(var.path, "**/_folder.json") :
    basename(dirname(f)) => {
      title  = jsondecode(file("${var.path}/${f}")).title
      depth  = length(split("/", dirname(f)))
      parent = length(split("/", dirname(f))) > 1 ? basename(dirname(dirname(f))) : null
    }
  }

  # Dashboards: every other JSON file, keyed by its dashboard UID.
  dashboards = {
    for f in fileset(var.path, "**/*.json") :
    jsondecode(file("${var.path}/${f}")).uid => {
      file   = "${var.path}/${f}"
      folder = dirname(f) == "." ? null : basename(dirname(f))
    }
    if basename(f) != "_folder.json"
  }

  folder_uids = merge(
    { for k, f in grafana_folder.level1 : k => f.uid },
    { for k, f in grafana_folder.level2 : k => f.uid },
    { for k, f in grafana_folder.level3 : k => f.uid },
    { for k, f in grafana_folder.level4 : k => f.uid },
  )
}

# Nested folders are split by depth so each level is created after its parent.
# Grafana allows at most 4 levels of nesting.

resource "grafana_folder" "level1" {
  for_each = { for k, f in local.folders : k => f if f.depth == 1 }

  uid                          = each.key
  title                        = each.value.title
  prevent_destroy_if_not_empty = true
}

resource "grafana_folder" "level2" {
  for_each = { for k, f in local.folders : k => f if f.depth == 2 }

  uid                          = each.key
  title                        = each.value.title
  parent_folder_uid            = grafana_folder.level1[each.value.parent].uid
  prevent_destroy_if_not_empty = true
}

resource "grafana_folder" "level3" {
  for_each = { for k, f in local.folders : k => f if f.depth == 3 }

  uid                          = each.key
  title                        = each.value.title
  parent_folder_uid            = grafana_folder.level2[each.value.parent].uid
  prevent_destroy_if_not_empty = true
}

resource "grafana_folder" "level4" {
  for_each = { for k, f in local.folders : k => f if f.depth == 4 }

  uid                          = each.key
  title                        = each.value.title
  parent_folder_uid            = grafana_folder.level3[each.value.parent].uid
  prevent_destroy_if_not_empty = true
}

resource "grafana_dashboard" "this" {
  for_each = local.dashboards

  config_json = file(each.value.file)
  folder      = each.value.folder == null ? null : local.folder_uids[each.value.folder]
}
