# Kruise Game v0.2.1

## Configuration

The following table lists the configurable parameters of the kruise-game chart and their default values.

| Parameter                        | Description                                                       | Default                             |
|----------------------------------|-------------------------------------------------------------------|-------------------------------------|
| `installation.namespace`         | Namespace for kruise-game operation installation                  | `kruise-game-system`                |
| `installation.createNamespace`   | Whether to create the installation.namespace                      | `true`                              |
| `rollout.fullname`               | Nick name for kruise-game deployment and other configurations     | `kruise-game-controller-manager`    |
| `rollout.healthBindPort`         | Port for checking health of kruise-game container                 | `8082`                              |
| `rollout.webhook.port`           | Port of webhook served by kruise-game container                   | `443`                               |
| `rollout.webhook.targetPort`     | ObjectSelector for workloads in MutatingWebhookConfigurations     | `9876`                              |
| `replicaCount`                   | Replicas of kruise-game deployment                                | `1`                                 |
| `image.repository`               | Repository for kruise-game image                                  | `openkruise/kruise-game-manager`    |
| `image.tag`                      | Tag for kruise-game image                                         | `v0.2.1`                            |
| `image.pullPolicy`               | ImagePullPolicy for kruise-game container                         | `Always`                            |
| `serviceAccount.annotations`     | The annotations for serviceAccount of kruise-game                 | ` `                                 |
| `service.port`                   | Port of kruise-game service                                       | `8443`                              |
| `resources.limits.cpu`           | CPU resource limit of kruise-game container                       | `500m`                              |
| `resources.limits.memory`        | Memory resource limit of kruise-game container                    | `1Gi`                               |
| `resources.requests.cpu`         | CPU resource request of kruise-game container                     | `10m`                               |
| `resources.requests.memory`      | Memory resource request of kruise-game container                  | `64Mi`                              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

### Optional: the local image for China

If you are in China and have problem to pull image from official DockerHub, you can use the registry hosted on Alibaba Cloud:

```bash
$ helm install kruise-game https://... --set image.repository=registry.cn-hangzhou.aliyuncs.com/acs/kruise-game-manager:v0.2.1
...
```
