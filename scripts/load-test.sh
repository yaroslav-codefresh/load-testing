batch=1000
tunnels=600
users=1000
duration='1m'

k6 run tunnels.js --vus $users --batch $batch --duration $duration  > "../reports/local[3]_2ser_${tunnels}tunn_5inst_${users}user_${duration}.log"
