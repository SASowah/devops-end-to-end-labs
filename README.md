# Project 4: GitOps React + Java App on EKS with ArgoCD, Prometheus & Grafana

## Project Overview

This project showcases a complete GitOps-driven CI/CD pipeline for deploying a multi-tier application consisting of a **React frontend** and a **Java backend** onto an Amazon EKS cluster. Infrastructure is provisioned using **Terraform**, application delivery is automated via **ArgoCD**, and observability is implemented using **Prometheus** and **Grafana**.


---

##  Tech Stack

| Layer              | Tool/Service                         |
| ------------------ | ------------------------------------ |
| Infrastructure     | Terraform (EKS, VPC, ALB, IAM, IRSA) |
| Kubernetes Cluster | Amazon EKS                           |
| GitOps Delivery    | ArgoCD                               |
| Frontend App       | React (deployed via Helm)            |
| Backend App        | Java + Maven (deployed via Helm)     |
| Ingress Controller | AWS Load Balancer Controller (ALB)   |
| Monitoring         | Prometheus + Grafana (Helm)          |

---

## Infrastructure Provisioning

Terraform modules under `/terraform/eks/` provision the following AWS resources:

* VPC with public and private subnets
* EKS Cluster and Node Groups
* IAM roles and OIDC setup for service accounts (IRSA)
* ALB Ingress Controller

### Deploy Infra

```bash
cd terraform/eks
terraform init
terraform apply -auto-approve
```

### Connect to Cluster

```bash
aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>
```

---

## GitOps App Deployment with ArgoCD

ArgoCD is bootstrapped using manifests in `/argocd/install.yaml`, and application definitions are stored in `/argocd/applications/`.

### Deploy ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f argocd/install.yaml
```

### Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Visit: [https://localhost:8080](https://localhost:8080)
Default login: `admin / <password from secret>`

### Deploy Applications

```bash
kubectl apply -f argocd/applications/frontend-app.yaml
kubectl apply -f argocd/applications/backend-app.yaml
```

Sync them via the ArgoCD UI.

---

## 🌐 Ingress (ALB) for External Access

Each app has an Ingress definition managed by ArgoCD and exposed via the AWS ALB Ingress Controller.

### Get Ingress URLs

```bash
kubectl get ingress -n default
```

Use the ALB DNS names to access:

* React Frontend
* Java Backend API

---

## Monitoring: Prometheus + Grafana

Prometheus and Grafana are deployed **via Helm**, outside GitOps, to avoid sync/CRD issues.

### Install Monitoring Stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set grafana.adminPassword=admin \
  --set grafana.service.type=ClusterIP
```

### Access Grafana

```bash
kubectl port-forward svc/monitoring-stack-grafana -n monitoring 3000:80
```

Then go to [http://localhost:3000](http://localhost:3000)
Login: `admin / admin`

### Dashboards

* Kubernetes / Pods
* Kubernetes / Compute Resources / Namespace (Pods)
* Add more from Grafana.com via Import → Dashboard ID


---

## Outcomes

* GitOps-driven multi-tier deployment
* Fully observable system via Grafana
* Scalable, modular EKS setup with cost awareness
* Clean recovery path via Helm & Terraform separation

---

## Directory Structure

```
/terraform/eks         --> All infra provisioning
/argocd                --> ArgoCD install and app manifests
/frontend              --> React app (Dockerfile, Helm chart)
/backend               --> Java app (Dockerfile, Helm chart)
/helm                  --> App-specific Helm charts
```


---

