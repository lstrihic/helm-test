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

.PHONY: build_local
build_local: clear prepare
	CGO_ENABLED=0 go build -o ./dist/local/helm-test ./cmd
	rm -rf /home/lstrihic/.local/share/helm/plugins/helm-test
	mkdir -p /home/lstrihic/.local/share/helm/plugins/helm-test/bin
	cp ./dist/local/helm-test /home/lstrihic/.local/share/helm/plugins/helm-test/bin/helm-test
	cp plugin.yaml /home/lstrihic/.local/share/helm/plugins/helm-test

.PHONY: prepare
prepare:
	mkdir -p ./dist/local

.PHONY: clear
clear:
	rm -rf ./dist/local

.PHONY: release
release:
	goreleaser build --single-target

.PHONY: license
license:
	addlicense -c "Lovro Strihic <lovrostrihic@hotmail.com>" -l apache -y 2022 ./
