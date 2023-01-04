provider "pcf" {
  api_endpoint = "API_ENDPOINT"
  username     = "seckndanane"
  password     = "Babacar980"
}

resource "pcf_org" "example" {
  name = "example-org"
}

resource "pcf_space" "example" {
  name     = "example-space"
  org_guid = pcf_org.example.id
}

resource "pcf_app" "example" {
  name               = "example-app"
  space_guid         = pcf_space.example.id
  buildpack          = "BUILDPACK"
  path               = "app.zip"
  memory             = "512M"
  instances          = 1
  disk_quota         = "1024M"
  timeout            = 120
  health_check_type  = "port"
  route {
    domain = "DOMAIN"
    host   = "example-app"
  }
}
