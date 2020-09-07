kind delete cluster || true
kind create cluster --config /conf/kind-cluster-conf.yaml

# solution from https://github.com/kubernetes-sigs/kind/issues/111
kind get kubeconfig --internal > /root/.kube/config
KIND_DOMAIN=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
kubectl config set clusters.kind.server $KIND_DOMAIN

kubectl cluster-info

kubectl get nodes
echo "Showing storageClass"
kubectl get storageclass
echo "Showing kube-system pods"
kubectl get -n kube-system pods

# setup dashboard
kubectl apply -f /conf/dashboard.yaml

# deploy metric server
kubectl apply -f /conf/kind-metrics-server.yaml

kubectl create serviceaccount cluster-admin-dashboard-sa

# Bind ClusterAdmin role to the service account
kubectl create clusterrolebinding cluster-admin-dashboard-sa \
  --clusterrole=cluster-admin \
  --serviceaccount=default:cluster-admin-dashboard-sa

# Parse the token
TOKEN=$(kubectl describe secret $(kubectl -n kube-system get secret | awk '/^cluster-admin-dashboard-sa-token-/{print $1}') | awk '$1=="token:"{print $2}')
echo $TOKEN

# expose the port of k8s dashboard
kubectl -n kubernetes-dashboard proxy --address 0.0.0.0 &

echo "kind cluster created, sleep infinity"
# sleep infinity, keep the process hangs here
sleep infinity;
