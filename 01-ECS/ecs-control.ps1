param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('start', 'stop', 'reboot')]
    [string]$Action
)

$ErrorActionPreference = 'Stop'
$terraformAction = switch ($Action.ToLowerInvariant()) {
    'start'  { 'ON' }
    'stop'   { 'OFF' }
    'reboot' { 'REBOOT' }
}

$resourceAddress = 'huaweicloud_compute_instance.lab_ecs'
$planPath = Join-Path $PSScriptRoot 'ecs-control.tfplan'
Push-Location $PSScriptRoot
try {
    if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
        throw 'Terraform CLI tidak ditemukan di PATH.'
    }
    if (-not $env:TF_VAR_ecs_password) {
        throw 'TF_VAR_ecs_password belum tersedia pada sesi PowerShell ini. Set variabel tersebut secara aman sebelum melanjutkan.'
    }
    $state = @(terraform state list 2>&1)
    if ($LASTEXITCODE -ne 0) { throw "Gagal membaca Terraform state: $($state -join ' ')" }
    if ($state -notcontains $resourceAddress) {
        throw "ECS tidak ditemukan dalam Terraform state: $resourceAddress. Jangan jalankan script sebelum ECS berhasil dibuat."
    }

    Write-Host "Menyusun plan untuk $Action ($terraformAction)..." -ForegroundColor Cyan
    & terraform plan -input=false -out="$planPath" "-var=ecs_power_action=$terraformAction"
    if ($LASTEXITCODE -ne 0) { throw 'terraform plan gagal.' }

    $jsonText = (& terraform show -json "$planPath") -join "`n"
    if ($LASTEXITCODE -ne 0) { throw 'Tidak dapat membaca JSON Terraform plan.' }
    $plan = $jsonText | ConvertFrom-Json
    $changes = @($plan.resource_changes | Where-Object {
        $_.change.actions -contains 'create' -or
        $_.change.actions -contains 'update' -or
        $_.change.actions -contains 'delete'
    })
    if ($changes.Count -eq 0) {
        Write-Host 'Tidak ada perubahan yang direncanakan. Terraform mungkin tidak akan mengirim aksi power lagi.' -ForegroundColor Yellow
        return
    }
    $unsafe = @($changes | Where-Object {
        $_.address -ne $resourceAddress -or
        $_.change.actions.Count -ne 1 -or
        $_.change.actions[0] -ne 'update'
    })
    if ($unsafe.Count -gt 0) {
        Write-Warning 'Plan mengandung pembuatan, penghapusan, replacement, atau perubahan resource lain. Apply dibatalkan.'
        return
    }
    $ecsChange = $changes[0]
    if ($ecsChange.change.after.power_action -ne $terraformAction) {
        Write-Warning 'Plan tidak menunjukkan power_action yang diminta. Apply dibatalkan.'
        return
    }

    $answer = Read-Host "Ketik YES untuk menjalankan '$Action' pada $resourceAddress"
    if ($answer -cne 'YES') {
        Write-Host 'Dibatalkan.'
        return
    }
    & terraform apply -input=false "$planPath"
    if ($LASTEXITCODE -ne 0) { throw 'terraform apply gagal. Periksa status ECS di Huawei Cloud Console.' }
    Write-Host "Perintah $Action telah diproses oleh Terraform. Verifikasi status ECS di Huawei Cloud Console." -ForegroundColor Green
}
finally {
    if (Test-Path $planPath) { Remove-Item $planPath -Force }
    Pop-Location
}
