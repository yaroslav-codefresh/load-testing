export K3D_FIX_DNS=1 && k3d cluster create stress3 --agents 3 -p 8083:80@loadbalancer
