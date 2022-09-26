#!/usr/bin/env bash

function start_batch() {
    bash ./create-tunnel-clients.sh \
          --kube-context k3d-stress3 \
          --namespace clients \
          --tunnel-server-addr register-tunnels-20.dev.codefresh.io \
          --tunnel-server-port 443 \
          --target-addr example-server-svc \
          --target-port 80 \
          --client-start $1 \
          --client-stop $2
}

start_batch 0 4


#for i in {0..1} ; do
#    start=$(( i * 100 ))
#    stop=$(( start + 100 ))
#
#    start_batch $start $stop
#    sleep 60
#    echo "Clients deployed: $stop"
#done
