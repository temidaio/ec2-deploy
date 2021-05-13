#!/bin/bash
set -eo pipefail

CMD="${INPUT_SCRIPT/$'\n'/' && '}"

INPUT_PORT=${INPUT_PORT:-"22"}

function main() {
    configSSHAccessKey

  if [ "${INPUT_ACTION}" == "scp" ]; then
    scp
  elif [ "${INPUT_ACTION}" == "ssh-command" ]; then
    ssh-command
  else
    echo "Unexpected actions"
  fi
}

function configSSHAccessKey() {
  mkdir "/root/.ssh"
  echo "$INPUT_KEY" > "/root/.ssh/id_rsa"
  chmod 0400 "/root/.ssh/id_rsa"
}

function ssh-command() {
  echo "${INPUT_USER}"
  echo "${INPUT_PORT}"
  ssh -o StrictHostKeyChecking=no -p "$INPUT_PORT" "$INPUT_USER"@"$INPUT_HOST" "$CMD"
}

main "$@"