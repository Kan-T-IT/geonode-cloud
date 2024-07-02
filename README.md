# Despliegue

1. Creamos los siguientes directorios en /mnt/data:

- dbdata
- geowebcache-data
- rabbitmq-data
- statics
- tmp

2. Nos dirigimos al root del proyecto y Levantamos los "secrets", "ingress", "certs" "StorageClass"

```
kubectl apply -f secrets
kubectl apply -f ingress
kubectl apply -f certs
kubectl apply -f StorageClass
```
3. Levantamos la base de datos

`kubectl apply -R -f database`

4. Levantamos gn-cloud

`kubectl apply -R -f gn-cloud`

5. Levantamos gs-cloud

`kubectl apply -R -f gs-cloud`
