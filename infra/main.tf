# Tag
resource "digitalocean_tag" "demo" {
  name = "DesdeTerraform"
}

# Droplet
resource "digitalocean_droplet" "demo" {
  # esto es para la cantidad de maquinas
  count = 2

  # el id de la imagen o snapshot
  image = "${var.image_id}"

  # nombre del droplet
  name = "tf-demo-devops"

  # region donde sera ejecutado sanfrancisco 2
  region = "sfo2"

  # tama;o que tendra el droplet
  size = "512mb"

  # el id del ssh a usar
  ssh_keys = [19491775]

  # asigando el tag al droplet
  tags = ["${digitalocean_tag.demo.id}"]

  # esto hace que cree primero los droplets y luego destruya lo que ya tiene (sin esto es al reves)
  lifecycle {
    create_before_destroy = true
  }

  # esto es un comando que ejecuta terraform, en este comando verificamos que los droplets respondan
  # en 160 segundos (no es la mejor formar digitalocean aun no lo integr)
  # agregar un ping
  #provisioner "local-exec" {
  #command = "sleep 160 && curl ${self.ipv4_address}:3000"
  #}

  # el codigo que ejecuta systemd para saber que esta docker corriendo y levantar el contenedor
  user_data = <<EOF
#cloud-config
coreos:
    units:
      - name: "devops.service"
        command: "start"
        content: |
          [Unit]
          Description=DevOps Demos Tera
          After=docker.service

          [Service]
          ExecStart=/usr/bin/docker run -d -p 3000:3000 devops-demo
EOF
}

# LoadBalancer
resource "digitalocean_loadbalancer" "demo" {
  name   = "lb-DesdeTerraform"
  region = "sfo2"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 3000
    target_protocol = "http"
  }

  healthcheck {
    port     = 3000
    protocol = "http"
    path     = "/"
  }

  # esto es para agregar por el id del droplet
  #droplet_ids = ["${digitalocean_droplet.demo.id}"]

  # esto es para agregar por el tag
  #droplet_tag = "DesdeTerraform" mejor el de abajo por si cambia
  droplet_tag = "${digitalocean_tag.demo.name}"
}
