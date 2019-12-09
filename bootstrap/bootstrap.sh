#!/bin/sh

set -e

# Create a project for Argo to live in
oc new-project argocd

# Install Argo
oc apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 

# Create the Route
oc apply -f ../argo-resources/route.yaml

# Create the argo user-app 
oc apply -f ../argo-resources/argo-user-apps.yaml

# It takes some for the CRD to become available for creation of CRs, so let's wait till the CR is created
argocd_user_apps_exists=`oc get Application.argoproj.io user-apps -n argocd | wc -l`
echo 'Waiting for the application to be created.....'
while [ $argocd_user_apps_exists -eq 1 ]; do argocd_user_apps_exists=`oc get Application.argoproj.io user-apps -n argocd | wc -l`;done

# Print the initial password (it is the name of the argocd-server pod)
ARGOCD_SERVER_PASSWORD=$(oc -n argocd get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')
echo $ARGOCD_SERVER_PASSWORD
