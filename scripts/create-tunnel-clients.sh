#!/usr/bin/env bash

# Prerequisites:
# * Create a 'codefresh-token' secret with a 'token' field containing a valid runtime token
# * Create a target server that all tunnel clients would proxy the requests to

set -o pipefail
set -e

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --kube-context) kube_context="$2"; shift ;;
        --namespace) namespace="$2"; shift ;;
        --tunnel-server-addr) tunnel_server_addr="$2"; shift ;;
        --tunnel-server-port) tunnel_server_port="$2"; shift ;;
        --target-addr) target_addr="$2"; shift ;;
        --target-port) target_port="$2"; shift ;;
        --client-start) client_start="$2"; shift ;;
        --client-stop) client_stop="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "kube_context=$kube_context"
echo "namespace=$namespace"
echo "tunnel_server_addr=$tunnel_server_addr"
echo "tunnel_server_port=$tunnel_server_port"
echo "target_addr=$target_addr"
echo "target_port=$target_port"
echo "client_start=$client_start"
echo "client_stop=$client_stop"

kubectl config use-context "$kube_context"

function create_pod() {
    i=$1
    frpc_name="test$i"

       echo "
    apiVersion: v1
    data:
      frpc.ini: |-
        [common]
        server_addr = $tunnel_server_addr
        server_port = $tunnel_server_port
        log_level = trace
        admin_addr = 127.0.0.1
        admin_port = 7400
        admin_user = admin
        admin_pwd = admin
        tls_enable = true
        disable_custom_tls_first_byte = true
        protocol = wss

        [$frpc_name]
        type = http
        local_ip = $target_addr
        local_port = $target_port
        locations = /
        subdomain = $frpc_name
        meta_Authorization = {{ .Envs.AUTHORIZATION }}
    kind: ConfigMap
    metadata:
      name: frpc-config-$frpc_name
      labels:
        app: frpc
    " | kubectl -n "$namespace" apply -f -

      echo "
    apiVersion: v1
    kind: Pod
    metadata:
      name: frpc-$frpc_name
      labels:
        app: frpc
    spec:
      containers:
        - image: quay.io/codefresh/frpc:2022.09.08-2384484
          name: frpc
          imagePullPolicy: Always
          env:
            - name: AUTHORIZATION
              valueFrom:
                secretKeyRef:
                  name: codefresh-token
                  key: token
                  optional: false
          resources:
            limits:
              memory: 100Mi
            requests:
              memory: 30Mi
          volumeMounts:
            - mountPath: /etc/frp
              name: frpc-vol-$frpc_name
      volumes:
        - name: frpc-vol-$frpc_name
          projected:
            sources:
              - configMap:
                  name: frpc-config-$frpc_name
                  optional: false
                  items:
                    - key: frpc.ini
                      path: frpc.ini
    " | kubectl -n "$namespace" apply -f -

    echo "\"https://$frpc_name.tunnels20.dev.codefresh.io\"," >> clients.csv
}

for (( i=client_start; i < client_stop; i++ ))
do
   create_pod "$i" &
done
