variable "path" {
  description = <<-EOT
    Directory that mirrors the Grafana folder tree. Each folder is a directory named
    after the folder UID containing a _folder.json ({"title": "..."}); every other
    *.json file is a dashboard model and must have a "uid". Dashboards at the top
    level go to the General folder.
  EOT
  type        = string
}
