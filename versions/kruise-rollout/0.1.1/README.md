# Kruise Rollout v0.1.1

## Configuration

The following table lists the configurable parameters of the kruise chart and their default values.

| Parameter                        | Description                                                      | Default                             |
|----------------------------------|------------------------------------------------------------------|-------------------------------------|
| `installation.namespace`         | Namespace for kruise-rollout operation installation              | `kruise-rollout`                    |
| `installation.createNamespace`   | Whether to create the installation.namespace                     | `true`                              |
| `rollout.fullname`               | Nick name for kruise-rollout deployment and other configurations | `kruise-rollout-controller-manager` |
| `rollout.healthBindPort`         | Port for checking health of kruise-rollout container             | `8081`                              |
| `rollout.metricsBindAddr`        | Port of metrics served by kruise-rollout container               | `127.0.0.1:8080`                    |
| `rollout.log.level`              | Log level that kruise-rollout printed                            | `3`                                 |
| `rollout.webhook.port`           | Port of webhook served by kruise-rollout container               | `9876`                              |
| `image.repository`               | Repository for kruise-rollout image                              | `openkruise/kruise-rollout`         |
| `image.tag`                      | Tag for kruise-rollout image                                     | `v0.1.1`                            |
| `image.pullPolicy`               | ImagePullPolicy for kruise-rollout container                     | `Always`                            |
| `imagePullSecrets`               | The list of image pull secrets for kruise-rollout image          | ` `                                 |
| `resources.limits.cpu`           | CPU resource limit of kruise-rollout container                   | `500m`                              |
| `resources.limits.memory`        | Memory resource limit of kruise-rollout container                | `1Gi`                               |
| `resources.requests.cpu`         | CPU resource request of kruise-rollout container                 | `100m`                              |
| `resources.requests.memory`      | Memory resource request of kruise-rollout container              | `256Mi`                             |
| `replicaCount`                   | Replicas of kruise-rollout deployment                            | `2`                                 |
| `service.port`                   | Port of webhook served by kruise-rollout webhook service         | `443`                               |
| `serviceAccount.annotations`     | The annotations for serviceAccount of kruise-rollout             | ` `                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

### Optional: the local image for China

If you are in China and have problem to pull image from official DockerHub, you can use the registry hosted on Alibaba Cloud:

```bash
$ helm install kruise https://... --set image.repository=openkruise-registry.cn-shanghai.cr.aliyuncs.com/openkruise/kruise-rollout
...
```
