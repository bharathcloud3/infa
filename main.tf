resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-poc-rg"
  location = var.location
  tags = {
    environment = var.environment
  }
}

resource "azurerm_app_service_plan" "webapp" {
  name                = "${var.prefix}-${var.environment}-poc-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Basic"
    size = "B1"
    capacity = "1"
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.prefix}-${var.environment}-poc-appins"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  tags = {
    environment = var.environment
  }
}

resource "azurerm_app_service" "webservice" {
  name                = "${var.prefix}-${var.environment}-poc-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id =  azurerm_app_service_plan.webapp.id
  https_only          = true
  site_config {
    always_on          = true
    http2_enabled      = true
    use_32_bit_worker_process = false
    dotnet_framework_version = "v5.0"
    windows_fx_version = "DOTNETCORE|5.0"
  }
  app_settings = {
    "DOTNET_ENVRONMENT"                               = "${var.environment}"
     "APPLICATION_INSIGHTS_IKEY"                      = "${azurerm_application_insights.appinsights.instrumentation_key}"
    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = "${azurerm_application_insights.appinsights.instrumentation_key}"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"           = "${azurerm_application_insights.appinsights.connection_string}"

  }
  tags = {
    environment = var.environment
  }
  identity{
      type = "SystemAssigned"
  }
}