
# Load Testing

### Summary

1) Difference between ingress and ingress-less is pretty small (from 2 ms to 100 ms)
2) Response time on ingress-less has a bit higher difference between min and max values then ingress 
(mostly because sometimes opening  connections can take more time)
3) Amount of passive (when no requests sent) tunnels does not influence on server performance (cpu and memory 
increase for about 1% and 50 MB for keeping 3000 tunnels)
4) Server normally handles huge amount of tunnels (3000) with reasonable amount of requests (about 60 req/sec)
with no additional delay (about 280 ms)
5) When load grows (about 200 - 500 req/sec) the more tunnels handle requests -> the higher response time
(though the cpu and memory does not seem to grow)
6) On such small amount of clients (3000) it does not actually matter to frps whether it's 1500 tunnels or 3000
what we can see from test with multiple frps instances. This means that for huge amount of connections in prod
we can start from relatively small amount of servers (5-10) and understand the situation in production usage
once tunnels amount will grow more than 3000
7) When using multiple servers mode there is a small latency because of additional layer
of proxy doing requests to redis


## Ingress vs Ingress-less

Prerequisites:

1) one frp server instance on gcp cluster (?which resources)
2) aws cluster (m2.large)
3) having nginx echo server
4) having ingress pointing to this nginx
5) having tunnel client pointing to this nginx
6) 1 user ~ 0.8 req/sec (in this iteration)

Analyzing these results we can see that the median value is mostly the same (which tells us that half of requests for 
both ingress and ingress-less had less or equal response time).

Average response time differs and on ingress-less it grows faster when load is being increased.

#### 10 users:

```
ingress:
     http_req_duration..............: avg=170.1ms  min=119.51ms med=138.23ms max=421.28ms p(90)=230.15ms p(95)=247.55ms
ingress-less:
     http_req_duration..............: avg=240.51ms min=121.96ms med=133.18ms max=1.07s    p(90)=565.07ms p(95)=657.62ms
```


#### 100 users:

```
ingress:
     http_req_duration..............: avg=135.82ms min=117.28ms med=129.01ms max=750.72ms p(90)=142.98ms p(95)=177.4ms
ingress-less:
     http_req_duration..............: avg=238.26ms min=120.87ms med=130.75ms max=3.02s    p(90)=515ms    p(95)=625.58ms
```


#### 1000 users:

```
ingress:
     http_req_duration..............: avg=146.51ms min=117.14ms med=131.49ms max=1.68s   p(90)=189.43ms p(95)=253.98ms
ingress-less:
     http_req_duration..............: avg=393.37ms min=117.01ms med=142.91ms max=6.05s   p(90)=1.07s    p(95)=1.45s   
```

## Amount of tunnels

Prerequisites:
1) one frp server instance on gcp cluster (?which resources)
2) 3000 tunnels run on local machine (all connected to server)

Though it does not seem to be the cpu bottleneck on the server side (it never grows higher than 3-4%)

##### Note: we expect that the bottleneck was either network on cluster or on local machine (where clients were run)


#### 3000 tunnels -- sending requests to all of them

These measurements show how server acts when having 3000 tunnels connected and sending different amount of req/sec.

As you can see until the load crosses the threshold of 500 threads the average response time grows really slow.

```
~6 req/sec (10 threads, 1s interval):
     http_req_duration..............: avg=270.08ms min=237.93ms med=243.7ms  max=481.58ms p(90)=377.68ms p(95)=404.65ms
~60 req/sec (100 threads, 1s interval):
     http_req_duration..............: avg=285.91ms min=246.79ms med=256.82ms max=737.97ms p(90)=381.46ms p(95)=455.45ms
~120 req/sec (200 threads, 1s interval):
     http_req_duration..............: avg=320.45ms min=246.3ms  med=273.83ms max=756.44ms p(90)=466.24ms p(95)=509.54ms
~180 req/sec (300 threads, 1s interval):
     http_req_duration..............: avg=318.07ms min=247.15ms med=271.37ms max=1.14s    p(90)=456.77ms p(95)=547.66ms
~230 req/sec (400 threads, 1s interval):
     http_req_duration..............: avg=337.98ms min=247.04ms med=290.56ms max=1.73s    p(90)=452.71ms p(95)=587.6ms 
~230 req/sec (500 threads, 1s interval):
     http_req_duration..............: avg=384.27ms min=247.95ms med=306.41ms max=14.95s   p(90)=558.76ms p(95)=740.68ms
~260 req/sec (600 threads, 1s interval):
     http_req_duration..............: avg=494.2ms  min=247.65ms med=402.66ms max=16.2s   p(90)=737.24ms p(95)=981.17ms
```


#### 3000 tunnels + requests to different amount of them

The load was always the same (sending requests from 600 different threads with interval of 1 sec),
but due to delays of processing amount of actual req/sec was different (because each thread was waiting for its request).

Here we can see that on huge load response time grows when number of simultaneous tunnels transferring these requests grows.
It's because when a new request comes to a tunnel it opens additional connection with client. And the more different tunnels 
handle requests the more connections we finally open. 

```
10 tunnels -- ~400 req/sec:
     http_req_duration..............: avg=386.8ms  min=246.09ms med=282.56ms max=2.35s    p(90)=582.7ms  p(95)=742.81ms
100 tunnels -- ~320 req/sec:
     http_req_duration..............: avg=503.47ms min=248.31ms med=334.39ms max=6.05s    p(90)=636.34ms p(95)=874.65ms
500 tunnels -- ~320 req/sec:
     http_req_duration..............: avg=443.99ms min=248.32ms med=335.17ms max=3.61s   p(90)=571.98ms p(95)=690.55ms
1000 tunnels -- ~270 req/sec:
     http_req_duration..............: avg=524.26ms min=250.04ms med=345.33ms max=12.8s   p(90)=692.71ms p(95)=882.57ms
2000 tunnels -- ~250 req/sec:
     http_req_duration..............: avg=424.1ms  min=248.07ms med=335.74ms max=25.87s   p(90)=688.49ms p(95)=925.56ms
3000 tunnels -- ~250 req/sec:
     http_req_duration..............: avg=494.2ms  min=247.65ms med=402.66ms max=16.2s   p(90)=737.24ms p(95)=981.17ms

```


## Single vs Multiple (2) instances

Prerequisites:
1) two frp server instances on gcp cluster (?which resources)
2) two router instances defining on which frps instance to route request
3) redis containing the mapping from frpc subdomain to frps instance
4) 3000 tunnels run on local machine (all connected to server)

Summarizing these results we can see that amount of tunnels connected to one frps replica does not really matter
when it's in so low number range (1500 or 3000 does not matter). However, having two servers with two routers and 
a redis instance adds some latency to the request (sometimes even higher than expected).

Seems like this is because of the multiple network operations that need to be done 
before request comes to the client: router -> redis -> frps -> frpc.


#### 10 users

```
single (~6 req/sec):
     http_req_duration..............: avg=270.08ms min=237.93ms med=243.7ms  max=481.58ms p(90)=377.68ms p(95)=404.65ms
multiple (~6 req/sec):
     http_req_duration..............: avg=262.91ms min=243.14ms med=248.17ms max=534.16ms p(90)=281.7ms  p(95)=377.2ms 
```


#### 100 users

```
single (~60 req/sec):
     http_req_duration..............: avg=285.91ms min=246.79ms med=256.82ms max=737.97ms p(90)=381.46ms p(95)=455.45ms
multiple (~60 req/sec):
     http_req_duration..............: avg=285.72ms min=242.84ms med=255.43ms max=717ms    p(90)=393.88ms p(95)=481.21ms
```


#### 200 users

```
single (~120 req/sec):
     http_req_duration..............: avg=320.45ms min=246.3ms  med=273.83ms max=756.44ms p(90)=466.24ms p(95)=509.54ms
multiple (~110 req/sec):
     http_req_duration..............: avg=379.31ms min=243.19ms med=329.65ms max=1.55s    p(90)=540.14ms p(95)=671.85ms
```


#### 300 users

```
single (~180 req/sec):
     http_req_duration..............: avg=318.07ms min=247.15ms med=271.37ms max=1.14s   p(90)=456.77ms p(95)=547.66ms
multiple (~160 req/sec):
     http_req_duration..............: avg=406.69ms min=244.09ms med=345.66ms max=2.06s    p(90)=601.6ms  p(95)=746.86ms
```


#### 400 users

```
single (~240 req/sec):
     http_req_duration..............: avg=337.98ms min=247.04ms med=290.56ms max=1.73s    p(90)=452.71ms p(95)=587.6ms 
multiple (~220 req/sec):
     http_req_duration..............: avg=393.52ms min=243.76ms med=313.24ms max=4.5s     p(90)=596.92ms p(95)=793.91ms
```


#### 500 users

```
single (~230 req/sec):
     http_req_duration..............: avg=384.27ms min=247.95ms med=306.41ms max=14.95s   p(90)=558.76ms p(95)=740.68ms
multiple (~240 req/sec):
     http_req_duration..............: avg=477.06ms min=244.61ms med=367.04ms max=12.02s p(90)=590.02ms p(95)=782.6ms 
```


#### 600 users

```
single (~260 req/sec):
     http_req_duration..............: avg=494.2ms  min=247.65ms med=402.66ms max=16.2s   p(90)=737.24ms p(95)=981.17ms
multiple (~250 req/sec):
     http_req_duration..............: avg=532.43ms min=245.69ms med=424.66ms max=12.83s   p(90)=823.59ms p(95)=1.27s   
```
