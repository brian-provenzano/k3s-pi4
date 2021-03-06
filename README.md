# THIS PROJECT IS DEPRECATED - see [https://github.com/brian-provenzano/k3s-raspberry-atomic-pi](https://github.com/brian-provenzano/k3s-raspberry-atomic-pi)


## K3s on Raspberry Pi AKA Mess O' Code
This is just a local project to get some items running on k3s 1 node "cluster" on Pi4 - this repo is not well documented.  It is just here for me (for now) :)

K3s includes:
- metrics server
- local-path local storage provisioner (rancher)
- traefik

## Hardware
Currently only one node (Pi4 with 4GB of RAM) running on wifi networking which is not optimal
- Pi4 4GB model
- USB3 HDD (spare spinning disk laptop drive)
- Official Pi4 USB C power adapter
- Pi4 Case [with fan and heatsinks](https://www.amazon.com/gp/product/B01LXSMY1N/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)

TODO: expand to 2-3 nodes...

### Load Balancer - Services
Currently using metallb for LoadBalancer in layer2 mode (not BGP)
https://metallb.universe.tf/

NOTE: Pi4 Wifi adapter has issues with ARP so when using MetalLB in Layer 2 mode (which is what I am doing), I have to set the wifi adapters to promiscous mode.  This is only bc I am lazy and am currently using the wifi adapters - need ot switch to eth at some point.  Once this is done this problem goes away (I think)

```
sudo ip link set wlan0 promisc on
```
^^ set this to run at boot on the Pi4 if you have this problems


### Monitoring
Using grafana, prometheus helm charts
- https://github.com/helm/charts/tree/master/stable/grafana
- https://github.com/helm/charts/tree/master/stable/prometheus

Was going to use the prometheus-operator, but currently does not support ARM on Pi.


### ArgoCD
[ArgoCD deployment](/k8s/argocd)

https://argoproj.github.io/

No ARM images were available so using `image: phillebaba/argocd:v1.4.2` in the deployment.


### Polaris
https://github.com/FairwindsOps/polaris

Uses the Polaris Armv7 v1.0.3 binary here: https://github.com/FairwindsOps/polaris/releases/download/1.0.3/polaris_1.0.3_linux_armv7.tar.gz

Custom [Dockerfile](/k8s/polaris/Dockerfile) and [Makefile](/k8s/polaris/Makefile) to build ARM image since Polaris doesnt support yet (but they do have the ARM binary ^^)

Quick Setup:
Just swap out the image in the v1.0.3 [deployment yaml](https://github.com/FairwindsOps/polaris/releases/download/1.0.3/dashboard.yaml) for this my [custom image](https://hub.docker.com/r/warpigg/polaris-arm) and apply.  Already done [here](/k8s/polaris/dashboard.yaml)


### PiHole
[Deployment yaml](/k8s/staging/pihole)

Now using cloudflared sidecar to provide dns https support

- https://github.com/crazy-max/docker-cloudflared 
- https://docs.pi-hole.net/guides/dns-over-https/


### Secrets (Bitnami Sealed Secrets)
Using [bitnami sealed secrets](https://github.com/bitnami-labs/sealed-secrets) (now has ARM build) in pihole deployments

Quick process:
- create a k8s secret (base64 encoded)
- `kubeseal --format yaml <k8s-secrets.yaml >sealedsecrets.yaml`
- `kubectl apply -f sealedsecrets.yaml`

You can commit the sealedsecret to git

### Storage Classes (options)
Storage is currently handled by a USB3 attached local drive on the node.  Booting and root filesystem is still on the SD card (TODO - to change this to /boot on SDcard and all other mount points to the USB drive.  Currently should work on Pi4 - hasnt in the past.)

#### Local storage provisioner (Local-Path)
Currently using local-path storage provisioner for some PV/PVC - namely for prometheus, grafana etc which [have issues using NFS storage](https://github.com/prometheus/prometheus/issues/1600) for persistent volumes (lock file issues). This is included by rancher in k3s by default - it is the default storage class.

https://github.com/rancher/local-path-provisioner

#### NFS provisioner
https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client
https://github.com/kubernetes-incubator/external-storage/blob/master/nfs/docs/deployment.md#in-kubernetes---deployment-of-1-replica

Using the NFS client provisoner for most non-prometheus volumes (pihole currently).  NFS server is setup on the k3s node (for now).
