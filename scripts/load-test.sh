batch=1000
tunnels=600
users=100
duration='1m'

k6 run tunnels.js --vus $users --batch --duration $duration $batch > "../reports/local[3]_2ser_${tunnels}tunn_5inst_${users}user_${duration}"
