variable "datasource" {
  description = "Datasource used by the dashboard's query panels."
  type = object({
    uid  = string
    type = string
  })
}

variable "folder_uid" {
  description = "UID of the folder that holds the dashboard."
  type        = string
}
