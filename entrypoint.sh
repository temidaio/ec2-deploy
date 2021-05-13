#!/bin/bash
set -eo pipefail
#set -x

CMD="${INPUT_RUN/$'\n'/' && '}"

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
  ssh -v -o StrictHostKeyChecking=no -p "$INPUT_PORT" "$INPUT_USER"@"$INPUT_HOST" "$CMD"
}

main "$@"