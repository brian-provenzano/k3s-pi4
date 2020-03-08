#!/bin/bash
#patch to change default storage class; default for k3s is local-path storage provisioner
kubectl patch storageclass <your-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
