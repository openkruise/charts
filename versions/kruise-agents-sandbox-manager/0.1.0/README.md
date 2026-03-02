# Agent Sandbox Manager v0.1.0

## 配置参数

下表列出了 agents-sandbox-manager chart 的可配置参数及其默认值。

| 参数                                                    | 描述                                                           | 默认值                                  |
|-------------------------------------------------------|----------------------------------------------------------------|-----------------------------------------|
| `sandboxManager.replicaCount`                         | sandbox-manager 部署的副本数                                   | `3`                                     |
| `sandboxManager.controller.repository`                | sandbox-manager 控制器镜像仓库                                 | `openkruise/sandbox-manager` |
| `sandboxManager.controller.tag`                       | sandbox-manager 控制器镜像标签                                 | `v0.1.0`                                |
| `sandboxManager.controller.pullPolicy`                | 控制器容器的镜像拉取策略                                          | `IfNotPresent`                          |
| `sandboxManager.controller.logLevel`                  | 控制器日志级别                                                 | `3`                                     |
| `sandboxManager.controller.infra`                     | 沙箱管理器的基础设施类型                                          | `sandbox-cr`                            |
| `sandboxManager.controller.hostNetwork`               | 控制器是否使用主机网络                                           | `false`                                 |
| `sandboxManager.controller.maxClaimWorkers`           | 最大声明工作线程数                                             | `100`                                   |
| `sandboxManager.controller.maxCreateQPS`              | 创建沙箱的最大 QPS                                             | `200`                                   |
| `sandboxManager.controller.extProcMaxConcurrency`     | 外部处理器的最大并发数                                           | `3000`                                  |
| `sandboxManager.controller.resources.limits.cpu`      | 控制器容器的 CPU 资源限制                                       | `2`                                     |
| `sandboxManager.controller.resources.limits.memory`   | 控制器容器的内存资源限制                                          | `4Gi`                                   |
| `sandboxManager.controller.resources.requests.cpu`    | 控制器容器的 CPU 资源请求                                       | `2`                                     |
| `sandboxManager.controller.resources.requests.memory` | 控制器容器的内存资源请求                                          | `4Gi`                                   |
| `sandboxManager.proxy.repository`                     | Envoy 代理镜像仓库                                             | `envoyproxy/envoy`                      |
| `sandboxManager.proxy.tag`                            | Envoy 代理镜像标签                                             | `v1.33-latest`                               |
| `sandboxManager.proxy.pullPolicy`                     | Envoy 代理容器的镜像拉取策略                                     | `IfNotPresent`                          |
| `sandboxManager.proxy.resources.cpu`                  | Envoy 代理容器的 CPU 资源                                    | `2`                                     |
| `sandboxManager.proxy.resources.memory`               | Envoy 代理容器的内存资源                                       | `4Gi`                                   |
| `sandboxManager.e2b.domain`                           | E2B 协议域名                                                   | `your.domain.com`                       |
| `sandboxManager.e2b.enableAuth`                       | 是否启用 E2B 认证                                              | `true`                                  |
| `sandboxManager.e2b.adminApiKey`                      | E2B 管理员 API 密钥                                            | `admin-987654321`                       |
| `sandboxManager.e2b.maxTimeout`                       | E2B 最大超时时间（秒）                                         | `2592000`                               |
| `sandboxManager.service.type`                         | sandbox-manager 服务类型                                       | `ClusterIP`                             |
| `sandboxManager.service.port`                         | Envoy 代理服务端口                                             | `7788`                                  |
| `sandboxManager.ingress.className`                    | Ingress 类名                                                   | `nginx`                                 |
| `sandboxManager.ingress.annotations`                  | Ingress 注解                                                   | `{}`                                    |
| `sandboxManager.ingress.certSecretName`               | Ingress TLS 证书 Secret 名称                                   | `sandbox-manager-tls`                   |
| `imagePullSecrets`                                    | 镜像拉取密钥列表                                               | `{}`                                    |
| `nameOverride`                                        | 覆盖 Chart 名称                                                | `""`                                    |
| `fullnameOverride`                                    | 覆盖完整名称                                                   | `""`                                    |
| `serviceAccount.automount`                            | 是否自动挂载 ServiceAccount Token                              | `true`                                  |
| `serviceAccount.annotations`                          | ServiceAccount 注解                                            | `{}`                                    |
| `serviceAccount.name`                                 | 使用的 ServiceAccount 名称                                     | `""`                                    |
| `podAnnotations`                                      | Pod 注解                                                       | `{}`                                    |
| `podLabels`                                           | Pod 标签                                                       | `{}`                                    |
| `podSecurityContext`                                  | Pod 安全上下文                                                 | `{fsGroup: 2000, allowPrivilegeEscalation: false, seccompProfile: {type: RuntimeDefault}}` |
| `securityContext`                                     | 容器安全上下文                                                 | `{capabilities: {drop: [ALL]}, readOnlyRootFilesystem: true, allowPrivilegeEscalation: false, runAsNonRoot: true, runAsUser: 65532}` |
| `nodeSelector`                                        | Pod 调度的节点选择器                                           | `{}`                                    |
| `tolerations`                                         | Pod 调度的容忍配置                                             | `[]`                                    |
| `affinity`                                            | Pod 调度的亲和性配置                                           | 首选 Pod 反亲和性                       |

```bash
helm install agents-sandbox-manager . -n <namespace> openkruise/kruise-agents-sandbox-manager --set key=value...
```
