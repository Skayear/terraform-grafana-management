module "text_welcome_example" {
  source = "../../../../../modules/panels/text"
  title = "Welcome Text - Example"

  gridPos = {
    x = 0
    y = 0
    w = 12
    h = 6
  }

  content = "🚀 Dashboard creado con Terraform"
  mode    = "markdown"

}