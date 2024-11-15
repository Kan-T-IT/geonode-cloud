#!/bin/bash
source .env

echo "Applying .env config"

grep -rl KUBERNETES-SITE-URL --exclude install.sh . | xargs sed -i 's|KUBERNETES-SITE-URL|'"$KUBERNETES_SITE_URL"'|g'
grep -rl KUBERNETES-NODE-NAME --exclude install.sh . | xargs sed -i 's|KUBERNETES-NODE-NAME|'"$KUBERNETES_NODE_NAME"'|g'
grep -rl KUBERNETES-VOL-DIR --exclude install.sh . | xargs sed -i 's|KUBERNETES-VOL-DIR|'"$KUBERNETES_VOL_DIR"'|g'
grep -rl CLUSTER-ISSUER-NAME --exclude install.sh . | xargs sed -i 's|CLUSTER-ISSUER-NAME|'"$CLUSTER_ISSUER_NAME"'|g'

sed -i 's|SERVER-PUBLIC-IP|'"$SERVER_PUBLIC_IP"'|g' ./configs/loadbalancer/metallb-configmap.yaml 
sed -i 's|GEOSERVER_ADMIN_PASSWORD: geoserver|GEOSERVER_ADMIN_PASSWORD: '"$GEOSERVER_PASSWORD"'|g' ./gn-cloud/configmaps/geonode-configmap.yaml
sed -i 's|ADMIN_PASSWORD: admin|ADMIN_PASSWORD: '"$GEONODE_PASSWORD"'|g' ./gn-cloud/configmaps/geonode-configmap.yaml 

mkdir  $KUBERNETES_VOL_DIR/dbdata/
mkdir  $KUBERNETES_VOL_DIR/geowebcache-data/
mkdir  $KUBERNETES_VOL_DIR/pgconfigdb-data/
mkdir  $KUBERNETES_VOL_DIR/rabbitmq-data/
mkdir  $KUBERNETES_VOL_DIR/statics/
mkdir  $KUBERNETES_VOL_DIR/tmp/

microk8s enable metallb:$SERVER_PUBLIC_IP-$SERVER_PUBLIC_IP
microk8s kubectl apply -R -f configs
microk8s kubectl apply -R -f database

echo "Waiting for database to start"

tempgndb=`microk8s kubectl get pod -l component=gndatabase --no-headers`
gnbd=( $tempgndb )
gnbdstatus=${gnbd[2]}

while [ "$gnbdstatus" != "Running" ]
do
    tempgndb=`microk8s kubectl get pod -l component=gndatabase --no-headers`
    gnbd=( $tempgndb )
    gnbdstatus=${gnbd[2]}
done
sleep 5

echo "Applying initial database configuration"

gndatabase=${gnbd[0]}

microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "CREATE ROLE geonode WITH PASSWORD 'geonode'";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "CREATE ROLE geonode_data WITH PASSWORD 'geonode_data'";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "CREATE ROLE pgconfig WITH PASSWORD 'pgconfig'";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "ALTER ROLE geonode WITH login";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "ALTER ROLE geonode WITH superuser";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "ALTER ROLE geonode_data WITH login";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "ALTER ROLE geonode_data WITH superuser";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "ALTER ROLE pgconfig WITH login";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "ALTER ROLE pgconfig WITH superuser";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "CREATE DATABASE geonode WITH OWNER 'geonode'";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "CREATE DATABASE geonode_data WITH OWNER 'geonode_data'";
microk8s kubectl exec -it $gndatabase -- psql -U postgres postgres -c "CREATE DATABASE pgconfig WITH OWNER 'pgconfig'";
microk8s kubectl exec -it $gndatabase -- psql -U postgres geonode -c "CREATE EXTENSION postgis";
microk8s kubectl exec -it $gndatabase -- psql -U postgres geonode_data -c "CREATE EXTENSION postgis";
microk8s kubectl exec -it $gndatabase -- psql -U postgres pgconfig -c "CREATE EXTENSION postgis";

echo "Starting remaining services"

microk8s kubectl apply -R -f gn-cloud
microk8s kubectl apply -R -f gs-cloud

tempdjango=`microk8s kubectl get pod -l component=django --no-headers`
django=( $tempdjango )
djangostatus=${django[2]}

while [ "$djangostatus" != "Running" ]
do
    tempdjango=`microk8s kubectl get pod -l component=django --no-headers`
    django=( $tempdjango )
    djangostatus=${django[2]}
done

echo "Done."