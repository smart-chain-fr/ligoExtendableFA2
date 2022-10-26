SHELL := /bin/bash

help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

ifndef LIGO
LIGO=docker run -u $(id -u):$(id -g) --rm -v "$(PWD)":"$(PWD)" -w "$(PWD)" ligolang/ligo:0.53.0
endif
# ^ use LIGO en var bin if configured, otherwise use docker

compile = $(LIGO) compile contract --project-root ./lib ./lib/$(1) -o ./compiled/$(2) $(3) 
# ^ Compile contracts to Michelson or Micheline

test = @$(LIGO) run test $(project_root) ./test/$(1)
# ^ run given test file

compile: ##@Contracts - Compile LIGO contracts
	@if [ ! -d ./compiled ]; then mkdir ./compiled ; fi
	@echo "Compiling contracts..."
	@$(call compile,single_asset/fa2.mligo,fa2.single_asset.tz)
	@$(call compile,single_asset/fa2.mligo,fa2.single_asset.json,--michelson-format json)
	@$(call compile,multi_asset/fa2.mligo,fa2.multi_asset.tz)
	@$(call compile,multi_asset/fa2.mligo,fa2.multi_asset.json,--michelson-format json)


.PHONY: test
test: ## run tests (SUITE=single_asset make test)
ifndef SUITE
	@$(call test,single_asset.test.mligo)
	@$(call test,multi_asset.test.mligo)
else
	@$(call test,$(SUITE).test.mligo)
endif

publish: ## publish package on packages.ligolang.org
	@$(LIGO) publish