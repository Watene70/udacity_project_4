

setup:
	
	source ~/.devops/bin/activate
	python3 -m venv ~/.devops

install:
	
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	
	python -m pytest -vv --cov=myrepolib tests/*.py
	python -m pytest --nbval notebook.ipynb

lint:
	
	hadolint Dockerfile
	pylint --disable=R,C,W1203,W1202 app.py

all: install lint test

MAGE_NAME:=hadolint-action

lint-dockerfile: ## Runs hadolint against application dockerfile
	@docker run --rm -v "$(PWD):/data" -w "/data" hadolint/hadolint hadolint Dockerfile

lint-yaml: ## Lints yaml configurations
	@docker run --rm -v "$(PWD):/yaml" sdesbure/yamllint yamllint .

build: ## Builds the docker image
	@docker build . -t $(IMAGE_NAME)

test: build ## Runs a test in the image
	@docker run -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ${PWD}:/test zemanlx/container-structure-test:v1.8.0-alpine \
    test \
    --image $(IMAGE_NAME) \
    --config test/structure-tests.yaml

