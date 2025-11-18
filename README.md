# ThingsBoard Helm Chart

This repository contains Helm charts for deploying ThingsBoard PE (Professional Edition) and its dependencies on Kubernetes.

## Features
- Deploy ThingsBoard PE with Cassandra, Kafka, Redis, and Zookeeper
- Configurable via Helm `values.yaml`
- Includes example templates for services, deployments, statefulsets, and configmaps

## Directory Structure
```
thingsboard-pe/
  Chart.yaml           # Helm chart metadata
  README.md            # Chart-specific documentation
  values.yaml          # Default configuration values
  charts/              # Subcharts (if any)
  templates/           # Kubernetes manifests
    _helpers.tpl       # Template helpers
    hpa.yaml           # Horizontal Pod Autoscaler
    NOTES.txt          # Post-install notes
    cassandra/         # Cassandra manifests
    configmaps/        # ConfigMap templates
    deployments/       # Deployment templates
    kafka/             # Kafka manifests
    redis/             # Redis manifests
    services/          # Service templates
    statefullsets/     # StatefulSet templates (note: typo, should be 'statefulsets')
    statefulsets/      # Additional StatefulSet templates
    zookeeper/         # Zookeeper manifests
```

## Usage
1. **Install Helm** (if not already installed):
   ```bash
   curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
   ```
2. **Clone this repository:**
   ```bash
   git clone https://github.com/jacquesvermak/thingsnoard-k8s-helm.git
   cd thingsnoard-k8s-helm/thingsboard-pe
   ```
3. **Customize your deployment:**
   Edit `values.yaml` to fit your environment and requirements.

4. **Install the chart:**
   ```bash
   helm install thingsboard .
   ```

## Upgrade the chart
```bash
helm upgrade thingsboard .
```

## Uninstall the chart
```bash
helm uninstall thingsboard
```

## Supported Kubernetes Versions
- Kubernetes 1.22+
- Tested on major cloud providers (EKS, AKS, GKE)

## Troubleshooting & Common Issues
- Ensure all required images are accessible from your cluster.
- Check resource limits and requests in `values.yaml` for production workloads.
- For persistent storage, verify your storage class and volume configuration.
- If you encounter Helm errors, run `helm lint .` for chart validation.

## Deployment Examples

### Development Environment
```bash
helm install tb-dev ./thingsboard-pe \
  --namespace tb-dev \
  --create-namespace \
  --set global.namespace=tb-dev \
  --set thingsboard.node.resources.requests.memory=10Gi \
  --set thingsboard.node.resources.limits.memory=15Gi \
  --set thingsboard.transports.coap.replicas=2
```

### Staging Environment
```bash
helm install tb-staging ./thingsboard-pe \
  --namespace tb-staging \
  --create-namespace \
  --set global.namespace=tb-staging \
  --set thingsboard.node.resources.requests.memory=20Gi \
  --set thingsboard.node.resources.limits.memory=30Gi \
  --set thingsboard.transports.coap.replicas=3
```

### Production Environment
```bash
helm install tb-prod ./thingsboard-pe \
  --namespace tb-prod \
  --create-namespace \
  --set global.namespace=tb-prod \
  --set thingsboard.node.resources.requests.memory=32Gi \
  --set thingsboard.node.resources.limits.memory=40Gi \
  --set thingsboard.transports.coap.replicas=6
```

## Custom Values File Example

```yaml
# production-values.yaml
global:
  namespace: thingsboard-prod

thingsboard:
  image:
    tag: "4.0.1PE"
  node:
    replicas: 1
    resources:
      requests:
        cpu: "8"
        memory: 32Gi
      limits:
        cpu: "16"
        memory: 40Gi
    env:
      TB_LICENSE_SECRET: "your-production-license"
  transports:
    coap:
      replicas: 6
      resources:
        requests:
          cpu: 500m
          memory: 8Gi
        limits:
          cpu: 1000m
          memory: 12Gi
security:
  certificates:
    dtls:
      serverCert: |
        -----BEGIN CERTIFICATE-----
        [Your production certificate]
        -----END CERTIFICATE-----
```

## Contributing
Contributions are welcome! Please open issues or submit pull requests for improvements.

## License
Apache License 2.0

## Maintainers
- Jacques Vermak

---
For more details, refer to the official [ThingsBoard documentation](https://thingsboard.io/docs/).
