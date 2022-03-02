#!/bin/sh
# Copyright 2022 Lovro Strihic <lovrostrihic@hotmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# shellcheck disable=SC2002
version="$(cat plugin.yaml | grep "version" | cut -d '"' -f 2)"
echo "Downloading and installing helm-test v${version} ..."

url=""
if [ "$(uname)" = "Darwin" ]; then
    url="https://github.com/lstrihic/helm-test/releases/download/v${version}/helm-test_${version}_darwin_amd64.tar.gz"
elif [ "$(uname)" = "Linux" ] ; then
    if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then
        url="https://github.com/lstrihic/helm-test/releases/download/v${version}/helm-test_${version}_linux_arm64.tar.gz"
    else
        url="https://github.com/lstrihic/helm-test/releases/download/v${version}/helm-test_${version}_linux_amd64.tar.gz"
    fi
else
    url="https://github.com/lstrihic/helm-test/releases/download/v${version}/helm-test_${version}_windows_amd64.tar.gz"
fi

echo "$url"

mkdir -p "bin"
mkdir -p "config"
mkdir -p "releases/v${version}"

# Download with curl if possible.
# shellcheck disable=SC2230
if [ -x "$(which curl 2>/dev/null)" ]; then
    curl -sSL "${url}" -o "releases/v${version}.tar.gz"
else
    wget -q "${url}" -O "releases/v${version}.tar.gz"
fi

tar xzf "releases/v${version}.tar.gz" -C "releases/v${version}"
mv "releases/v${version}/helm-test" "bin/helm-test" || \
    mv "releases/v${version}/helm-test.exe" "bin/helm-test"
mv "releases/v${version}/plugin.yaml" .
mv "releases/v${version}/README.md" .
mv "releases/v${version}/LICENSE" .
