
<powershell>

$ErrorActionPreference = "Stop"

Start-Transcript -Path "C:\Windows\Temp\cloudops-deployment.log" -Append

try {
    # 1. Install IIS
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools

    # 2. Install AWS CLI
    $awsInstaller = "$env:TEMP\AWSCLIV2.msi"

    Invoke-WebRequest `
        -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" `
        -OutFile $awsInstaller

    Start-Process msiexec.exe `
        -ArgumentList "/i `"$awsInstaller`" /qn /norestart" `
        -Wait

    $awsExe = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

    if (!(Test-Path $awsExe)) {
        throw "AWS CLI installation failed"
    }

    # 3. Install .NET 10 Hosting Bundle
    $hostingBundle = "$env:TEMP\dotnet-hosting.exe"

    Invoke-WebRequest `
        -Uri "https://aka.ms/dotnet/10.0/dotnet-hosting-win.exe" `
        -OutFile $hostingBundle

    $process = Start-Process $hostingBundle `
        -ArgumentList "/install /quiet /norestart" `
        -Wait -PassThru

    if ($process.ExitCode -notin @(0, 3010)) {
        throw ".NET Hosting Bundle installation failed"
    }

    # 4. Download application from S3
    $env:AWS_DEFAULT_REGION = "ap-southeast-2"

    $zipPath = "$env:TEMP\CloudOpsPortal.zip"

    & $awsExe s3 cp "s3://${artifact_bucket}/${artifact_key}" $zipPath

    if ($LASTEXITCODE -ne 0) {
        throw "Application download from S3 failed"
    }

    # 5. Extract application
    $appPath = "C:\inetpub\wwwroot\CloudOpsPortal"

    New-Item -ItemType Directory -Path $appPath -Force | Out-Null

    Expand-Archive -Path $zipPath -DestinationPath $appPath -Force

    if (!(Test-Path "$appPath\web.config")) {
        throw "web.config missing from published application"
    }

    # 6. Configure IIS
    Import-Module WebAdministration

    if (!(Test-Path "IIS:\AppPools\CloudOpsPool")) {
        New-WebAppPool -Name "CloudOpsPool"
    }

    Set-ItemProperty `
        "IIS:\AppPools\CloudOpsPool" `
        -Name managedRuntimeVersion `
        -Value ""

    if (Test-Path "IIS:\Sites\Default Web Site") {
        Remove-Website -Name "Default Web Site"
    }

    if (Test-Path "IIS:\Sites\CloudOpsPortal") {
        Remove-Website -Name "CloudOpsPortal"
    }

    New-Website `
        -Name "CloudOpsPortal" `
        -PhysicalPath $appPath `
        -Port 80 `
        -ApplicationPool "CloudOpsPool"

    # 7. Start website
    Start-Service W3SVC
    Start-WebSite -Name "CloudOpsPortal"

    Write-Output "CloudOps Portal IIS deployment completed"

}
catch {
    Write-Error $_
    throw
}
finally {
    Stop-Transcript
}

</powershell>
