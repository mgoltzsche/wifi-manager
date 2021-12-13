PLATFORM ?= linux/amd64

IMAGE_BUILD_OPTS = -t docker.io/mgoltzsche/wifi-manager:dev

BUILDX_BUILDER ?= wifi-manager-builder
BUILDX_OUTPUT ?= type=docker
BUILDX_OPTS ?= --builder=$(BUILDX_BUILDER) --output=$(BUILDX_OUTPUT) --platform=$(PLATFORM)
DOCKER ?= docker
DOCKER_COMPOSE ?= docker-compose

all: image

image:
	$(DOCKER) build $(IMAGE_BUILD_OPTS) wifi-connect

buildx: create-builder
	$(DOCKER) buildx build -f Dockerfile $(BUILDX_OPTS) --force-rm $(IMAGE_BUILD_OPTS) .

create-builder:
	$(DOCKER) buildx inspect $(BUILDX_BUILDER) >/dev/null 2<&1 || $(DOCKER) buildx create --name=$(BUILDX_BUILDER) >/dev/null

delete-builder:
	$(DOCKER) buildx rm $(BUILDX_BUILDER)

compose-up:
	$(DOCKER_COMPOSE) up -d --build

compose-down:
	$(DOCKER_COMPOSE) down -v --remove-orphans

compose-stop:
	$(DOCKER_COMPOSE) stop

compose-rm:
	$(DOCKER_COMPOSE) rm -sf
