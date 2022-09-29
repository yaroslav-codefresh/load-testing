
# Load Testing

##### 1 user is 1 req/sec

### Summary

1) Difference between ingress and ingress-less is pretty small (from 2 ms to 100 ms)
2) Response time on ingress-less has a bit higher difference between min and max values then ingress 
(mostly because sometimes opening work connections can take more time)
3) 

## Ingress vs Ingress-less

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


## Single vs Multiple (2) instances

#### 100 users -- 400 tunnels

```
single:
     http_req_duration..............: avg=280.3ms  min=244.82ms med=247.18ms max=907.99ms p(90)=316.65ms p(95)=488.53ms
multiple:
     http_req_duration..............: avg=417.67ms min=236.44ms med=255.25ms max=5.54s    p(90)=431.64ms p(95)=477.52ms
```

#### 100 users -- 600 tunnels

```
single:
     http_req_duration..............: avg=366.23ms min=244.35ms med=255.19ms max=3.02s   p(90)=828.86ms p(95)=967.18ms
multiple:
     http_req_duration..............: avg=900.39ms min=0s       med=259.14ms max=51.2s   p(90)=982.5ms  p(95)=1.39s   
```

#### 500 users -- 400 tunnels

```
single:
     http_req_duration..............: avg=1.01s    min=0s       med=360.24ms max=20.23s  p(90)=2.06s    p(95)=3.6s    
multiple:
     http_req_duration..............: avg=1.08s    min=121.42ms med=331.67ms max=51.52s  p(90)=1.3s     p(95)=10.15s  
```

#### 500 users -- 600 tunnels

```
single:
     http_req_duration..............: avg=1.98s    min=0s       med=1.69s    max=11.5s   p(90)=4.39s    p(95)=5.17s   
multiple:
     http_req_duration..............: avg=1.89s    min=0s       med=1.25s    max=36.93s  p(90)=4.4s     p(95)=5.78s   
```

#### 1000 users -- 600 tunnels

```
single:
     http_req_duration..............: avg=3.88s    min=0s       med=3.03s    max=45.97s  p(90)=7.33s    p(95)=9.78s   
multiple:
     http_req_duration..............: avg=5.03s    min=0s       med=4.2s     max=51.53s  p(90)=10.03s   p(95)=13.46s  
```
