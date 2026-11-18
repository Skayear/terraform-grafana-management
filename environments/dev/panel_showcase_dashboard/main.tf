resource "grafana_dashboard" "showcase" {
  folder = var.folder_uid

  config_json = jsonencode({
    title         = "Panel Showcase (Terraform)"
    uid           = "panel-showcase-terraform"
    schemaVersion = 38
    version       = 1
    time = {
      from = "now-6h"
      to   = "now"
    }

    panels = [
      module.header.panel,
      module.requests_stat.panel,
      module.cpu_gauge.panel,
      module.traffic_piechart.panel,
      module.latency_timeseries.panel,
      module.orders_barchart.panel,
      module.services_table.panel,
    ]
  })
}

#######################
# Grafana Panels
#######################

module "header" {
  source = "../../../modules/panels/text"

  title   = "Panel Showcase"
  content = "Un panel de cada tipo soportado por `modules/panels`, con datos de TestData."

  gridPos = { x = 0, y = 0, w = 24, h = 3 }
}

module "requests_stat" {
  source = "../../../modules/panels/stat"

  title      = "Requests / s"
  datasource = var.datasource
  unit       = "reqps"
  thresholds = [
    { color = "green", value = null },
    { color = "orange", value = 60 },
    { color = "red", value = 85 },
  ]
  targets = [{
    refId       = "A"
    scenarioId  = "random_walk"
    seriesCount = 1
    startValue  = 50
    min         = 0
    max         = 100
  }]

  gridPos = { x = 0, y = 3, w = 6, h = 6 }
}

module "cpu_gauge" {
  source = "../../../modules/panels/gauge"

  title      = "CPU"
  datasource = var.datasource
  unit       = "percent"
  targets = [{
    refId       = "A"
    scenarioId  = "random_walk"
    seriesCount = 1
    startValue  = 60
    min         = 0
    max         = 100
  }]

  gridPos = { x = 6, y = 3, w = 6, h = 6 }
}

module "traffic_piechart" {
  source = "../../../modules/panels/piechart"

  title         = "Tráfico por servicio"
  datasource    = var.datasource
  pieType       = "donut"
  displayLabels = ["name", "percent"]
  targets = [
    { refId = "A", scenarioId = "csv_metric_values", alias = "web", stringInput = "40,42,45" },
    { refId = "B", scenarioId = "csv_metric_values", alias = "api", stringInput = "30,28,33" },
    { refId = "C", scenarioId = "csv_metric_values", alias = "worker", stringInput = "10,12,9" },
  ]

  gridPos = { x = 12, y = 3, w = 12, h = 6 }
}

module "latency_timeseries" {
  source = "../../../modules/panels/graph"

  title       = "Latencia (3 series)"
  datasource  = var.datasource
  mode        = "multi"
  displayMode = "table"
  placement   = "right"
  targets = [{
    refId       = "A"
    scenarioId  = "random_walk"
    seriesCount = 3
  }]

  gridPos = { x = 0, y = 9, w = 12, h = 8 }
}

module "orders_barchart" {
  source = "../../../modules/panels/barchart"

  title      = "Pedidos por día"
  datasource = var.datasource
  stacking   = "normal"
  targets = [{
    refId      = "A"
    scenarioId = "csv_content"
    csvContent = <<-CSV
      dia,pedidos,devoluciones
      Lun,120,8
      Mar,135,6
      Mié,128,11
      Jue,150,9
      Vie,172,14
    CSV
  }]

  gridPos = { x = 12, y = 9, w = 12, h = 8 }
}

module "services_table" {
  source = "../../../modules/panels/table"

  title      = "Estado de servicios"
  datasource = var.datasource
  sortBy     = [{ displayName = "latencia_ms", desc = true }]
  targets = [{
    refId      = "A"
    scenarioId = "csv_content"
    csvContent = <<-CSV
      servicio,estado,latencia_ms,uptime_pct
      web,OK,42,99.98
      api,OK,87,99.95
      worker,DEGRADED,310,98.70
      db,OK,12,99.99
    CSV
  }]

  gridPos = { x = 0, y = 17, w = 24, h = 8 }
}
