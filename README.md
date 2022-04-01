# Bobomb

This is an example of how to produce an OCI release of Kubernetes manifests that also include a SBOM in SPDX format. The purpose of this is try to document how to put together a package of Kubernetes configurations that can be shipped as a single package for deploying platforms.

## Setup

Install `bom` and `kustomizer` for creating our OCI packages with SBOM/SPDX created in them

```sh
go install sigs.k8s.io/bom/cmd/bom@latest
go install sigs.k8s.io/kustomize/kustomize/v4@latest
brew install stefanprodan/tap/kustomizer
```

## Creating Artifact

First, create an SBOM of the files that are going to be bundled into the platform. This currently does not have a way to retrieve licenses from the kustomizations we are using but it does produce checksums for all the files we will include.

```sh
bom generate -n http://kubernetes.twilio.com -d example -o platform.spdx
```

This step produces the OCI artifact, renders the Kustomize and pushes it into the container registry to be consumed.

```sh
echo $GITHUB_TOKEN | docker login ghcr.io -u rossedman --password-stdin
kustomizer push artifact oci://ghcr.io/rossedman/platform:v0.0.1 -k example/platform
```

## Deploying Artifact

In this step, we will create a cluster and deploy our artifact that we have pushed

```sh
kind create cluster --config kind.yaml
kubectl config use-context kind-kind
```

Next we will apply the release we created above

```sh
kustomizer apply inventory platform --wait --prune \
  --artifact oci://ghcr.io/rossedman/platform:v0.0.1 \
  --source ghcr.io/rossedman/platform \
  --revision v0.0.1
```

```sh
kustomizer delete inventory platform --wait
```