#
# patches to use metalb LB to expose externally, instead of plain in-cluster ClusterIP
#
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc argocd-server -n argocd -p '{"metadata": {"annotations": {"metallb.universe.tf/address-pool": "network-services"}}}'
#pw:  argocd-server-5f445f5c49-kv24b
