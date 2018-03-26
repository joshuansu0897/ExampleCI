resource "digitalocean_droplet" "web" {
  image    = "32928393"
  name     = "tf-demo-devops"
  region   = "sfo2"
  size     = "512mb"
  ssh_keys = [19491775]

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
