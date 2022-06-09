function MoveDir {
    param (
        [Parameter(Mandatory=$true)][string]$dirPath,
        [Parameter(Mandatory=$true)][string]$newDirPath,

        [string]$to
    )
    $cLocation = Get-Location

    Copy-Item -Path $dirPath -Destination $newDirPath -Recurse -Force

    if($?)
    {
        Write-Host "Command Succeeded"
        
        $to = read-host -Prompt "To"
        $subject = "Command Succeeded"
        $body = "The directory was successfully copied from   $dirPath   to   $newDirPath"

        $mail = (Get-Content -Path "$cLocation\credentials.txt")[0]
        $pass = (Get-Content -Path "$cLocation\credentials.txt")[1] | ConvertTo-SecureString -AsPlainText -Force

        $emailForm = @{
            from = $mail
            to = $to
            subject = $subject
            smtpserver = "smtp.gmail.com"
            body = $body
            credential = New-Object System.Management.Automation.PSCredential -ArgumentList $mail, $pass
            usessl = $true
            verbose = $true
        }

        Send-MailMessage @emailForm
    }
    else
    {
        $Erro = Get-Error
        Write-Host "Command Failed"

        $to = read-host -Prompt "To"
        $subject = "Command Failed"
        $body = "The directory was not successfully copied from   $dirPath   to   $newDirPath `r`n$Erro"
            

        $mail = (Get-Content -Path "$cLocation\credentials.txt")[0]
        $pass = (Get-Content -Path "$cLocation\credentials.txt")[1] | ConvertTo-SecureString -AsPlainText -Force

        $emailForm = @{
            from = $mail
            to = $to
            subject = $subject
            smtpserver = "smtp.gmail.com"
            body = $body
            credential = New-Object System.Management.Automation.PSCredential -ArgumentList $mail, $pass
            usessl = $true
            verbose = $true
        }

        Send-MailMessage @emailForm
    }
}

function GetSysInf {
    $cLocation = Get-Location

    $SysInf = {
        "-----------------------------------------------------------------------------------------------------------"
        "Command --> Get-ComputerInfo"
        "-----------------------------------------------------------------------------------------------------------`r`n"
        Get-ComputerInfo
        "`r`n`r`n-----------------------------------------------------------------------------------------------------------"
        "Command --> Get-CimInstance -ClassName Win32_LogicalDisk '-Filter DriveType=3'"
        "-----------------------------------------------------------------------------------------------------------`r`n"
        Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
        "`r`n`r`n-----------------------------------------------------------------------------------------------------------"
        "Command --> Get-CimInstance -ClassName Win32_LocalTime"
        "-----------------------------------------------------------------------------------------------------------`r`n"
        Get-CimInstance -ClassName Win32_LocalTime
        "`r`n`r`n-----------------------------------------------------------------------------------------------------------"
        "Command --> Get-LocalUser | Select-Object *"
        "-----------------------------------------------------------------------------------------------------------`r`n"
        Get-LocalUser | Select-Object *
        "`r`n`r`n-----------------------------------------------------------------------------------------------------------"
        "Command --> Get-Counter -ListSet *"
        "-----------------------------------------------------------------------------------------------------------`r`n"
        Get-Counter -ListSet *
<#      "`r`n`r`n-----------------------------------------------------------------------------------------------------------"
        "-----------------------------------------------------------------------------------------------------------"
        "Command --> tree c:\ /a"
        "-----------------------------------------------------------------------------------------------------------`r`n"
        tree C:\ /a
#>
        #Nota: caso deseje ver o comando "tree" no ficheiro, tire o codigo de cima de comentario
    }
    
    if(-not(Test-Path -Path "$cLocation\SysInf.txt")){
        New-Item "$cLocation\SysInf.txt" -ItemType File

        & $SysInf | Out-File -FilePath "$cLocation\SysInf.txt" -Encoding utf8 
    }
    else {
        & $SysInf | Out-File -FilePath "$cLocation\SysInf.txt" -Encoding utf8 
    }
}

function ScheduleTask {
    $cLocation = Get-Location
    
    $taskName = "ScriptPS"
    $taskAction = (New-ScheduledTaskAction -Execute "C:\Program Files\PowerShell\7\pwsh.exe" -Argument "-file .\scriptPS.ps1 MoveDir" -WorkingDirectory "$cLocation"),
                  (New-ScheduledTaskAction -Execute "C:\Program Files\PowerShell\7\pwsh.exe" -Argument "-file .\scriptPS.ps1 GetSysInf" -WorkingDirectory "$cLocation")
    $taskTrigger = New-ScheduledTaskTrigger -Daily -At 1PM <# <-Altere aqui caso queira agendar para outra hora#>
    $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    
    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $taskAction `
        -Trigger $taskTrigger `
        -Settings $settings `
        -Force
}

function testing {
    Start-ScheduledTask -TaskName ScriptPS
}

$cmd = $args
& $cmd 