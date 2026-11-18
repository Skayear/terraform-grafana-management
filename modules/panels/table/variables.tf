variable "title" {
  description = "Panel title."
  type        = string
}

variable "datasource" {
  description = "Datasource reference used by the panel targets."
  type = object({
    uid  = string
    type = string
  })
}

variable "gridPos" {
  description = "Panel position and size on the dashboard grid (24 columns wide)."
  type = object({
    x = number
    y = number
    w = number
    h = number
  })
}

variable "targets" {
  description = "Panel queries. Their shape depends on the datasource."
  type        = any
  default     = [{ refId = "A" }]
}

variable "showHeader" {
  description = "Show the column header row."
  type        = bool
  default     = true
}

variable "sortBy" {
  description = "Initial sort, as a list of { displayName, desc }."
  type = list(object({
    displayName = string
    desc        = bool
  }))
  default = []
}
