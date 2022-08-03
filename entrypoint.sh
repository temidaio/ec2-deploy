#!/bin/bash
set -o pipefail

VARS="${INPUT_VARIABLES/$'\n'/'; '}"

if [ ! -z "$VARS" ]; then
  for var in $VARS; do
    ENV_VARS="$ENV_VARS export $var"
  done
  CMD="${ENV_VARS}; ${INPUT_SCRIPT/$'\n'/' && '}"
else
  CMD="${INPUT_SCRIPT/$'\n'/' && '}"
fi

function main() {
  configSSHAccessKey

  if [ "$INPUT_ACTION" == "scp" ]; then
    copyFiles
  elif [ "$INPUT_ACTION" == "ssh-command" ]; then
    sshCommand
    if [ $(echo $?) != 0 ] ; then
      exit 1
    fi
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
  ssh -t -o StrictHostKeyChecking=no \
    -p "${INPUT_PORT}" \
    "${INPUT_USER}"@"${INPUT_HOST}" "${CMD}"
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