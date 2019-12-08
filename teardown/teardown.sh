#!/bin/sh
#set -e

# Delete the Argo apps first (by deleting the umbrella app)
oc delete Application.argoproj.io user-apps -n argocd

# Delete the Argo project
oc delete Appprojects default -n argocd

# Will use this for notification that the project got actually deleted
argocd_proj_exists=`oc get projects | grep argocd | wc -l`

# Then delete the project itself
oc delete project argocd

# Delete the cluster scope resources
oc delete clusterrole argocd-server argocd-application-controller
oc delete clusterrolebindings argocd-server argocd-application-controller

# Delete Argo CRDs
oc delete crd applications.argoproj.io
oc delete crd appprojects.argoproj.io

# Wait till the project is actually deleted
echo 'Waiting for the project to be deleted.....'
while [ $argocd_proj_exists -eq 1 ]; do argocd_proj_exists=`oc get projects | grep argocd | wc -l`;done
