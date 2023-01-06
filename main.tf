provider "docker" {
  host = "tcp://192.168.99.100:2375/"
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "app_network" {
  name = "bgapp"
}

resource "docker_image" "bgapp-web" {
  name = "naskodlg/bgapp-web:ansible"
}

resource "docker_image" "bgapp-db" {
  name = "naskodlg/bgapp-db:ansible"
}

resource "docker_container" "con-web" {
  name = "web"
  image = docker_image.bgapp-web.latest
  ports {
    internal = "80"
    external = "8080"
  }
  networks_advanced {
    name = "bgapp"
  }
}

resource "docker_container" "con-db" {
  name = "db"
  image = docker_image.bgapp-db.latest
  networks_advanced {
    name = "bgapp"
  }
  env = [ "MYSQL_ROOT_PASSWORD=12345" ]
}
