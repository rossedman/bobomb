# Bobomb

This is an example of how to produce an OCI release of Kubernetes manifests that also include a SBOM in SPDX format. The purpose of this is try to document how to put together a package of Kubernetes configurations that can be shipped as a single package for deploying platforms.

## Setup

Install `bom` and `kustomizer` for creating our OCI packages with SBOM/SPDX created in them

```sh
go install sigs.k8s.io/bom/cmd/bom@latest
go install sigs.k8s.io/kustomize/kustomize/v4@latest
brew install stefanprodan/tap/kustomizer
```

## Creating Artifacts

First, create an SBOM of the files that are going to be bundled into the platform. This currently does not have a way to retrieve licenses from the kustomizations we are using but it does produce checksums for all the files we will include.

```sh
bom generate -n http://kubernetes.rossedman.io -d example/core -o platform-core.spdx
```

This step produces multiple OCI artifacts, renders the Kustomize and pushes it into the container registry to be consumed.

```sh
make
```

## Deploying Artifact

In this step, we will create a cluster and deploy our artifact that we have pushed

```sh
make deploy/mgmt
make deploy/client
```