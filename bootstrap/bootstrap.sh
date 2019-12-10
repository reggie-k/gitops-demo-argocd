#!/bin/sh

set -e

# Create a project for Argo to live in
oc new-project argocd

# Install Argo
oc apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 

# Create the Route
oc apply -f ../argo-resources/argo-route.yaml

# Create the custom config map with the required exclusions to pass Route sync
oc apply -f ../argo-resources/argo-cm.yaml

# Create the argo user-app 
# oc apply -f ../argo-resources/argo-user-apps.yaml

# Print the initial password (it is the name of the argocd-server pod)
ARGOCD_SERVER_PASSWORD=$(oc -n argocd get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')
echo $ARGOCD_SERVER_PASSWORD
