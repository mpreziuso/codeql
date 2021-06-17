#!/usr/bin/env bash

panic() {
    local msg="${1:-}"

    echo "${msg}"
    exit 1
}

catch_all() {
  local err_code=$?
  [[ ${err_code} -ne 0 ]] && \
      echo "FATAL: Script encountered error code ${err_code}"
  exit $err_code
}

check_mandatory_args() {
    [[ -z "${CODEQL_HOME}" ]] && panic "Please define CODEQL_HOME as an environment variable"
    [[ -z "${CODEQL_ARGS}" ]] && panic "Please define CODEQL_ARGS as an environment variable to perform some task."
}

main() {
    trap catch_all EXIT

    check_mandatory_args

    ${CODEQL_HOME}/codeql/codeql ${CODEQL_ARGS}
}

main "$@"
