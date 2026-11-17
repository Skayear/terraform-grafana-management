variable "type" {
  description = "Grafana panel type."
  type        = string
  default     = "timeseries"
}

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

# Tooltip

variable "mode" {
  description = "Tooltip mode: single, multi or none."
  type        = string
  default     = "single"
}

variable "sort" {
  description = "Tooltip sort order: none, asc or desc."
  type        = string
  default     = "none"
}

variable "hideZeros" {
  description = "Hide zero values in the tooltip."
  type        = bool
  default     = false
}

# Legend

variable "showLegend" {
  description = "Show the panel legend."
  type        = bool
  default     = true
}

variable "displayMode" {
  description = "Legend display mode: list, table or hidden."
  type        = string
  default     = "list"
}

variable "placement" {
  description = "Legend placement: bottom or right."
  type        = string
  default     = "bottom"
}
