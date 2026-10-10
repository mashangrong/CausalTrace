# CausalTrace

面向微服务系统的因果追踪与根因分析实验平台。基于 [train-ticket](https://github.com/FudanSELab/train-ticket) 微服务基准 + 自研/改造服务，支持故障注入场景复现、全链路可观测数据采集与因果分析算法实验（论文工程）。

## 目录结构

```text
third_party/train-ticket   # train-ticket 官方仓库（git submodule，固定 commit，保持原样）
services/                  # 自研/改造的微服务，一个服务一个目录（含 Dockerfile）
deploy/
  kind/                    # 本地 kind 集群配置
  k8s/
    base/                  # 命名空间 + 基础设施（MySQL/Mongo/RabbitMQ/Redis）
    train-ticket/          # 选用的 train-ticket 服务清单（按需启用）
    services/              # 自有服务清单
    observability/         # OTel Collector / Jaeger / Prometheus / Grafana / Loki
    overlays/              # dev（最小集）/ experiment（完整实验拓扑）
scenarios/                 # 实验场景：scenario.yaml + chaos/ 故障注入 + workload/ 压测
collector/                 # OTel pipeline 配置与数据导出
analysis/                  # 因果分析/RCA 算法（Python 包 + experiments + notebooks）
datasets/                  # 采集数据集（按 场景/运行批次 存放，不进 git）
scripts/                   # 建集群 / 构建镜像 / 部署 / 跑场景 的一键脚本（PowerShell）
docs/                      # 设计文档与实验记录
```

## 快速开始

前置依赖：`git`、`docker`、`kind`、`kubectl`（kustomize 已内置）、`helm`（装 Chaos Mesh 用）、Python 3.10+。

```powershell
# 1. 拉取代码（含子模块）
git clone --recursive https://github.com/mashangrong/CausalTrace.git
# 已克隆的仓库补拉子模块: git submodule update --init --recursive

# 若访问 github.com 受限，可配置镜像重写（仅影响本机，不改仓库记录）:
# git config --global url."https://gh-proxy.com/https://github.com/".insteadOf "https://github.com/"

# 2. 创建本地 k8s 集群并部署基础组件
powershell -File scripts/setup-cluster.ps1

# 3. 按需启用服务：编辑 deploy/k8s/train-ticket/kustomization.yaml，然后部署
powershell -File scripts/deploy.ps1 -Overlay dev

# 4. 构建并加载自研服务镜像
powershell -File scripts/build-images.ps1

# 5. 复现实验场景（编排逻辑按实验需求实现）
powershell -File scripts/run-scenario.ps1 -Scenario <scenario-name>
```

## 新增一个实验场景

复制 `scenarios/_template/` 为 `scenarios/<your-scenario>/`，填写 `scenario.yaml`（拓扑、流量、故障时间线），在 `chaos/` 放 Chaos Mesh 清单、`workload/` 放压测脚本。

## 新增/改造一个微服务

在 `services/<your-service>/` 放源码与 `Dockerfile`，README 里注明来源（自研 / 基于 train-ticket 某服务改造）与改动点；镜像用 `scripts/build-images.ps1` 构建，清单加入 `deploy/k8s/services/`。

## 说明

- train-ticket 以 submodule 固定在特定 commit，保证实验可复现；如需深度修改 train-ticket 本体，将 submodule 远端指向自己的 fork 即可。
- `datasets/` 内容不进 git，需要长期保存的数据集请另行归档。
