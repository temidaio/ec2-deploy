#!/bin/bash
set -o pipefail

CMD="${INPUT_SCRIPT/$'\n'/' && '}"

function main() {
  configSSHAccessKey

  if [ "$INPUT_ACTION" == "scp" ]; then
    copyFiles
  elif [ "$INPUT_ACTION" == "ssh-command" ]; then
    sshCommand
  else
    echo "Unexpected actions"
  fi

  cleanContainer
}

function configSSHAccessKey() {
  mkdir "/root/.ssh"
  echo -e "${INPUT_KEY}" > "/root/.ssh/id_rsa"
  chmod 0400 "/root/.ssh/id_rsa"
}

function sshCommand() {
  trap "ssh -t -o StrictHostKeyChecking=no \
    -p "${INPUT_PORT}" \
    "${INPUT_USER}"@"${INPUT_HOST}" "${CMD}"'" EXIT
}

function copyFiles() {
  scp -o StrictHostKeyChecking=no \
    -P "${INPUT_PORT}" \
    -r "${INPUT_SOURCE}" \
    "${INPUT_USER}"@"${INPUT_HOST}":"${INPUT_TARGET}"
}

function cleanContainer() {
  rm -f "/root/.ssh/id_rsa"
}

main "$@"