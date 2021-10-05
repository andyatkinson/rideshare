## Kubernetes

<https://kubernetes-rails.com/>

### Docker

`docker build -t andyatkinson/rideshare:latest .`

Docker private repository. Signed in to Docker desktop.

`docker push andyatkinson/rideshare:latest`

### EKS

[Getting started with Amazon EKS – eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)

`eksctl create cluster --name rideshare-cluster --region us-east-1 --fargate`

### kubectl

[Cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

`kubectl version`

After creating the deployment and load balancer, apply the configuration.

`kubectl apply -f config/kube`

`kubectl rollout restart deployment.apps/kubernetes-rideshare-deployment`
