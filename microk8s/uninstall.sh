#!/bin/bash
source .env

rm -rf  $KUBERNETES_VOL_DIR/dbdata/
rm -rf  $KUBERNETES_VOL_DIR/geowebcache-data/
rm -rf  $KUBERNETES_VOL_DIR/pgconfigdb-data/
rm -rf  $KUBERNETES_VOL_DIR/rabbitmq-data/
rm -rf  $KUBERNETES_VOL_DIR/statics/
rm -rf  $KUBERNETES_VOL_DIR/tmp/

microk8s kubectl delete -R -f .