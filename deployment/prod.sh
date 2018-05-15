# la funcion que muestra el mensaje de areas
# se necesita declarar primero sino, marcara errores en su invocacion
mensaje () {
    echo ""
    echo "************************************************************"
    echo "\t $1"
    echo "************************************************************"
    echo ""
}
# COMIENZA EL PEDO
# nada mas para que se vea mejor y para saber que esta pasando
mensaje "Descargamos Packer Y Terraform"

# descargamos packer en /tmp/packer.zip
wget -O /tmp/packer.zip https://releases.hashicorp.com/packer/1.2.2/packer_1.2.2_linux_amd64.zip
# descargamos terraform en /tmp/terraform.zip
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.6/terraform_0.11.6_linux_amd64.zip

# nada mas para que se vea mejor y para saber que esta pasando
mensaje "Descomprecion de Packer Y Terraform"

# descomprimimos el /tmp/packer.zip en /bin
sudo unzip /tmp/packer.zip -d /bin
# descomprimimos el /tmp/terraform.zip en /bin
sudo unzip /tmp/terraform.zip -d /bin

# nada mas para que se vea mejor y para saber que esta pasando
mensaje "Validamos y Buldeamos template packer"

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
mensaje "Validamos y Aplicamos Infrastructura Terraform"

# entramos a la carpeta
cd infra && 
# esto inicializa un terraform (como lo meti en gitignore es necesario hacer eso)
terraform init -input=false -backend-config "access_key=$TF_VAR_access_key" -backend-config "secret_key=$TF_VAR_secret_key" && 
# aplicamos el "-input=false" para, literal hace lo que dice... y el "-auto-approve" es para que no pida confirmacion
terraform apply -input=false -auto-approve &&
# regresamos a la raiz
cd ..

# nada mas para que se vea mejor y para saber que esta pasando
mensaje "Commit de los cambios"

echo "Deploy: 
        Date:$(date)
        CircleBuildNum:$CIRCLE_BUILD_NUM
        idShapshot:$TF_VAR_image_id" >> deployment/DeploymentTimes.txt
        
git config --global user.email "circle-ci@cricle-deploy.com" &&
git config --global user.name "Circle CI Script" &&
git add * && 
git commit -m "Deployed snapshot-devops-template-$CIRCLE_BUILD_NUM [skip ci]" &&
git push origin master

mensaje "Deployed and saved"