CORE_BUNDLE_VERSION   :=v0.0.1
CLIENT_BUNDLE_VERSION :=v0.0.1
MGMT_BUNDLE_VERSION   :=v0.0.1

services/release: services/release/client services/release/core services/release/mgmt

services/release/client:
	kustomizer push artifact oci://ghcr.io/rossedman/platform-client:${CLIENT_BUNDLE_VERSION} -k example/client 

services/release/core:
	kustomizer push artifact oci://ghcr.io/rossedman/platform-core:${CORE_BUNDLE_VERSION} -k example/core

services/release/mgmt:
	kustomizer push artifact oci://ghcr.io/rossedman/platform-mgmt:${MGMT_BUNDLE_VERSION} -k example/mgmt

services/deploy/mgmt:
	kustomizer apply inventory platform-mgmt --wait --prune \
		--artifact oci://ghcr.io/rossedman/platform-core:${CORE_BUNDLE_VERSION} \
		--artifact oci://ghcr.io/rossedman/platform-mgmt:${MGMT_BUNDLE_VERSION}

services/deploy/client:
	kustomizer apply inventory platform-client --wait --prune \
		--artifact oci://ghcr.io/rossedman/platform-core:${CORE_BUNDLE_VERSION} \
		--artifact oci://ghcr.io/rossedman/platform-client:${MGMT_BUNDLE_VERSION}

services/delete/mgmt:
	kustomizer delete inventory platform-mgmt --wait

services/delete/client:
	kustomizer delete inventory platform-client --wait

bom/generate:
	bom generate -n http://kubernetes.rossedman.io -d example/core -o platform-core.spdx
	bom generate -n http://kubernetes.rossedman.io -d example/client -o platform-client.spdx
	bom generate -n http://kubernetes.rossedman.io -d example/mgmt -o platform-mgmt.spdx