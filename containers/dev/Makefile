build:
	docker buildx build --output type=image,name=ghcr.io/burnskp/containers/dev:latest,compression=zstd,compression-level=1 --no-cache -m 8g .

cache:
	docker buildx build --output type=image,name=ghcr.io/burnskp/containers/dev:latest,compression=zstd,compression-level=1  -m 8g .
