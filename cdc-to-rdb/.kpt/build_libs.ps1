#CODER BY xiaoyao9184 1.0
#TIME 2022-06-30


Function Export-Lib($lib_path,$build_path) {
    $kpt_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        $script_dir + "/../../")
    $lib_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        $kpt_path + "/cdc-to-rdb/$lib_path")

    Set-Location -Path $lib_path    
    mvn clean package "-Dmaven.test.skip=true"
    Set-Location -Path $script_dir

    $build_name = Split-Path -Leaf "$lib_path/$build_path"
    Remove-Item "$script_dir/lib/$build_name" -Force -Recurse
    Copy-Item "$lib_path/$build_path" `
        "$script_dir/lib/$build_name" -Recurse
}

Function Export-Libs() {
    Import-Csv -Path "$script_dir/$script_name.csv" -Delimiter ";" | ForEach {
        Export-Lib $_.lib_path $_.build_path
    }
}


$script_dir = Split-Path -parent $MyInvocation.MyCommand.Definition
$script_name = Split-Path -LeafBase $MyInvocation.MyCommand.Definition
#Run alone by default
$CallStack = Get-PSCallStack | Where-Object  {$_.Command -ne "<ScriptBlock>"}
if($CallStack.Count -eq 1){
    Export-Libs 
    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}