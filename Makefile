build:
	container build --tag ghcr.io/burnskp/dev:latest --no-cache --memory 8g .

cache:
	container build --tag ghcr.io/burnskp/dev:latest --memory 8g .
