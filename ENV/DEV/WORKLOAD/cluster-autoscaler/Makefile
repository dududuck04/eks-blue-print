CURRENT_DATE = $(shell date +%y%m%d%H%M%S)
PROFILE_NAME=hae-ccs-prd
ENV_NAME=an2-kkm

init:
	AWS_PROFILE=$(PROFILE_NAME) terraform init --upgrade 2>&1 | tee results/init-$(ENV_NAME)-output-$(CURRENT_DATE).log

plan:
	AWS_PROFILE=$(PROFILE_NAME) terraform plan -var-file=env/$(ENV_NAME).tfvars  2>&1 | tee results/plan-$(ENV_NAME)-output-$(CURRENT_DATE).log

apply:
	AWS_PROFILE=$(PROFILE_NAME) terraform apply -auto-approve -var-file=env/$(ENV_NAME).tfvars 2>&1 | tee results/apply-$(ENV_NAME)-output-$(CURRENT_DATE).log

destroy:
	AWS_PROFILE=$(PROFILE_NAME) terraform destroy -auto-approve -var-file=env/$(ENV_NAME).tfvars 2>&1 | tee results/destroy-$(ENV_NAME)-output-$(CURRENT_DATE).log

clean:
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -rf terraform.tfstate*