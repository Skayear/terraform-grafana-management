variable "datasource" {
  description = "Datasource used by the dashboard's query panels."
  type = object({
    uid  = string
    type = string
  })
}
