# nada mas para que se vea mejor y para saber que esta pasando
echo "**********************************"
echo "* Descargamos Packer Y Terraform *"
echo "**********************************"
echo ""

# descargamos packer en /tmp/packer.zip
wget -O /tmp/packer.zip https://releases.hashicorp.com/packer/1.2.2/packer_1.2.2_linux_amd64.zip
# descargamos terraform en /tmp/terraform.zip
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.6/terraform_0.11.6_linux_amd64.zip

# nada mas para que se vea mejor y para saber que esta pasando
echo "***************************************"
echo "* Descomprecion de Packer Y Terraform *"
echo "***************************************"
echo ""

# descomprimimos el /tmp/packer.zip en /bin
sudo unzip /tmp/packer.zip -d /bin
# descomprimimos el /tmp/terraform.zip en /bin
sudo unzip /tmp/terraform.zip -d /bin

# nada mas para que se vea mejor y para saber que esta pasando
echo "*****************************************"
echo "* Validamos y Buldeamos template packer *"
echo "*****************************************"
echo ""

# validamos el template para apcker
packer validate deployment/template.json &&
# buldeamos el template
packer build deployment/template.json &&

# guardamos el "ID" de la imagen recien buldeada y se guarda en la variable "TF_VAR_image_id" esta variable es necesaria porque terraform la tomara para saber que imagen usar para los droplets
export TF_VAR_image_id=$(curl -H "Authorization: Bearer $DIGITALOCEAN_API_TOKEN" "https://api.digitalocean.com/v2/images?&private=true" | jq ."images[] | select(.name == \"snapshot-devops-template-$CIRCLE_BUILD_NUM\") | .id")

# nada mas para que se vea mejor y para saber que esta pasando
echo ""
echo "el ID de snapshot-devops-template-$CIRCLE_BUILD_NUM es: $TF_VAR_image_id"
echo ""

# nada mas para que se vea mejor y para saber que esta pasando
echo "**************************************************"
echo "* Validamos y Aplicamos Infrastructura Terraform *"
echo "**************************************************"
echo ""

# entramos a la carpeta
cd infra && 
# aplicamos el "-input=false" para, literal hace lo que dice... y el "-auto-approve" es para que no pida confirmacion
terraform apply -input=false -auto-approve &&
# regresamos a la raiz
cd ..

# nada mas para que se vea mejor y para saber que esta pasando
echo "*************************"
echo "* Commit de los cambios *"
echo "*************************"
echo ""

git config --global user.email "circle-ci@cricle-deploy.com" &&
git config --global user.name "Circle CI Script" &&
git add infra && 
git commit -m "Deployed snapshot-devops-template-$CIRCLE_BUILD_NUM [skip ci]" &&
git push origin master

echo "**********************"
echo "* Deployed and saved *"
echo "**********************"