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

## Notes
- Ensure your Kubernetes cluster meets the resource requirements for ThingsBoard and its dependencies.
- The directory `statefullsets` appears to be a typo; consider renaming it to `statefulsets` for consistency.
- For more information, see the chart-specific `README.md` in `thingsboard-pe/`.

## License
Specify your license here (e.g., Apache 2.0, MIT).

## Maintainers
- Jacques Vermak

---
For more details, refer to the official [ThingsBoard documentation](https://thingsboard.io/docs/).
