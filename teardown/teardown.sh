#!/bin/sh
set -e

# Delete the Argo apps first (by deleting the umbrella app)
oc delete Application.argoproj.io user-apps -n argocd

# Delete the Argo project

# Then delete the project itself
oc delete project argocd

# Delete the cluster scope resources
oc delete clusterrole argocd-server argocd-application-controller
oc delete clusterrolebindings argocd-server argocd-application-controller

# Delete Argo CRDs
oc delete crd applications.argoproj.io
oc delete crd appprojects.argoproj.io