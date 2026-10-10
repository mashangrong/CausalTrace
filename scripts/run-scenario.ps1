# 一键复现实验场景：部署拓扑 -> 启动压测 -> 按时间线注入故障 -> 采集落盘 datasets/
# 用法: powershell -File scripts/run-scenario.ps1 -Scenario <scenario-name> [-RunId <id>]
param(
    [Parameter(Mandatory = $true)]
    [string]$Scenario,

    [string]$RunId = (Get-Date -Format "yyyyMMdd-HHmmss")
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$dir = "$root/scenarios/$Scenario"

if (-not (Test-Path "$dir/scenario.yaml")) {
    Write-Error "场景不存在或缺少 scenario.yaml: $dir"
}

Write-Host "==> 运行场景: $Scenario (run-id: $RunId)"
Write-Host "    场景定义: $dir/scenario.yaml"
Write-Host "    数据落盘: $root/datasets/$Scenario/$RunId/"

# TODO: 解析 scenario.yaml 并编排执行：
#   1. kubectl apply -k deploy/k8s/overlays/<topology.overlay>
#   2. 启动 workload/ 下的压测（locust / k6）
#   3. 按 faults 时间线 kubectl apply chaos/ 下的 Chaos Mesh 清单，到时删除以恢复
#   4. 调用 collector/exporters 将 trace/metric/log 导出到 datasets/$Scenario/$RunId/

New-Item -ItemType Directory -Force -Path "$root/datasets/$Scenario/$RunId" | Out-Null
Write-Host "==> 骨架已就绪，编排逻辑待按实验需求实现"
