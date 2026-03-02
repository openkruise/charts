# Agents Sandbox Controller v0.1.0

## 配置参数

下表列出了 agents-sandbox-controller chart 的可配置参数及其默认值。

| 参数                                                | 描述                                                               | 默认值                                                                                             |
|-----------------------------------------------------|--------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| `sandboxController.replicaCount`                    | sandbox-controller 部署的副本数                                    | `3`                                                                                             |
| `sandboxController.image.repository`                | sandbox-controller 镜像仓库                                        | `openkruise/agent-sandbox-controller`                                                          |
| `sandboxController.image.tag`                       | sandbox-controller 镜像标签                                        | `v0.1.0`                                                                                        |
| `sandboxController.image.pullPolicy`                | 控制器的镜像拉取策略                                               | `IfNotPresent`                                                                                  |
| `sandboxController.webhook.port`                    | Webhook 服务端口                                                   | `9443`                                                                                          |
| `sandboxController.metrics.port`                    | Metrics 服务端口                                                   | `8443`                                                                                          |
| `sandboxController.healthProbe.port`                | 健康探针端口                                                       | `8081`                                                                                          |
| `sandboxController.resources.limits.cpu`            | 控制器容器的 CPU 资源限制                                          | `2`                                                                                             |
| `sandboxController.resources.limits.memory`         | 控制器容器的内存资源限制                                           | `4Gi`                                                                                           |
| `sandboxController.resources.requests.cpu`          | 控制器容器的 CPU 资源请求                                          | `2`                                                                                             |
| `sandboxController.resources.requests.memory`       | 控制器容器的内存资源请求                                           | `4Gi`                                                                                           |
| `namespace.create`                                  | 是否创建命名空间                                                   | `true`                                                                                          |
| `namespace.name`                                    | 部署的命名空间名称                                                 | `sandbox-system`                                                                                |
| `crds.enabled`                                      | 是否启用 CRD 管理                                                  | `true`                                                                                          |
| `serviceAccount.create`                             | 是否创建 ServiceAccount                                            | `true`                                                                                          |
| `serviceAccount.automount`                          | 是否自动挂载 ServiceAccount Token                                  | `true`                                                                                          |
| `serviceAccount.annotations`                        | ServiceAccount 注解                                                | `{}`                                                                                            |
| `serviceAccount.name`                               | 使用的 ServiceAccount 名称                                         | `""`                                                                                            |
| `rbac.create`                                       | 是否创建 RBAC 资源                                                 | `true`                                                                                          |
| `imagePullSecrets`                                  | 镜像拉取密钥列表                                                   | `[]`                                                                                            |
| `nameOverride`                                      | 覆盖 Chart 名称                                                    | `""`                                                                                            |
| `fullnameOverride`                                  | 覆盖完整名称                                                       | `""`                                                                                            |
| `podAnnotations`                                    | Pod 注解                                                           | `{}`                                                                                            |
| `podLabels`                                         | Pod 标签                                                           | `{}`                                                                                            |
| `podSecurityContext`                                | Pod 安全上下文                                                     | `{runAsNonRoot: true, seccompProfile: {type: RuntimeDefault}}`                                  |
| `securityContext`                                   | 容器安全上下文                                                     | `{allowPrivilegeEscalation: false, capabilities: {drop: [ALL]}, readOnlyRootFilesystem: false}` |
| `nodeSelector`                                      | Pod 调度的节点选择器                                               | `{}`                                                                                            |
| `tolerations`                                       | Pod 调度的容忍配置                                                 | `[]`                                                                                            |
| `affinity`                                          | Pod 调度的亲和性配置                                               | `{}`                                                                                            |

使用 `--set key=value[,key=value]` 参数来指定每个参数。例如：

```bash
helm install agents-sandbox-controller . -n <namespace> openkruise/kruise-agents-sandbox-controller --set key=value...
```
