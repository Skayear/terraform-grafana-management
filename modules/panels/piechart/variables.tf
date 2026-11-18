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
  description = "Panel queries. Each series becomes one slice."
  type        = any
  default     = [{ refId = "A" }]
}

variable "pieType" {
  description = "Chart style: pie or donut."
  type        = string
  default     = "pie"
}

variable "calcs" {
  description = "Reducers used to turn each series into a slice value (e.g. lastNotNull, sum)."
  type        = list(string)
  default     = ["lastNotNull"]
}

variable "displayLabels" {
  description = "Labels drawn on the slices: any of name, value, percent."
  type        = list(string)
  default     = ["percent"]
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
  default     = "right"
}
