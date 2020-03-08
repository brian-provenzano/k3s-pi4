## K3s on Raspberry Pi AKA Mess O' Code
This is just a local project to get some items running on Pi4 - this repo is not well documented.  It is just here for me (for now) :)

K3s includes:
- metrics server
- local-path local storage provisioner (rancher)
- traefik


### Using metallb
Currently using metallb for LoadBalancer in layer2 mode (not BGP)


### Monitoring
Using grafana, prometheus helm charts


### Using the local storage provisioner
Currently using local-path storage provisioner for some PV/PVC - namely for prometheus, grafana etc which have issues usingNFS storage for persistent volumes (lock file issues). 


## Use NFS provisioner
https://github.com/kubernetes-incubator/external-storage/blob/master/nfs/docs/deployment.md#in-kubernetes---deployment-of-1-replica

Using the NFS provisoner for most non-prometheus servers (pihole currently)

