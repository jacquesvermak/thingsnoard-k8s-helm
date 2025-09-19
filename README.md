# ThingsBoard PE Helm Chart

A production-ready Helm chart for deploying ThingsBoard Professional Edition v4.0.1 with DTLS-enabled CoAP transport on Kubernetes.

## 🚀 Quick Start

```bash
# Add the repository
git clone <this-repo>
cd thingsboard-helm-chart

# Install ThingsBoard PE
helm install thingsboard-pe ./thingsboard-pe -n thingsboard-qa --create-namespace

# Check deployment status
kubectl get pods -n thingsboard-qa
```

## 📋 Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- LoadBalancer support (AWS NLB, etc.)
- StorageClass for persistent volumes
- 32GB+ available memory per node

## 🏗️ Architecture

This Helm chart deploys:

- **ThingsBoard PE Core** - Monolith service with full platform functionality
- **CoAP Transport** - 4 replicas with DTLS support (port 5684)
- **DTLS Certificates** - Automatic certificate management via ConfigMaps
- **Persistent Storage** - StatefulSet with persistent volume claims

## 📦 Chart Components

### Core Components
- `thingsboard-node` - Main ThingsBoard PE service
- `thingsboard-coap-transport` - DTLS-enabled CoAP transport (4 replicas)
- `coap-pem-configmap` - DTLS certificates and keys

### Supporting Services
- Cassandra database (configurable)
- Kafka message queue (configurable)
- Redis cache (configurable)
- Zookeeper coordination (configurable)

## ⚙️ Configuration

### Basic Installation

```bash
helm install thingsboard-pe ./thingsboard-pe \
  --namespace thingsboard-qa \
  --create-namespace \
  --values values.yaml
```

### Custom Values

```yaml
# custom-values.yaml
global:
  namespace: thingsboard-prod
  
thingsboard:
  node:
    resources:
      limits:
        memory: 40Gi
      requests:
        memory: 35Gi
  
  transports:
    coap:
      replicas: 6
      dtlsEnabled: true
```

```bash
helm install thingsboard-pe ./thingsboard-pe \
  --namespace thingsboard-prod \
  --create-namespace \
  --values custom-values.yaml
```

## 🔐 DTLS Configuration

The chart includes automatic DTLS certificate management:

- **CoAP DTLS Port**: 5684
- **Certificate Management**: Automated via `coap-pem-configmap`
- **Load Balancer**: AWS NLB with UDP support
- **Device Authentication**: Secure DTLS connections

### Certificate Structure
```
coap-pem-configmap:
  server.pem: |
    -----BEGIN CERTIFICATE-----
    [Certificate content]
    -----END CERTIFICATE-----
  server_key.pem: |
    -----BEGIN EC PRIVATE KEY-----
    [Private key content]
    -----END EC PRIVATE KEY-----
```

## 📊 Resource Requirements

### Minimum Requirements
```yaml
thingsboard:
  node:
    resources:
      requests:
        cpu: 6
        memory: 20Gi
      limits:
        cpu: 12
        memory: 25Gi
  
  transports:
    coap:
      resources:
        requests:
          cpu: 410m
          memory: 8Gi
        limits:
          cpu: 410m
          memory: 8Gi
```

### Production Requirements
- **Total Memory**: 60GB+ (Core: 32GB, CoAP: 32GB for 4 replicas)
- **CPU**: 16+ cores recommended
- **Storage**: 50GB+ for persistent data
- **Network**: LoadBalancer with UDP support

## 🔧 Deployment Examples

### Development Environment
```bash
helm install tb-dev ./thingsboard-pe \
  --namespace tb-dev \
  --create-namespace \
  --set thingsboard.node.resources.requests.memory=10Gi \
  --set thingsboard.transports.coap.replicas=2
```

### Production Environment
```bash
helm install tb-prod ./thingsboard-pe \
  --namespace tb-prod \
  --create-namespace \
  --set global.namespace=tb-prod \
  --set thingsboard.node.resources.requests.memory=32Gi \
  --set thingsboard.transports.coap.replicas=6
```

## 📈 Monitoring & Troubleshooting

### Check Pod Status
```bash
kubectl get pods -n thingsboard-qa
kubectl logs -f thingsboard-node-0 -n thingsboard-qa
kubectl logs -f thingsboard-coap-transport-0 -n thingsboard-qa
```

### Check Services
```bash
kubectl get svc -n thingsboard-qa
kubectl describe svc thingsboard-coap -n thingsboard-qa
```

### DTLS Connectivity Test
```bash
# Check CoAP transport logs for DTLS connections
kubectl logs thingsboard-coap-transport-0 -n thingsboard-qa | grep -i dtls

# Check for device connections
kubectl logs thingsboard-coap-transport-0 -n thingsboard-qa | grep -i "connection\|cid"
```

## 🔄 Upgrade

```bash
# Upgrade to newer version
helm upgrade thingsboard-pe ./thingsboard-pe \
  --namespace thingsboard-qa \
  --values values.yaml

# Check upgrade status
helm status thingsboard-pe -n thingsboard-qa
```

## 🗑️ Uninstall

```bash
helm uninstall thingsboard-pe -n thingsboard-qa

# Clean up PVCs if needed
kubectl delete pvc -l app.kubernetes.io/instance=thingsboard-pe -n thingsboard-qa
```

## 🔒 Security Notes

- DTLS certificates are included in the ConfigMap
- Consider using Kubernetes secrets for production certificates
- Review namespace isolation requirements
- Implement network policies as needed

## 📋 Default Credentials

- **Username**: `sysadmin@thingsboard.org`
- **Password**: `sysadmin`

**⚠️ Change default credentials immediately after deployment!**

## 🐛 Common Issues

### Pod Startup Issues
```bash
# Check resource limits
kubectl describe pod thingsboard-node-0 -n thingsboard-qa

# Check persistent volume claims
kubectl get pvc -n thingsboard-qa
```

### DTLS Connection Issues
```bash
# Verify certificate ConfigMap
kubectl get configmap coap-pem-configmap -n thingsboard-qa -o yaml

# Check LoadBalancer status
kubectl get svc thingsboard-coap -n thingsboard-qa
```

## 📚 Documentation Links

- [ThingsBoard PE Documentation](https://thingsboard.io/docs/pe/)
- [CoAP Transport Guide](https://thingsboard.io/docs/reference/coap-api/)
- [DTLS Configuration](https://thingsboard.io/docs/user-guide/ssl/coap-dtls/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes with `helm lint` and `helm template`
4. Submit a pull request

## 📄 License

This Helm chart is provided for ThingsBoard Professional Edition. Ensure you have appropriate ThingsBoard PE licensing.

---

**Chart Version**: 0.1.0  
**App Version**: 4.0.1  
**Maintainer**: Jacques Vermak <jacques@stagezero.co.za>