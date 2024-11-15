![Kan Territory & IT](https://kan.com.ar/wp-content/uploads/2024/01/logoSM.png)

![GeoNode](https://geonode.org/static/img/geonode_logo.png)

# GeoNode Cloud

<i>**GeoNode Cloud**</i> is an advanced implementation of the [GeoNode](https://github.com/GeoNode/geonode) platform in the cloud, focused on maximizing the use of native or adapted technologies for cloud environments. This solution is designed to be deployed on Kubernetes, which facilitates its scalability, management and resilience.
GeoNode Cloud incorporates the [GeoServer Cloud](https://github.com/geoserver/geoserver-cloud) project, which provides robust support for the publication, editing and management of geospatial data, thus reinforcing its purpose of offering a modern and efficient infrastructure for the management of geospatial information in the cloud.
With GeoNode Cloud, organizations can benefit from greater flexibility, reduced operational costs, and seamless integration with other cloud-native tools and services.

## Project Structure

The project structure for deploying GeoNode Cloud and GeoServer Cloud on Kubernetes is organized into key directories that contain the manifests required to configure and operate the applications. Within the following repository is the project that contains all the manifests that will be used to perform the deployment.

**Main Directories**

* gn-cloud
* gs-cloud
* configs
* database

## Architecture & Technology


The solution architecture is divided into the following components: 

* [Geonode Cloud Core](https://github.com/Kan-T-IT/geonode-cloud-core)
* [GeoNode Cloud Mapstore Client](https://github.com/Kan-T-IT/geonode-cloud-mapstore-client)
* [Rabbitmq](https://github.com/rabbitmq)
* [GeoServer Cloud](https://github.com/geoserver/geoserver-cloud)
* [Postgres](https://github.com/postgres) with PostGis extension
* [Nginx](https://github.com/nginx/nginx)
* [Flower](https://github.com/mher/flower)

Specifically **Geonode Cloud Core** contains the following main technological components for its operation: 

* Django Framework
* Memcached
* Geonode Import
* [pyCSW](https://github.com/geopython/pycsw)
* Celery
* [Geoserver App Django - ACL Capability](https://github.com/Kan-T-IT/geonode-cloud-core/tree/main/geonode/geoserver/acl) 

The architecture is based on the use of microservices, where it is planned to incorporate new microservices that today are in the monolithic component of Django. 


## Distribution and deployment

Docker images for all the services are available on DockerHub, under the [KAN Territory & IT organization](https://hub.docker.com/u/kantit).

You can find  production-suitable deployment files for docker-compose and podman under the [docs/deploy](docs/deploy) folder.


## Contributing

Please read [the contribution guidelines](CONTRIBUTING.md) before contributing pull requests to the Geonode Cloud project.

Follow the [developer's guide]() to know more about the project's technical details.

## Status

Read the [changelog](https://github.com/Kan-T-IT/geonode-cloud/releases) for more information.


## Bugs

*GeoNode Cloud*'s issue tracking is at this [Issues GitHub](https://github.com/Kan-T-IT/geonode-cloud/issues) repository.

## Roadmap

TDB

# Deployment

For the deployment of Geonode Cloud we can deploy it on different Kubernete platforms, here are the details of the deployment on MickoK8S 

## Deployment on MicroK8S

## Requisites

* MicroK8S.
    * Ingress module.
    * DNS module.
    * Cert-manager module.


### Use snap to install microk8s
```bash
sudo snap install microk8s --classic
```

### Enable necesary micro8s modules

```bash
microk8s enable ingress
microk8s enable cert-manager
```

### Create certmanager config to enable letsencrypt using your own email
```bash
microk8s kubectl apply -f - <<EOF
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    email: YOUREMAIL@DOMAIN.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: letsencrypt-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: public
EOF
```

## Deployment

### Clone this repository

```bash
git clone https://github.com/Kan-T-IT/geonode-cloud.git && cd geonode-cloud
```

### Edit all fields in .env file with the necesary information.
```env
KUBERNETES_SITE_URL=GEONODE_CLOUD_FINAL_URL    # i.e.: cloud.mygeonode.com
KUBERNETES_NODE_NAME=YOUR_CLUSTER_NAME_NAME    # usually host machine name
KUBERNETES_VOL_DIR=YOUR_DESIRED_LOCATION       # this path shold exist
CLUSTER_ISSUER_NAME=YOUR_CLUSTER_ISSUER_NAME   # created earlier in this guide
SERVER_PUBLIC_IP=YOU.RPU.BLI.CIP               # the public ipv4 of the server                 
GEONODE_PASSWORD=admin                         # password for geonode admin user 
GEOSERVER_PASSWORD=geoserver                   # password for geoserver admin user
```
### Run `./install.sh` and enjoy.

---

## Deployment on EKS

### Prerequisites

Ensure that the EKS cluster is up and running and configured with the following:

1. **OIDC Provider and IAM**: Configure the OIDC provider for the EKS cluster.
2. **IAM Service Account for AWS Load Balancer Controller**: Create the IAM service account and attach the necessary policies.
3. **Necessary Addons**: Install AWS Load Balancer Controller and EBS CSI Driver.

### Despliegue de Recursos Kubernetes

To deploy the necessary resources on EKS, follow this order:

- **Cluster and StorageClass**
  - `cluster.yaml` in `clusterEksctl` (if the cluster is not already created).
  - `local-storageclass.yaml` in `configs/storageclass` (to set up the StorageClass before creating volumes).

- **Database**
  - ConfigMap: `gndatabase-configmap.yaml` in `database/configmaps`.
  - PVC: `dbdata-pvc.yaml` in `database/volumes`.
  - Deployment: `gndatabase-deployment.yaml` in `database/deployments`.
  - Service: `gndatabase-service.yaml` in `database/services`.

- **gn-cloud Components**
  - ConfigMaps in `gn-cloud/configmaps` (to make all configurations available).
  - PVCs: `statics-pvc.yaml` and `tmp-pvc.yaml` in `gn-cloud/volumes`.
  - Deployments: Deploy `celery`, `django`, `mapstore`, `memcache`, and `redis` in `gn-cloud/deployments`.
  - Services for each component in `gn-cloud/services`.

- **gs-cloud Components**
  - ConfigMaps in `gs-cloud/configmaps` (to have all configurations ready).
  - PVCs: `geowebcache-data-persistentvolumeclaim.yaml` and `rabbitmq-data-persistentvolumeclaim.yaml` in `gs-cloud/volumes`.
  - Deployments: Deploy `acl`, `gateway`, `gwc`, `rabbitmq`, `rest`, `wcs`, `webui`, `wfs`, and `wms` in `gs-cloud/deployments`.
  - Services in `gs-cloud/services`.

- **Ingress**
  - Finally, apply `geonode-ingress.yaml` in `configs/ingress` to expose services to the outside.

After following these steps, verify the status of your pods and services.