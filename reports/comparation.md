
# Load Testing

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
```
