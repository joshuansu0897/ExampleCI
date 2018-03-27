# Tag
resource "digitalocean_tag" "demo" {
  name = "DesdeTerraform"
}

# Droplet
resource "digitalocean_droplet" "demo" {
  # esto es para la cantidad de maquinas
  count = 3

  # el id de la imagen o snapshot
  image = "32928393"

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
