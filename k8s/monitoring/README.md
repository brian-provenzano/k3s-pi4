## Monitoring
Using the official stable helm charts for grafana and prometheus

- https://github.com/helm/charts/tree/master/stable/grafana
- https://github.com/helm/charts/tree/master/stable/prometheus

TODO: configure custom_values.yaml overrides to setup the services as LBs for Grafana instead of default ClusterIP.  I am currently applying a secondary service manifest to update to MetalLB after the helm chart is deployed.  It is hacky to say the least...
