# kind_template

in this repo, I propose to launch a `kubeflow` with the support of kind (kubernetes in docker)

and you can fork this repo for your own application which require a minimum k8s env for developer

## Prerequisite

- docker
- docker-compose

## start kind cluster and launch kubeflow

in order to make sure you can reproduce the result as mine, I would using another container to wrapper kind

```bash
# notice that, this will pull lots of images which might consume up to 20G disk, and will taking very long time to fetch images and start service(up to your network env)
# and will occupy port 80 and port 8001
docker-compose up  # -d
docker-compose down  # shutdown service, notice that the fetched images will also be removed.
```

[K8s Dashboard](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login) the deployment is really a long long time, you can check the pod status with the k8s dashboard.
[Kubeflow UI](http://localhost) once all the service is ready, this page were used to manipulate with kubeflow.
