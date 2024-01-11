# my-go-app

This is a boilerplate for integrating CI/CD to a simple Go application with modern stack including Docker Hub, Kustomize, Helm, ArgoCD, Terraform, and Github Actions to deploy on EKS. The deployed application also has custom IAM policies attached to its service account through an IAM Role created by Terraform.

## Build and Deploy Manually

We have Github Actions set up for this repository but you can run the following commands if you are interested in building and deploying a Docker image manually. The `aunnk/my-go-app` is a Docker Hub repository for this project. Please change it to your own before running.

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

Go to the chart directory.

```bash
cd chart
```

### Install Chart

Install the chart for the first time. The release name (my-go-app) is not fixed. We just use the application name for simplicity.

```bash
helm install my-go-app .
```

### Update Chart

Redeploy the chart by running the following command. The release name should match with installation command.

```bash
helm upgrade my-go-app .
```

### Forward Application Service to Localhost

Forward application service to access from local machine via <http://localhost:8080>.

```bash
kubectl -n default port-forward svc/my-go-app 8080:8080
```

## Initialize Infrastructure via Terraform

Go to the terraform directory.

```bash
cd terraform
```

### Initialize Terraform Backend

It is recommended to use a backend (in this case, S3) to store Terraform state instead of local `terraform.tfstate` file to avoid state overriding when working on multiple environments.

```bash
terraform init -backend-config=config.tfbackend -reconfigure
```

### Apply Terraform Templates

```bash
terraform apply -var-file=config.tfvars
```

### Set Kubernetes Context from EKS

```bash
aws eks update-kubeconfig --region ap-southeast-1 --name my-eks-cluster --alias eks
```

## Install ArgoCD

Run the following command to install ArgoCD server and its components.

```bash
kubectl apply -k argocd
```

Forward ArgoCD service to access from local machine via <https://localhost:8081>.

```bash
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Get initial admin password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
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
