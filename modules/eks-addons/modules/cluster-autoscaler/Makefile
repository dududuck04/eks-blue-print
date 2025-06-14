.PHONY: init
init: hcseo_init
hcseo_init:
	terraform init -backend-config=env/an2-hcseo.hcl -reconfigure -upgrade

.PHONY: plan
plan: hcseo_plan
hcseo_plan:
	terraform plan -var-file=env/an2-hcseo.tfvars

.PHONY: apply
apply: hcseo_apply
hcseo_apply:
	terraform apply -var-file=env/an2-hcseo.tfvars

.PHONY: apply_all
.PHONY: hcseo_apply_all
apply_all: hcseo_apply_all
hcseo_apply_all:
	terraform apply -var-file=env/an2-hcseo.tfvars -auto-approve

.PHONY: destroy
destroy: hcseo_destroy
hcseo_destroy:
	terraform destroy -var-file=env/an2-hcseo.tfvars

.PHONY: clean
clean:
	rm -rf .terraform
	rm -rf .terraform.lock.hcl