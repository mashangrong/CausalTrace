# 按 overlay 一键部署
# 用法: powershell -File scripts/deploy.ps1 [-Overlay dev|experiment]
param(
    [ValidateSet("dev", "experiment")]
    [string]$Overlay = "dev"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "==> 部署 overlay: $Overlay"
kubectl apply -k "$root/deploy/k8s/overlays/$Overlay"

Write-Host "==> 当前 Pod 状态:"
kubectl get pods -n causaltrace
