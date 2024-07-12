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
* ingress
* secrets

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

## Deployment

1. In `/mnt/data`:

``` bash
mkdir -p ./dbdata ./geowebcache-data ./rabbitmq-data ./statics ./tmp
```

2. In the cloned folder we start the services "secrets", "ingress", "certs" and "StorageClass"

```
kubectl apply -f secrets
kubectl apply -f ingress
kubectl apply -f certs
kubectl apply -f StorageClass
```

3. Start up the database

`kubectl apply -R -f database`

4. Start up the gn-cloud service

`kubectl apply -R -f gn-cloud`

5. Start up the gs-cloud service

`kubectl apply -R -f gs-cloud`
