# my-go-app

## Build and Deploy

### Build Application

```bash
docker build . -t aunnk/my-go-app
```

### Login to Docker Hub

```bash
docker login -u aunnk
```

### Push to Docker Hub

```bash
docker push aunnk/my-go-app:latest
```

## Install Application via Helm Chart

```bash
cd chart
```

Install the chart for the first time.

```bash
helm install my-go-app .
```

Redeploy the chart by running the following command.

```bash
helm upgrade my-go-app .
```

## Initialize infrastructure via Terraform

```bash
cd terraform
```

### Initialize Terraform backend

```bash
terraform init -backend-config=config.tfbackend -reconfigure
```

### Apply Terraform templates

```bash
terraform apply -var-file=config.tfvars
```

## Expose Application Service

Run the following command to create a Classic Load Balancer then set up a DNS record to point to it.

```bash
kubectl expose deployment my-go-app --type=LoadBalancer --name=my-go-app-loadbalancer --port=80
```

Adjust `chart/values.yaml` to enable ingress and configure routing and redeploy chart.

```yaml
ingress:
  enabled: true
  className: ""
  annotations: {}
  hosts:
    - host: www.mydomain.com
      paths:
        - path: /
          pathType: ImplementationSpecific
```

## Install ArgoCD

Run the following command to install ArgoCD server and its components.

```bash
kubectl apply -k argocd
```

Forward ArgoCD service to access from local machine via <https://localhost:8080>.

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
