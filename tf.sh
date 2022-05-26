#!/usr/bin/env bash

ACTION=$@

TERRAFORM_VERSION="1.1.8"
TERRAFORM_PLATFORM=linux
case "$OSTYPE" in
darwin*) TERRAFORM_PLATFORM=darwin ;;
linux*) TERRAFORM_PLATFORM=linux ;;
esac

TERRAFORM_BASE_DIR="$(pwd)/.terraform"
TERRAFORM_BIN_DIR="${TERRAFORM_BASE_DIR}/bin"
TERRAFORM_ENV_DATA_DIR="${TERRAFORM_BASE_DIR}/data"

if [ -d "${TERRAFORM_BIN_DIR}" ] && [ -x "${TERRAFORM_BIN_DIR}/terraform" ]; then
  echo "terraform executable file found..."
else
  echo "terraform executable file not found, installing..."
  mkdir -p ${TERRAFORM_BIN_DIR}
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TERRAFORM_PLATFORM}_amd64.zip -O /tmp/terraform.zip
  unzip -o /tmp/terraform.zip -d ${TERRAFORM_BIN_DIR} >/dev/null
  if [ -d "${TERRAFORM_BIN_DIR}" ] && [ -x "${TERRAFORM_BIN_DIR}/terraform" ]; then
    echo "terraform executable file installed successfully..."
  else
    echo "error while terraform executable file installation exiting..."
    exit 1
  fi
fi

${TERRAFORM_BIN_DIR}/terraform "$@"
