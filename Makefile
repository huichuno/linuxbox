all: check build clean

.PHONY: check
check:
	@docker --version || (echo "'docker --version' return code: $$?. Make sure docker is installed"; exit 1)  

.PHONY: build
build:
	@echo "Building linux kernel"
	@if [ -f .config ]; then rm -f .config; fi;
	@./download.sh
	@docker build -t linux_box:latest .
	@echo "Copying built artifacts to local build/ folder"
	@if [ -d build ]; then rm -rf build; fi;
	@docker create --name linux_box_inst linux_box
	@docker cp linux_box_inst:/build build
	@docker rm -f linux_box_inst

.PHONY: install
install:
	@./install.sh

.PHONY: clean
clean:
	@echo "Cleaning up"
	@docker rmi -f linux_box:latest 2>/dev/null
	@rm -f .config
	@rm -rf build

.PHONY: help
help:
	@echo "Targets:"
	@echo "  all            - check, build, clean"
	@echo "  check          - Basic sanity check"
	@echo "  build          - Build linux kernel"
	@echo "  install        - Install artifacts"
	@echo "  clean          - Delete linux_box docker image and temp files"
	@echo ""
