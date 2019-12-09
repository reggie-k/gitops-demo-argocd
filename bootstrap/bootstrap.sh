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

# Create the chuck argo project 
oc apply -f ../argo-resources/gitops-resources/chuck-project.yaml

# It takes some for the CRD to become available for creation of CRs, so let's wait till the CRs are created
#argocd_user_apps_exists=`oc get Application.argoproj.io user-apps -n argocd | wc -l`
#echo 'Waiting for the Argo user-apps application to be created.....'
#while [ $argocd_user_apps_exists -eq 1 ]; do argocd_user_apps_exists=`oc get Application.argoproj.io user-apps -n argocd | wc -l`;done

#echo 'Waiting for the Argo default project to be created.....'
#argocd_default_project_exists=`oc get Appprojects.argoproj.io default -n argocd | wc -l`
#while [ $argocd_default_project_exists -eq 1 ]; do argocd_default_project_exists=`oc get Appprojects.argoproj.io default -n argocd | wc -l`;done

# Print the initial password (it is the name of the argocd-server pod)
ARGOCD_SERVER_PASSWORD=$(oc -n argocd get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')
echo $ARGOCD_SERVER_PASSWORD
