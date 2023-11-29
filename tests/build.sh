#!/usr/bin/env bash
docker buildx build . --output type=docker,name=elestio4test/pretix:latest | docker load
