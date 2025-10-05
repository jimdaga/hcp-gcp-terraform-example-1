.PHONY: region help clean-venv

VENV := .venv
PYTHON := $(VENV)/bin/python3
PIP := $(VENV)/bin/pip3

help:
	@echo "Available commands:"
	@echo "  make region      - Create directory structure for all regions defined in regions.yaml"
	@echo "  make clean-venv  - Remove virtual environment"

$(VENV):
	@python3 -m venv $(VENV)
	@$(PIP) install -q --upgrade pip
	@$(PIP) install -q -r requirements.txt
	@echo "Virtual environment created and dependencies installed"

region: $(VENV)
	@$(PYTHON) hack/create_regions.py

clean-venv:
	@rm -rf $(VENV)
	@echo "Virtual environment removed"
