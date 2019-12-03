#!/bin/sh

set -e

# Create a project for Argo to live in
oc new-project argocd

# Install Argo
oc apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 

# Create the Route
oc apply -f ../argo-resources/route.yaml

# Wait a bit... it takes some for the CRD to become available for creation of CRs
sleep 15

# Create the argo user-app 
oc apply -f ../argo-resources/argo-user-apps.yaml
