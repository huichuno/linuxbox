all: check build clean

.PHONY: check
check:
	@docker --version || (echo "'docker --version' return code: $$?. Make sure docker is installed"; exit 1)  

.PHONY: build
build:
	@echo "Build linux_box image and linux kernel"
	@./download.sh
	@docker build -t linux_box:latest .
	@rm -f .config
	@echo "Copy artifacts to local build/ folder"
	@if [[ -d build ]]; then rm -rf build; fi;
	@docker create --name linux_box_inst linux_box
	@docker cp linux_box_inst:/build build
	@docker rm -f linux_box_inst

.PHONY: install
install:
	@echo "Install linux kernel"
	@./install.sh

.PHONY: clean
clean:
	@echo "Delete linux_box image" 
	@docker rmi -f linux_box:latest
	@rm -f .config
	@rm -rf build

.PHONY: help
help:
	@echo "Targets:"
	@echo "  all            - Check, Build, Clean"
	@echo "  check          - Basic sanity check"
	@echo "  build          - Build linux_box docker image and linux kernel artifacts"
	@echo "  install        - Install artifacts"
	@echo "  clean          - Delete linux_box docker image"
	@echo ""
