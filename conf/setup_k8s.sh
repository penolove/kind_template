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

helm repo add jenkinsci https://charts.jenkins.io
helm repo update

CHART=jenkinsci/jenkins
CHART_VERSION=2.6.2
helm install jenkins-on-kind $CHART \
    --version $CHART_VERSION \
    --namespace default

# wait util the ui of webserver ready, and port-forward ports
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/jenkins-on-kind"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
  $ROLLOUT_STATUS_CMD
  ATTEMPTS=$((attempts + 1))
  sleep 10
done
kubectl --namespace default port-forward deployment/jenkins-on-kind 8080:8080 --address 0.0.0.0 &

echo "account admin with password:" $(kubectl get secret --namespace default jenkins-on-kind -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode)

echo "kind cluster created, sleep infinity"
# sleep infinity, keep the process hangs here
sleep infinity;
