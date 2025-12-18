variable "type" {
  default = "text"
}

variable "title" {
  default = "title_example"
}

variable "gridPos" {
  default = {
    "x": 0,
    "y": 0,
    "h": 0,
    "w": 0
  }
}

variable "content" {
  default = "Text Content default"
}

# Options

variable "mode" {
  default = "markdown"
  description = "markdown, html, json"
}

output "text_panel" {
  value = {
    "type": var.type,
    "title": var.title,
    "gridPos": var.gridPos,
    "options": {
      "mode": var.mode,
      "code": {
        "language": "plaintext",
        "showLineNumbers": false,
        "showMiniMap": false
      },
      "content": var.content
    }
  }
}