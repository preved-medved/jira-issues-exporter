#!/usr/bin/env bash
while true; do
  source .env
  gin -i \
    --build . \
    run
  # If the command succeeded, the following line will not be executed.
  # If it failed, the script will print the message and continue with the next iteration.
  echo "Command failed with exit code $?. Respawning.." >&2
  sleep 1
done
