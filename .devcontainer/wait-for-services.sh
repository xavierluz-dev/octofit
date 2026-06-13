#!/usr/bin/env bash

set -euo pipefail

echo "Aguardando PostgreSQL e Redis..."

until pg_isready -h postgres -p 5432 -U octofit -d octofit; do
  echo "PostgreSQL ainda não está pronto..."
  sleep 2
  retries=$((retries+1))
  if [ "${retries:-0}" -ge 15 ]; then
    echo "Erro: PostgreSQL não ficou pronto a tempo." >&2
    exit 1
  fi
 done

retries=0
until redis-cli -h redis ping | grep -q PONG; do
  echo "Redis ainda não está pronto..."
  sleep 2
  retries=$((retries+1))
  if [ "${retries}" -ge 15 ]; then
    echo "Erro: Redis não ficou pronto a tempo." >&2
    exit 1
  fi
 done

echo "PostgreSQL e Redis estão prontos."
