#!/bin/bash
#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "${SCRIPT_DIR}/libedgetpu" ]]; then
  LIBEDGETPU_DIR="${SCRIPT_DIR}/libedgetpu"
  RULES_FILE="${SCRIPT_DIR}/libedgetpu/edgetpu-accelerator.rules"
else
  LIBEDGETPU_DIR=${LIBEDGETPU_BIN:-"${SCRIPT_DIR}/../out"}
  RULES_FILE="${SCRIPT_DIR}/../debian/edgetpu-accelerator.rules"
fi

function info {
  echo -e "\033[0;32m${1}\033[0m"  # green
}

function warn {
  echo -e "\033[0;33m${1}\033[0m"  # yellow
}

function error {
  echo -e "\033[0;31m${1}\033[0m"  # red
}

function install_file {
  local name="${1}"
  local src="${2}"
  local dst="${3}"

  info "Installing ${name} [${dst}]..."
  if [[ -f "${dst}" ]]; then
    warn "File already exists. Replacing it..."
    rm -f "${dst}"
  fi
  cp "${src}" "${dst}"
}

if [[ "${EUID}" != 0 ]]; then
  error "Please use sudo to run as root."
  exit 1
fi

if [[ -f /etc/mendel_version ]]; then
  error "Looks like you're using a Coral Dev Board. You should instead use Debian packages to manage Edge TPU software."
  exit 1
fi

readonly OS="$(uname -s)"
readonly MACHINE="$(uname -m)"

HOST_GNU_TYPE=aarch64-linux-gnu
CPU=aarch64

FREQ_DIR=throttled

if [[ "${CPU}" == darwin* ]]; then
  sudo -u "${DARWIN_INSTALL_USER}" "${DARWIN_INSTALL_COMMAND}" install libusb

  DARWIN_INSTALL_LIB_DIR="$(dirname "$(dirname "${DARWIN_INSTALL_COMMAND}")")/lib"
  LIBEDGETPU_LIB_DIR="/usr/local/lib"
  mkdir -p "${LIBEDGETPU_LIB_DIR}"

  install_file "Edge TPU runtime library" \
               "${LIBEDGETPU_DIR}/${FREQ_DIR}/${CPU}/libedgetpu.1.0.dylib" \
               "${LIBEDGETPU_LIB_DIR}"

  info "Generating symlink [${LIBEDGETPU_LIB_DIR}/libedgetpu.1.dylib]..."
  ln -sf libedgetpu.1.0.dylib "${LIBEDGETPU_LIB_DIR}/libedgetpu.1.dylib"

  install_name_tool -id  "${LIBEDGETPU_LIB_DIR}/libedgetpu.1.dylib" \
                         "${LIBEDGETPU_LIB_DIR}/libedgetpu.1.0.dylib"

  install_name_tool -change $(otool -L "${LIBEDGETPU_LIB_DIR}/libedgetpu.1.0.dylib" | grep usb | awk '{print $1}') \
                            "${DARWIN_INSTALL_LIB_DIR}/libusb-1.0.0.dylib" \
                            "${LIBEDGETPU_LIB_DIR}/libedgetpu.1.0.dylib"
else
  if [[ -x "$(command -v udevadm)" ]]; then
    install_file "device rule file" \
                 "${RULES_FILE}" \
                 "/etc/udev/rules.d/99-edgetpu-accelerator.rules"
    udevadm control --reload-rules && udevadm trigger
    info "Done."
  fi

  info "Done."
fi
