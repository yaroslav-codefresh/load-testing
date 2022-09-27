batch=500
tunnels=200
users=3000
clusters=1
duration='1m'

k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/local[$clusters]_1ser[15pool]_${tunnels}tunn_5inst_${users}user_${duration}.log"


# todo: check this
# 2022/09/27 10:27:31 [W] [http.go:115] do http proxy request [host: register-tunnels-10.dev.codefresh.io:443] error: no route found: register-tunnels-10.dev.codefresh.io /~!frp

# todo: check this
# after testing 500 reqs 100 clients disconnected and could not reconnect
# 2022/09/27 12:39:18 [I] [service.go:202] [eae38ea604dc7698] try to reconnect to server...
# 2022/09/27 12:39:18 [W] [service.go:205] [eae38ea604dc7698] reconnect to server error: bad status, wait 20s for another retry
