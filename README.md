# azure_vmss_lb

Virtual Machine Scale Set behind a Load Balancer and a test site with Hello World and Virtual Machine Host Name

To deploy using this repo, please following the steps listed below

* Clone the entire repo *"**git clone https://github.com/falowomi-azuremodules/azure_vmss_lb azure_vmss_lb**"*
* Change directory to vmss_module *"**cd azure_vmss_lb/vmss_module**"*
* Modify the deploy.tfvars file with the values or your choosing.
* Run terraform commands initialization *"**terraform init**"*
* Terraform plan to confirm the resource that are going to be deployed *"**terraform plan -var-file=deploy.tfvars**"*
* Finally deploy *"**terraform apply -var-file=deploy.tfvars**"*
* Once the depoyment is completed, look for the displayed url from the terraform output value and browse your site.