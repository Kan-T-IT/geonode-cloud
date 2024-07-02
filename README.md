# Deploy

1.  In `/mnt/data`:

```bash
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
