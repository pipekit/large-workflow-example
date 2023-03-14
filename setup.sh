#!/bin/bash

k3d cluster create --config bootstrap/k3d.conf

# Prevent users from accidentally deploying to the wrong cluster.
currentContext=$(kubectl config current-context)
if [ "$currentContext" == "k3d-large-workflows" ]; then
    echo "Starting deployment to cluster..."
else
    echo "The kubectl context is not what we expected. Exiting for safety. Perhaps the k3d cluster failed to create?"
    exit 1
fi

# Deploy Argo CD, which in turn deploys everything else
kubectl -n kube-system rollout status deployment/metrics-server
kubectl apply -k bootstrap/argocd
kubectl -n argocd rollout status statefulset/argocd-application-controller
kubectl -n argocd rollout status deployment/argocd-repo-server
kubectl -n argocd apply -f bootstrap/app-of-apps

# Wait for Argo CD to start syncing its new-found applications
sleep 30
kubectl -n postgres rollout status deployment/postgres
kubectl -n argo rollout status deployment/workflow-controller
kubectl -n argo rollout status deployment/argo-server
kubectl -n argo-events rollout status deployment/controller-manager
kubectl -n argo-events rollout status deployment/events-webhook
kubectl -n minio rollout status deployment/minio

echo "Complete."
