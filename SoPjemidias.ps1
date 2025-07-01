# Instalação do PJE MIDIAS 1.4.0 (Windows 64 bits)

# Verifica se o script está em modo administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Reexecutando como administrador..."
    $CommandLine = "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell -Verb runAs -ArgumentList $CommandLine
    exit
}

function Write-Log {
    param([string]$msg)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $log = "[$timestamp] $msg"
    Write-Host $log
    $log | Out-File -FilePath "$env:TEMP\PJE_MIDIAS_Install.log" -Append -Encoding UTF8
}

function Install-PJEMidias {
    $url = "https://midias.pje.jus.br/midias/web/controle-versao/download?versao=1.4.0&tip_sistema_operacional=WIN64"
    $dest = "$env:TEMP\ad-1.4.0.x64.exe"

    try {
        if (-not (Test-Path $dest)) {
            Write-Log "Baixando instalador do PJE MIDIAS..."
            Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
            Write-Log "Download concluído: $dest"
        } else {
            Write-Log "Instalador já existe: $dest"
        }

        if (Test-Path $dest) {
            Write-Log "Executando instalador do PJE MIDIAS..."
            Start-Process -FilePath $dest -Wait -WindowStyle Hidden
            Write-Log "Instalação concluída."
        } else {
            Write-Log "Erro: Instalador não encontrado em $dest"
        }
    } catch {
        Write-Log "Erro durante instalação: $($_.Exception.Message)"
    }
}

# Execução
Write-Log "=== INÍCIO DA INSTALAÇÃO DO PJE MIDIAS ==="
Install-PJEMidias
Write-Log "=== FIM DA INSTALAÇÃO ==="

Read-Host "Pressione Enter para sair"
