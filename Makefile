CURRENT_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TF_EXAMPLES = $(sort $(dir $(wildcard $(CURRENT_DIR)examples/*/)))
TF_PROJECTS = "."

# -------------------------------------------------------------------------------------------------
# Terraform configuration
# -------------------------------------------------------------------------------------------------
TF_VERSION = 0.15.5


# -------------------------------------------------------------------------------------------------
# Terraform-docs configuration
# -------------------------------------------------------------------------------------------------
TFDOCS_VERSION = 0.16.0-0.31

# Adjust your delimiter here or overwrite via make arguments
TFDOCS_DELIM_START = <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
TFDOCS_DELIM_CLOSE = <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

help:
	@echo "         _                       __                     "
	@echo "        | |                     / _|                    "
	@echo "        | |_ ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___  "
	@echo "        | __/ _ \ '__| '__/ _  |  _/ _ \| '__| '_   _ \ "
	@echo "        | ||  __/ |  | | | (_| | || (_) | |  | | | | | |"
	@echo "         \__\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_|"
	@echo
	@echo
	@echo "Meta targets"
	@echo "--------------------------------------------------------------------------------"
	@echo "  help                 Show this help screen"
	@echo
	@echo "Read-only targets"
	@echo "--------------------------------------------------------------------------------"
	@echo "  lint       Static source code analysis"
	@echo "  test       Integration tests"
	@echo
	@echo "Writing targets"
	@echo "--------------------------------------------------------------------------------"
	@echo "  terraform-docs       Run terraform-docs against all README.md files"
	@echo "  terraform-fmt        Run terraform-fmt against *.tf and *.tfvars files"


lint:
	@# Lint all Terraform files
	@echo "################################################################################"
	@echo "# Terraform fmt"
	@echo "################################################################################"
	@if docker run $$(tty -s && echo "-it" || echo) --rm \
	  -v "$(CURRENT_DIR):/t:ro" --workdir "/t" hashicorp/terraform:$(TF_VERSION) \
		fmt -check=true -diff=true -write=false -list=true .; then \
		echo "OK"; \
	else \
		echo "Failed"; \
		exit 1; \
	fi;
	@echo


test:
	@$(foreach example,\
		$(TF_EXAMPLES),\
		DOCKER_PATH="/t/examples/$(notdir $(patsubst %/,%,$(example)))"; \
		echo "################################################################################"; \
		echo "# Terraform init:  $${DOCKER_PATH}"; \
		echo "################################################################################"; \
		if docker run $$(tty -s && echo "-it" || echo) --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" hashicorp/terraform:$(TF_VERSION) \
			init \
				-upgrade=true \
				-reconfigure \
				-input=false \
				-get=true; then \
			echo "OK"; \
		else \
			echo "Failed"; \
			docker run $$(tty -s && echo "-it" || echo) --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" --entrypoint=rm hashicorp/terraform:$(TF_VERSION) -rf .terraform/ || true; \
			exit 1; \
		fi; \
		echo; \
	)
	@$(foreach example,\
		$(TF_EXAMPLES),\
		DOCKER_PATH="/t/examples/$(notdir $(patsubst %/,%,$(example)))"; \
		echo "################################################################################"; \
		echo "# Terraform validate:  $${DOCKER_PATH}"; \
		echo "################################################################################"; \
		if docker run $$(tty -s && echo "-it" || echo) --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" hashicorp/terraform:$(TF_VERSION) \
			validate \
				.; then \
			echo "OK"; \
			docker run $$(tty -s && echo "-it" || echo) --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" --entrypoint=rm hashicorp/terraform:$(TF_VERSION) -rf .terraform/ || true; \
		else \
			echo "Failed"; \
			docker run $$(tty -s && echo "-it" || echo) --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" --entrypoint=rm hashicorp/terraform:$(TF_VERSION) -rf .terraform/ || true; \
			exit 1; \
		fi; \
		echo; \
	)

# -------------------------------------------------------------------------------------------------
# Writing Targets
# -------------------------------------------------------------------------------------------------

terraform-docs: _pull-tfdocs
	@echo "################################################################################"
	@echo "# Terraform-docs generate"
	@echo "################################################################################"
	@echo
	@$(foreach project,\
		$(TF_PROJECTS),\
		echo "------------------------------------------------------------"; \
		echo "# $(project)"; \
		echo "------------------------------------------------------------"; \
		if docker run $$(tty -s && echo "-it" || echo) --rm \
			-v $(CURRENT_DIR):/data \
			-e TFDOCS_DELIM_START='$(TFDOCS_DELIM_START)' \
			-e TFDOCS_DELIM_CLOSE='$(TFDOCS_DELIM_CLOSE)' \
			cytopia/terraform-docs:$(TFDOCS_VERSION) \
			terraform-docs-replace --sort-by required markdown README.md; then \
			echo "OK"; \
		else \
			echo "Failed"; \
			exit 1; \
		fi; \
	)

terraform-fmt: _WRITE=true
terraform-fmt: _pull-tf
	@# Lint all Terraform files
	@echo "################################################################################"
	@echo "# Terraform fmt"
	@echo "################################################################################"
	@echo
	@echo "------------------------------------------------------------"
	@echo "# *.tf files"
	@echo "------------------------------------------------------------"
	@if docker run $$(tty -s && echo "-it" || echo) --rm \
		-v "$(CURRENT_DIR):/data" hashicorp/terraform:$(TF_VERSION) fmt \
			$$(test "$(_WRITE)" = "false" && echo "-check=true" || echo "-write=true") \
			-recursive \
			-diff=true \
			-list=true \
			/data; then \
		echo "OK"; \
	else \
		echo "Failed"; \
		exit 1; \
	fi;
	@echo

# -------------------------------------------------------------------------------------------------
# Helper Targets
# -------------------------------------------------------------------------------------------------

_pull-tf:
	docker pull hashicorp/terraform:$(TF_VERSION)

_pull-tfdocs:
	docker pull cytopia/terraform-docs:$(TFDOCS_VERSION)
