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
  description = "Panel queries. The result needs a string or time field for the X axis."
  type        = any
  default     = [{ refId = "A" }]
}

variable "orientation" {
  description = "Bar orientation: auto, horizontal or vertical."
  type        = string
  default     = "auto"
}

variable "stacking" {
  description = "Stacking mode: none, normal or percent."
  type        = string
  default     = "none"
}

variable "showValue" {
  description = "Show values on the bars: auto, always or never."
  type        = string
  default     = "auto"
}

# Legend

variable "showLegend" {
  description = "Show the panel legend."
  type        = bool
  default     = true
}

variable "placement" {
  description = "Legend placement: bottom or right."
  type        = string
  default     = "bottom"
}
