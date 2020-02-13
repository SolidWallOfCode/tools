#!/usr/bin/env bash
TS_SRC_ROOT=$1

if [ ! -d "$TS_SRC_ROOT" ] ; then
  echo "$TS_SRC_ROOT" is not a directory.
  echo "Usage: $0 <ATS src directory>"
  exit 1
fi

TS_PKG_CFG="${TS_SRC_ROOT}/tools/trafficserver.pc"

if [ ! -f "${TS_PKG_CFG}" ] ; then
  echo "${TS_PKG_CFG}" not found.
  echo "Check if $TS_SRC_ROOT is the build directory and TS has been built."
  echo "Usage: $0 <ATS src directory>"
  exit 2
fi

TS_PEM="${TS_SRC_ROOT}/tests/gold_tests/tls/ssl/server.pem"
if [ ! -f "${TS_PEM}" ] ; then
  echo "${TS_PEM}" not found. Is $TS_SRC_ROOT really a source directory?
  exit 3
fi

TS_KEY="${TS_SRC_ROOT}/tests/gold_tests/tls/ssl/server.key"
if [ ! -f "${TS_KEY}" ] ; then
  echo "${TS_KEY}" not found. Is $TS_SRC_ROOT really a source directory?
  exit 3
fi

TS_RUN_ROOT=$(pkg-config --with-path "${TS_SRC_ROOT}/tools" --variable prefix trafficserver)
if [ ! -d "$TS_RUN_ROOT" ] ; then
  echo "$TS_RUN_ROOT" is not a directory - is TS installed?
  exit 4
fi

echo "Updating installation in $TS_RUN_ROOT"

TS_ETC="${TS_RUN_ROOT}/etc/trafficserver"
if [ ! -d "$TS_ETC" ] ; then
  echo "$TS_ETC" is not a directory - is TS installed?
  exit 1
fi

TS_PEM="${TS_SRC_ROOT}/tests/gold_tests/tls/ssl/server.pem"
echo "dest_ip=* ssl_cert_name=${TS_PEM} ssl_key_name=${TS_KEY}" > ${TS_ETC}/ssl_multicert.config
