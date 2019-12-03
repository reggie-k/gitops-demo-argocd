#!/bin/sh

set -e

# Create a project for Argo to live in
oc new-project argocd

# Install argo
oc apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 

# Create the argo user-app 
oc apply -f ../argo-resources/argo-user-apps.yaml
