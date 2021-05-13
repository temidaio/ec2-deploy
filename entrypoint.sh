#!/bin/bash
set -eo pipefail
#set -ex

CMD="${INPUT_SCRIPT/$'\n'/' && '}"

INPUT_PORT=${INPUT_PORT:-"22"}
INPUT_TARGET=${INPUT_TARGET:-"."}

function main() {
    configSSHAccessKey

  if [ "$INPUT_ACTION" == "scp" ]; then
    scp -r -o StrictHostKeyChecking=no -P "${INPUT_PORT}" "${INPUT_SOURCE}" ec2-user@3.250.28.11:.
  elif [ "$INPUT_ACTION" == "ssh-command" ]; then
    ssh-command
  else
    echo "Unexpected actions"
  fi
}

function configSSHAccessKey() {
  mkdir "/root/.ssh"
  echo -e "${INPUT_KEY}" > "/root/.ssh/id_rsa"
  chmod 0400 "/root/.ssh/id_rsa"
}

function ssh-command() {
  ssh -o StrictHostKeyChecking=no \
    -p "${INPUT_PORT}" \
    "${INPUT_USER}"@"${INPUT_HOST}" "${CMD}"
}

#function scp() {
#  #scp -o StrictHostKeyChecking=no \
#  #  -P "${INPUT_PORT}" \
#  #  -r "${INPUT_SOURCE}" \
#  #  "${INPUT_USER}"@"${INPUT_HOST}":"${INPUT_TARGET}"
#  scp -r -o StrictHostKeyChecking=no -P 23 app ec2-user@3.250.28.11:.
#}

main "$@"