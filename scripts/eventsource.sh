source ./namespace.sh

kubectl -n $NAMESPACE port-forward "deployment/$(kubectl -n $NAMESPACE get deployment | grep test-eventsource | awk '{print $1}')" 12000:80
