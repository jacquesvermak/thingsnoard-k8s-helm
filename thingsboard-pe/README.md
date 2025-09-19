# ThingsBoard PE Helm Chart

Complete Helm chart for deploying ThingsBoard Professional Edition on Kubernetes with all infrastructure components.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PVC provisioner support in the underlying infrastructure

## Components

This Helm chart includes:

### Core ThingsBoard
- **ThingsBoard Node**: Main application server
- **CoAP Transport**: IoT device connectivity with DTLS support
- **HTTP Transport**: HTTP-based device connectivity
- **Web UI**: Management interface
- **JS Executor**: Rule engine execution

### Infrastructure
- **Apache Cassandra**: Primary database
- **Apache Kafka**: Message queue system
- **Redis**: Caching layer
- **Apache Zookeeper**: Coordination service

## Installation

### Quick Start
```bash
# Create namespace
kubectl create namespace thingsboard

# Install with default values
helm install thingsboard-pe ./thingsboard-pe -n thingsboard

# Install with custom values
helm install thingsboard-pe ./thingsboard-pe -f custom-values.yaml -n thingsboard
```

### Development Environment
```bash
helm install thingsboard-pe ./thingsboard-pe \
  --set global.namespace=thingsboard-dev \
  --set thingsboard.transports.coap.replicas=2 \
  --set kafka.replicas=1 \
  --set zookeeper.replicas=1 \
  -n thingsboard-dev
```

### Production Environment
```bash
helm install thingsboard-pe ./thingsboard-pe \
  --set global.namespace=thingsboard-prod \
  --set thingsboard.transports.coap.replicas=10 \
  --set kafka.replicas=3 \
  --set zookeeper.replicas=3 \
  --set cassandra.resources.requests.memory=60Gi \
  --set cassandra.storage.size=500Gi \
  -n thingsboard-prod
```

## Configuration

### Core Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.namespace` | Kubernetes namespace | `thingsboard-qa` |
| `thingsboard.image.tag` | ThingsBoard image tag | `4.0.1PE` |
| `thingsboard.node.replicas` | Number of TB nodes | `1` |

### Transport Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `thingsboard.transports.coap.enabled` | Enable CoAP transport | `true` |
| `thingsboard.transports.coap.replicas` | CoAP transport replicas | `4` |
| `thingsboard.transports.coap.dtlsEnabled` | Enable DTLS | `true` |
| `thingsboard.transports.http.enabled` | Enable HTTP transport | `true` |

### Infrastructure Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `cassandra.enabled` | Enable Cassandra | `true` |
| `kafka.enabled` | Enable Kafka | `true` |
| `redis.enabled` | Enable Redis | `true` |
| `zookeeper.enabled` | Enable Zookeeper | `true` |

### Security Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `security.certificates.enabled` | Enable DTLS certificates | `true` |
| `redis.auth.enabled` | Enable Redis authentication | `true` |
| `redis.auth.password` | Redis password | `setplease` |

## Scaling

### Horizontal Pod Autoscaling
```bash
# Enable autoscaling
helm upgrade thingsboard-pe ./thingsboard-pe \
  --set autoscaling.enabled=true \
  --set autoscaling.coap.maxReplicas=100 \
  --set autoscaling.http.maxReplicas=50
```

### Manual Scaling
```bash
# Scale CoAP transport
helm upgrade thingsboard-pe ./thingsboard-pe \
  --set thingsboard.transports.coap.replicas=20

# Scale Kafka cluster
helm upgrade thingsboard-pe ./thingsboard-pe \
  --set kafka.replicas=5
```

## Monitoring

### Check Deployment Status
```bash
# Check all pods
kubectl get pods -n thingsboard

# Check services
kubectl get svc -n thingsboard

# Check HPA status
kubectl get hpa -n thingsboard
```

### Logs
```bash
# ThingsBoard node logs
kubectl logs -f deployment/thingsboard-pe-node -n thingsboard

# CoAP transport logs
kubectl logs -f statefulset/thingsboard-pe-coap-transport -n thingsboard

# Kafka logs
kubectl logs -f statefulset/thingsboard-pe-kafka -n thingsboard
```

## Troubleshooting

### Common Issues

1. **Pods stuck in Pending state**
   - Check PVC provisioning: `kubectl get pvc -n thingsboard`
   - Verify storage class: `kubectl get storageclass`

2. **CoAP transport CrashLoopBackOff**
   - Verify DTLS certificates are mounted
   - Check Kafka connectivity

3. **Database connection issues**
   - Ensure Cassandra is running: `kubectl get statefulset -n thingsboard`
   - Check service endpoints: `kubectl get endpoints -n thingsboard`

### Debugging Commands
```bash
# Describe problematic pod
kubectl describe pod <pod-name> -n thingsboard

# Check events
kubectl get events -n thingsboard --sort-by='.lastTimestamp'

# Port forward for local access
kubectl port-forward svc/thingsboard-pe-web-ui 8080:8080 -n thingsboard
```

## Upgrading

```bash
# Upgrade to new version
helm upgrade thingsboard-pe ./thingsboard-pe \
  --set thingsboard.image.tag=4.0.2PE \
  -n thingsboard

# Rollback if needed
helm rollback thingsboard-pe 1 -n thingsboard
```

## Uninstalling

```bash
# Remove Helm release
helm uninstall thingsboard-pe -n thingsboard

# Clean up PVCs (optional)
kubectl delete pvc -l app.kubernetes.io/instance=thingsboard-pe -n thingsboard

# Remove namespace
kubectl delete namespace thingsboard
```

## Support

For issues and questions:
- Check ThingsBoard documentation: https://thingsboard.io/docs/
- Review Kubernetes logs and events
- Verify resource requirements and limits