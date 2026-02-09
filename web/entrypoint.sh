#!/bin/bash
set -e

# Remove server.pid pre-existente
rm -f /app/tmp/pids/server.pid

# Executa o comando passado no Dockerfile
exec "$@"
