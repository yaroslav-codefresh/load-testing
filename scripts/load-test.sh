batch=500
tunnels=3000
clusters=0
duration='1m'
servers=2
pool=15
interval=1
active=3000
env="prem20"

#users=10
#k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/ws_${env}[$active]_local[$clusters]_${servers}ser[${pool}pool]_${tunnels}tunn_5inst_${users}user_${duration}_${interval}sec.log"
#
#users=100
#k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/ws_${env}[$active]_local[$clusters]_${servers}ser[${pool}pool]_${tunnels}tunn_5inst_${users}user_${duration}_${interval}sec.log"
#
#users=200
#k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/ws_${env}[$active]_local[$clusters]_${servers}ser[${pool}pool]_${tunnels}tunn_5inst_${users}user_${duration}_${interval}sec.log"
#
#users=300
#k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/ws_${env}[$active]_local[$clusters]_${servers}ser[${pool}pool]_${tunnels}tunn_5inst_${users}user_${duration}_${interval}sec.log"
#
#users=400
#k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/ws_${env}[$active]_local[$clusters]_${servers}ser[${pool}pool]_${tunnels}tunn_5inst_${users}user_${duration}_${interval}sec.log"
#
users=500
k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/ws_${env}[$active]_local[$clusters]_${servers}ser[${pool}pool]_${tunnels}tunn_5inst_${users}user_${duration}_${interval}sec.log"

#users=600
#k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/ws_${env}[$active]_local[$clusters]_${servers}ser[${pool}pool]_${tunnels}tunn_5inst_${users}user_${duration}_${interval}sec.log"


# todo: check this
# 2022/09/27 10:27:31 [W] [http.go:115] do http proxy request [host: register-tunnels-10.dev.codefresh.io:443] error: no route found: register-tunnels-10.dev.codefresh.io /~!frp

# todo: check this
# after testing 500 reqs 100 clients disconnected and could not reconnect
# 2022/09/27 12:39:18 [I] [service.go:202] [eae38ea604dc7698] try to reconnect to server...
# 2022/09/27 12:39:18 [W] [service.go:205] [eae38ea604dc7698] reconnect to server error: bad status, wait 20s for another retry
