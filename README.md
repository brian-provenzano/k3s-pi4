## K3s on Raspberry Pi AKA Mess O' Code
This is just a local project to get some items running on k3s 1 node "cluster" on Pi4 - this repo is not well documented.  It is just here for me (for now) :)

K3s includes:
- metrics server
- local-path local storage provisioner (rancher)
- traefik


### Load Balancer - Services
Currently using metallb for LoadBalancer in layer2 mode (not BGP)
https://metallb.universe.tf/

### Monitoring
Using grafana, prometheus helm charts
- https://github.com/helm/charts/tree/master/stable/grafana
- https://github.com/helm/charts/tree/master/stable/prometheus

Was going to use the prometheus-operator, but currently does not support ARM on Pi.


### Storage Classes (options)

### #Local storage provisioner (Local-Path)
Currently using local-path storage provisioner for some PV/PVC - namely for prometheus, grafana etc which have issues usingNFS storage for persistent volumes (lock file issues). This is included by rancher in k3s by default - it is the default storage class.

https://github.com/rancher/local-path-provisioner

#### NFS provisioner
https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client
https://github.com/kubernetes-incubator/external-storage/blob/master/nfs/docs/deployment.md#in-kubernetes---deployment-of-1-replica

Using the NFS client provisoner for most non-prometheus volumes (pihole currently).  NFS server is setup on the k3s node (for now).