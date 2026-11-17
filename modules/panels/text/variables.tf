variable "type" {
  description = "Grafana panel type."
  type        = string
  default     = "text"
}

variable "title" {
  description = "Panel title."
  type        = string
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

variable "content" {
  description = "Panel content."
  type        = string
}

variable "mode" {
  description = "Content mode: markdown, html or code."
  type        = string
  default     = "markdown"
}
