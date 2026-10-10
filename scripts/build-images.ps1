# 构建 services/ 下所有自有服务镜像并加载进 kind 集群
# 用法: powershell -File scripts/build-images.ps1 [-Tag dev] [-ClusterName causaltrace]
param(
    [string]$Tag = "dev",
    [string]$ClusterName = "causaltrace"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Get-ChildItem "$root/services" -Directory | ForEach-Object {
    $name = $_.Name
    $image = "causaltrace/${name}:$Tag"
    Write-Host "==> 构建 $image"
    docker build -t $image $_.FullName
    Write-Host "==> 加载 $image 到 kind 集群 $ClusterName"
    kind load docker-image $image --name $ClusterName
}

Write-Host "==> 完成"
