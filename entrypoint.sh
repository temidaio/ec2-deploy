#!/bin/bash
set -eo pipefail

CMD="${INPUT_RUN/$'\n'/' && '}"

function main() {
    configSSHAccessKey

  if [ "${INPUT_ACTION}" == "scp" ]; then
    scp
  elif [ "${INPUT_ACTION}" == "scp" ]; then
    ssh-command
  fi
}

function configSSHAccessKey() {
  mkdir "~/.ssh"
  echo "$INPUT_KEY" > "/root/.ssh/id_rsa"
  chmod 0400 "~/.ssh/id_rsa"
}

function ssh-command() {
  ssh -v -o StrictHostKeyChecking=no -p "$INPUT_PORT" "$INPUT_USER"@"$INPUT_HOST" "$CMD"
}

main "$@"