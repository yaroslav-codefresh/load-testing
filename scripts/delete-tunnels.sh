#!/usr/bin/env bash

kubectl config use-context k3d-stress3
#kubectl config use-context yaroslav
# 110 per node

echo "" > clients.csv

kubectl -n clients delete po -l app=frpc
kubectl -n clients delete cm -l app=frpc


#export K3D_FIX_DNS=1 && k3d cluster create stress \
#  --agents 10 \
#  -p 8082:80@loadbalancer \
#  --k3s-arg="--kubelet-arg=config=/etc/kubelet-config.yaml@agents:*" \
#  -v /home/yaroslav/work/codefresh/local-cf-29_git-source/resources_local-cf-29/kubelet-config.yaml:/etc/kubelet-config.yaml@agents:*
