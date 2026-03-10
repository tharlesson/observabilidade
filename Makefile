SHELL := /bin/bash

ENV ?= dev

.PHONY: bootstrap-local up-local down-local logs-local validate lint deploy destroy plan fmt

bootstrap-local:
	./scripts/bootstrap-local-lab.sh

up-local:
	./scripts/up-local-lab.sh

down-local:
	./scripts/destroy.sh local-lab

logs-local:
	docker compose -f docker-compose/local-lab/docker-compose.yml logs -f

validate:
	./scripts/validate.sh

lint:
	./scripts/lint.sh

fmt:
	terraform -chdir=terraform fmt -recursive

plan:
	terraform -chdir=terraform/environments/$(ENV) init -backend-config=backend.hcl
	terraform -chdir=terraform/environments/$(ENV) plan

deploy:
	./scripts/deploy.sh $(ENV)

destroy:
	./scripts/destroy.sh $(ENV)

deploy-dev:
	$(MAKE) deploy ENV=dev

deploy-stage:
	$(MAKE) deploy ENV=stage

deploy-prod:
	$(MAKE) deploy ENV=prod

destroy-dev:
	$(MAKE) destroy ENV=dev

destroy-stage:
	$(MAKE) destroy ENV=stage

destroy-prod:
	$(MAKE) destroy ENV=prod
