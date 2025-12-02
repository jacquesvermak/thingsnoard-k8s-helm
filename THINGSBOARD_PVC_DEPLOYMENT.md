# ThingsBoard PE Kubernetes Deployment with PVC and ConfigMap

This guide explains how to deploy ThingsBoard PE with persistent data and solutions.json using Kubernetes PVC and ConfigMap.

## 1. Create PersistentVolumeClaim (PVC)

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: tb-node-data
  namespace: thingsboard-qa
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF
```

## 2. Create ConfigMap for solutions.json

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: tb-solutions-config
  namespace: thingsboard-qa
data:
  solutions.json: "[]"
EOF
```

## 3. Update Helm Chart

- Add volumeMounts for PVC and ConfigMap in your StatefulSet/Deployment:

```yaml
volumeMounts:
  - name: tb-node-data
    mountPath: /usr/share/thingsboard/data
  - name: tb-solutions
    mountPath: /usr/share/thingsboard/data/json/solutions/solutions.json
    subPath: solutions.json
```

- Add volumes section:

```yaml
volumes:
  - name: tb-node-data
    persistentVolumeClaim:
      claimName: tb-node-data
  - name: tb-solutions
    configMap:
      name: tb-solutions-config
      defaultMode: 444
```

## 4. Deploy the Helm Chart

```
helm upgrade --install thingsboard-pe ./thingsboard-pe -n thingsboard-qa
```

## 5. Verify Resources

```
kubectl get pvc tb-node-data -n thingsboard-qa
kubectl get configmap tb-solutions-config -n thingsboard-qa -o yaml
```

## 6. Monitor Pod Status and Logs

```
kubectl get pods -n thingsboard-qa
kubectl logs -f thingsboard-node-0 -n thingsboard-qa --tail=100
```

---

**Troubleshooting Tips:**
- Ensure PVC is Bound and ConfigMap exists before deploying.
- Validate mount paths and permissions in your Helm templates.
- Check pod logs for file format or mount errors.
