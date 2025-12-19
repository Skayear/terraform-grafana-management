variable "type" {
  default = "timeseries"
  type = string
}

variable "title" {
  default = "title_example"
  type = string
}

variable "datasource" {
  default = "datasource"
  type = any
}

variable "gridPos" {
  default = {
    "x": 0,
    "y": 0,
    "h": 0,
    "w": 0
  }
  type = object({
    x = number
    y = number
    h = number
    w = number
  })
}

variable "targets" {
  type = any
}

# Options

variable "mode" {
  default = "single"
  type = string
}

variable "sort" {
  default = "none"
  type = string 
}

variable "hideZeros" {
  default = false
  type = bool
}

# Legend

variable "showLegend" {
  default = true
  type = bool
}

variable "dispĺayMode" {
  default = "list"
  type = string
}

variable "placement" {
  default = "bottom"
  type = string
}

output "text_panel" {
  value = {
    "type": var.type,
    "title": var.title,
    "gridPos": var.gridPos,
    "targets": var.targets,
    "options": {
      "tooltip": {
        "mode": var.mode,
        "sort": var.sort,
        "hideZeros": var.hideZeros,
      }
    },
    "legend": {
      "showLegend": var.showLegend,
      "displayMode": var.dispĺayMode,
      "placement": var.placement
    },
    "datasource": {
      "uid": var.datasource,
      "type": "datasource"
    }
  }
}