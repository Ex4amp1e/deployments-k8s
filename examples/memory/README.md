# Memory examples

Memory example contains setup and tear down logic with default NSM infrastructure and memroy based registry backend.

## Requires

- [spire](../spire)

## Includes

- [Memif to Memif Connection](../use-cases/Memif2Memif)
- [Kernel to Kernel Connection](../use-cases/Kernel2Kernel)
- [Kernel to VXLAN to Kernel Connection](../use-cases/Kernel2Vxlan2Kernel)

## Run

1. Create ns for deployments:
```bash
kubectl create ns nsm-system
```

2. Apply NSM resources for basic tests:

```bash
kubectl apply -k https://github.com/networkservicemesh/deployments-k8s/examples/memory?ref=bf3bd32b180f8dc24c9e1e7437f6f4442855df4a
```

3. Wait for admission-webhook-k8s:

```bash
WH=$(kubectl get pods -l app=admission-webhook-k8s -n nsm-system --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
kubectl wait --for=condition=ready --timeout=1m pod ${WH} -n nsm-system
```

## Cleanup

```bash
kubectl delete mutatingwebhookconfiguration --all
kubectl delete ns nsm-system
```
