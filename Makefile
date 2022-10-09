.PHONY: init
init:
	@terraform init
	@cp terraform.tfvars.example terraform.tfvars

.PHONY: plan
plan:
	@terraform plan -var-file="terraform.tfvars"

.PHONY: apply
apply:
	@terraform apply -auto-approve -var-file="terraform.tfvars"

.PHONY: destroy
destroy:
	@terraform destroy -var-file="terraform.tfvars"
