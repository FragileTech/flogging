current_dir = $(shell pwd)

PROJECT = flogging
DOCKER_ORG = fragiletech
VERSION ?= latest

.POSIX:
style:
	black .
	isort .
	ruff check --fix-only .

.POSIX:
check:
	!(grep -R /tmp tests)
	ruff check ${PROJECT}
	black --check ${PROJECT}

.PHONY: test
test:
	find -name "*.pyc" -delete
	pytest -s

.PHONY: pipenv-install
pipenv-install:
	rm -rf *.egg-info && rm -rf build && rm -rf __pycache__
	rm -f Pipfile && rm -f Pipfile.lock
	pipenv install --dev -r requirements-test.txt
	pipenv install --pre --dev -r requirements-lint.txt
	pipenv install -r requirements.txt
	pipenv install .
	pipenv lock

.PHONY: pipenv-test
pipenv-test:
	find -name "*.pyc" -delete
	pipenv run pytest -s