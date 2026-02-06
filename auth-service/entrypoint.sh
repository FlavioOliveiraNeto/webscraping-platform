#!/bin/bash
set -e

# Remove server.pid pré-existente
rm -f /app/tmp/pids/server.pid

# Executa o comando passado no Dockerfile
exec "$@"