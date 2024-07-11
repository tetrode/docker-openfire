version=4.8.3

all: build

build:
	@echo make a docker container with openfire version $(version)
	@docker build --tag=tetrode/openfire --build-arg OPENFIRE_VERSION=$(version)  .

release: build
	@docker build --tag=tetrode/openfire:$(version) --build-arg OPENFIRE_VERSION=$(version) .
	@echo $(version) > VERSION

run: release
	@OPENFIRE_VERSION=$(version) docker compose run --rm tetrode/openfire

push: release
	@docker login
	@docker image push tetrode/openfire:$(version)

help:
	@echo "Targets:            build, release, run"
	@echo "Optional parameter: version=x.y.z"
	@echo "Example:            make release version=4.8.1"
	@echo "For Openfire version information see https://github.com/igniterealtime/Openfire/releases"
