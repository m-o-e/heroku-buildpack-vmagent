#!/usr/bin/env bash

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

. ${BUILDPACK_HOME}/bin/vars.sh

cd "${BUILDPACK_HOME}"

testCompile() {
  compile

  assertCapturedSuccess
  assertCaptured "Installing vmagent ${VMAGENT_VERSION}"
  assertFileExists "${BUILD_DIR}/bin/vmagent"
  assertFileSHA256 "${VMAGENT_SHA256}" "${BUILD_DIR}/bin/vmagent"
}

assertFileExists() {
  local path=$1

  assertTrue "${path} should exist" "[ -f ${path} ]"
}

assertFileSHA256() {
  local sha=$1
  local path=$2

  assertEquals "${sha}  ${path}" "$(sha256sum "${path}")"
}
