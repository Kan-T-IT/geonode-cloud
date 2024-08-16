![Kan Territory & IT](https://kan.com.ar/wp-content/uploads/2024/01/logoSM.png)

![GeoNode](https://geonode.org/static/img/geonode_logo.png)

# GeoNode Cloud

<i>**GeoNode Cloud**</i> is an advanced implementation of the GeoNode platform in the cloud, focused on maximizing the use of native or adapted technologies for cloud environments. This solution is designed to be deployed on Kubernetes, which facilitates its scalability, management and resilience.
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

* Django Geonode
    * Django Framework
    * Memcached
    * Geonode Import
    * pyCSW
* GeoNode Mapstore Client
* Celery Geonode
* Rabbitmq
* GeoServer Cloud
* Postgres with PostGis extension
* Nginx
* Flower

## License

*GeoNode Cloud* licensed under the [GPLv2](LICENSE.txt).

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