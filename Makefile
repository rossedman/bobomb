release/platform: release/services/client release/services/core release/services/mgmt

release/services/client:
	kustomizer push artifact oci://ghcr.io/rossedman/platform-client:v0.0.1 -k example/client 

release/services/core:
	kustomizer push artifact oci://ghcr.io/rossedman/platform-core:v0.0.1 -k example/core

release/services/mgmt:
	kustomizer push artifact oci://ghcr.io/rossedman/platform-mgmt:v0.0.1 -k example/mgmt

deploy/mgmt:
	kustomizer apply inventory platform-mgmt --wait --prune \
		--artifact oci://ghcr.io/rossedman/platform-core:v0.0.1 \
		--artifact oci://ghcr.io/rossedman/platform-mgmt:v0.0.1

deploy/client:
	kustomizer apply inventory platform-client --wait --prune \
		--artifact oci://ghcr.io/rossedman/platform-core:v0.0.1 \
		--artifact oci://ghcr.io/rossedman/platform-client:v0.0.1

delete/mgmt:
	kustomizer delete inventory platform-mgmt --wait

delete/client:
	kustomizer delete inventory platform-client --wait