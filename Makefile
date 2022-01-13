ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))


# build the image
.PHONY: docker_image_build
docker_image_build:
	cd scripts && \
	docker build . --tag clientserverruntime


# network
.PHONY: docker_network_start
docker_network_start:
	docker network create --driver=bridge --subnet=10.0.3.2/24 --gateway=10.0.3.1 app-network

.PHONY: docker_network_stop
docker_network_stop:
	docker network rm app-network


# build apps
.PHONY: build_internal
build_internal:
	mkdir -p build && \
	cd build && \
	cmake -G Ninja .. && \
	cmake --build .

.PHONY: rebuild_internal
rebuild_internal:
	cd build && \
	cmake --build .

.PHONY: build_client_internal
build_client_internal:
	cd build && \
	cmake --build . --target Server ClientHost ClientNet


# public
.PHONY: build
build:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) clientserverruntime make build_internal

.PHONY: rebuild
rebuild:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) clientserverruntime make rebuild_internal

.PHONY: build_client
build_client:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) clientserverruntime make build_client_internal


.PHONY: run_server_host
run_server_host:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) --network host clientserverruntime ./build/Server/Server

.PHONY: run_server
run_server:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) -p 9980:9980 --network host clientserverruntime ./build/Server/Server

.PHONY: run_client_host
run_client_host:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) --network host clientserverruntime ./build/Client/ClientHost


.PHONY: run_server_network
run_server_network:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) --network app-network --ip 10.0.3.2 clientserverruntime ./build/Server/Server

.PHONY: run_client_network
run_client_network:
	docker run -v $(ROOT_DIR):$(ROOT_DIR) --rm --workdir $(ROOT_DIR) --network app-network --ip 10.0.3.3 clientserverruntime ./build/Client/ClientNet
