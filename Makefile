.PHONY: help clean test

PYTHON = python3

help:
	@echo "clean - remove all build, test, coverage and Python artifacts"
	@echo "test - run tests quickly with the default Python"
	@echo "coverage - check code coverage quickly with the default Python"
	@echo "lint - check style with flake8"
	@echo "install - install the package to the active Python's site-packages"
	@echo "uninstall - uninstall the package from the active Python's site-packages"

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf .eggs/
	find . -name '*.egg-info' -exec rm -rf {} +
	find . -name '*.egg' -exec rm -f {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -rf {} +

test:
	$(PYTHON) setup.py test

coverage:
	coverage run --source=your_package setup.py test
	coverage report
	coverage html

lint:
	flake8 your_package tests

install:
	$(PYTHON) setup.py install

uninstall:
	pip uninstall your_package

# .PHONY: help
# help: ## Show this help
# 	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

####################################################################################################################
# Setup containers

# build: ## Build project with compose
# 	docker compose -f docker-compose.yml -f docker-compose.dev.yml build

# up: ## Run project with compose
# 	docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# stop:
# 	docker compose -f docker-compose.yml -f docker-compose.dev.yml stop

# start:
# 	docker compose -f docker-compose.yml -f docker-compose.dev.yml start

# down:
# 	docker compose -f docker-compose.yml -f docker-compose.dev.yml down

# clean: ## Clean Reset project containers and volumes with compose
# 	docker compose down -v --remove-orphans | true
# 	docker compose rm -f | true
# 	docker volume rm price-navigator-warehouse price-navigator-backups-dir-for-warehouse | true


####################################################################################################################
# Testing, auto formatting, type checks, & Lint checks

# pytest: ## Run project tests
# 	docker exec -it price_navigator_local_django pytest -p no:warnings -v

# format: ## Format project code.
# 	docker exec price_navigator_local_django python -m black --config pyproject.toml .

# isort: ## Sort project imports.
# 	docker exec price_navigator_local_django isort .

# type:  ## Static typing check
# 	docker exec price_navigator_local_django mypy --ignore-missing-imports price_navigator/

# lint:  ## Lint project code.
# 	docker exec price_navigator_local_django flake8

# ci: isort format type lint pytest

####################################################################################################################
# Development

# sh-django:
# 	docker exec -ti price_navigator_local_django bash

# sh-db:
# 	docker exec -ti price_navigator_local_postgres bash

# verify-db-health:
# 	docker exec -ti price_navigator_local_postgres psql -U postgres -c 'SELECT 1;'

# psql-db:
# 	docker exec -ti price_navigator_local_postgres psql -U postgres

# check-migrations-state:
# 	docker compose  -f docker-compose.yml -f docker-compose.dev.yml exec django python manage.py showmigrations -l --verbosity 2

# createsuperuser:
# 	docker compose  -f docker-compose.yml -f docker-compose.dev.yml exec django python manage.py createsuperuser
