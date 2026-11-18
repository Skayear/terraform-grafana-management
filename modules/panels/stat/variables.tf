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

variable "unit" {
  description = "Grafana unit id for the values (e.g. percent, ms, bytes, short)."
  type        = string
  default     = "short"
}

variable "thresholds" {
  description = "Absolute threshold steps. The first step is the base and has value null."
  type = list(object({
    color = string
    value = number
  }))
  default = [
    { color = "green", value = null },
    { color = "red", value = 80 },
  ]
}

variable "calcs" {
  description = "Reducers used to turn each series into a single value (e.g. lastNotNull, mean, max)."
  type        = list(string)
  default     = ["lastNotNull"]
}

variable "colorMode" {
  description = "What gets the threshold color: value, background or none."
  type        = string
  default     = "value"
}

variable "graphMode" {
  description = "Sparkline behind the value: area or none."
  type        = string
  default     = "area"
}
