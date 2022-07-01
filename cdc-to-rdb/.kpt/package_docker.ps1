#CODER BY xiaoyao9184 1.0
#TIME 2022-06-30

Function Export-Docker() {
    $kpt_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        $script_dir + "/../../")

    Set-Location -Path $kpt_path
    $env:DOCKER_BUILDKIT = "1"
    if ($IsWindows) {
        # docker buildx create --use --name larger_log --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=50000000
        # docker buildx build -t xiaoyao9184/kpt-cdc-to-rdb:dev -f ./cdc-to-rdb/Dockerfile .
        docker build -t xiaoyao9184/kpt-cdc-to-rdb:dev -f ./cdc-to-rdb/Dockerfile . 
    } else {
        docker build -t xiaoyao9184/kpt-cdc-to-rdb:dev -f ./cdc-to-rdb/Dockerfile . 
    }
    Set-Location -Path $script_dir
}


$script_dir = Split-Path -parent $MyInvocation.MyCommand.Definition
#Run alone by default
$CallStack = Get-PSCallStack | Where-Object  {$_.Command -ne "<ScriptBlock>"}
if($CallStack.Count -eq 1){
    Export-Docker 
    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}