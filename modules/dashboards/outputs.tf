output "folder_uids" {
  description = "UIDs of the managed folders."
  value       = keys(local.folder_uids)

  precondition {
    condition     = alltrue([for f in local.folders : f.depth <= 4])
    error_message = "Grafana supports at most 4 levels of nested folders."
  }
}

output "dashboard_urls" {
  description = "Dashboard URLs keyed by dashboard UID."
  value       = { for k, d in grafana_dashboard.this : k => d.url }
}
