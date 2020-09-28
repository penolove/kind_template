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

[Argo UI](http://localhost:2746/) is here and you can skip the auth by click skip button.

and you can upload the hello-word.yaml to the UI

## there are some issue with the worker executor

https://argoproj.github.io/argo/workflow-executors/

TODO: figure it out

https://github.com/argoproj/argo/issues/2376

```bash
wget https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml 

# and add following into workflow-controller-configmap
# data:
#   config: |
#     containerRuntimeExecutor: k8sapi
```