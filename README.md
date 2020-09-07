# kind_template

in this repo, I propose to launch a < application > with the support of kind (kubernetes in docker)

and you can fork this repo for your own application which require a minimum k8s env for developer

## Prerequisite

- docker
- docker-compose

## start kind cluster

in order to make sure you can reproduce the result as mine, I would using another container to wrapper kind

```bash
docker-compose up  # -d
docker-compose down  # shutdown service
```

[K8s Dashboard](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login) is here and you can skip the auth by click skip button.
[Jenkins Dashboard](http://127.0.0.1:8080) the UI password can be find in the docker-compose up logs like

```bash
account admin with password: gqlA6TtrqN
```

or execute in the container `kind-agent`

```bash
# get into container
docker-compose exec kind-agent /bin/bash 

# inside container
$(kubectl get secret --namespace default jenkins-on-kind -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode)
```
