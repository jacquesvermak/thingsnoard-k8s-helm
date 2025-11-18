# ThingsBoard PE Helm Chart - Deployment Examples

## Environment Flexibility

The Helm chart now supports full environment customization through template variables.

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
      serverKey: |
        -----BEGIN EC PRIVATE KEY-----
        [Your production private key]
        -----END EC PRIVATE KEY-----
```

```bash
helm install tb-prod ./thingsboard-pe \
  --namespace tb-prod \
  --create-namespace \
  --values production-values.yaml
```

## Key Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `global.namespace` | Target namespace | `{{ include "thingsboard-pe.namespace" . }}` |
| `thingsboard.node.replicas` | Core service replicas | `1` |
| `thingsboard.transports.coap.replicas` | CoAP transport replicas | `4` |
| `thingsboard.transports.coap.port` | DTLS port | `5684` |
| `thingsboard.node.resources.*` | Core service resources | See values.yaml |
| `thingsboard.transports.coap.resources.*` | CoAP resources | See values.yaml |
| `security.certificates.dtls.*` | DTLS certificates | Included defaults |

## Verification Commands

```bash
# Check deployment
kubectl get pods -n [your-namespace]

# Verify services
kubectl get svc -n [your-namespace]

# Check CoAP LoadBalancer
kubectl get svc tb-prod-thingsboard-pe-coap -n [your-namespace]

# View logs
kubectl logs -f tb-prod-thingsboard-pe-node-0 -n [your-namespace]
kubectl logs -f tb-prod-thingsboard-pe-coap-transport-0 -n [your-namespace]
```

## Upgrade Example

```bash
# Upgrade with new values
helm upgrade tb-prod ./thingsboard-pe \
  --namespace tb-prod \
  --set thingsboard.transports.coap.replicas=8 \
  --reuse-values

# Check upgrade status
helm status tb-prod -n tb-prod
```
