# 创建 kind 本地集群并部署基础组件
# 用法: powershell -File scripts/setup-cluster.ps1 [-ClusterName causaltrace]
param(
    [string]$ClusterName = "causaltrace"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "==> 创建 kind 集群: $ClusterName"
kind create cluster --name $ClusterName --config "$root/deploy/kind/cluster.yaml"

Write-Host "==> 部署基础层与可观测性组件 (dev overlay)"
kubectl apply -k "$root/deploy/k8s/overlays/dev"

Write-Host "==> 完成。后续按需安装 Chaos Mesh: helm install chaos-mesh chaos-mesh/chaos-mesh -n chaos-mesh --create-namespace"
