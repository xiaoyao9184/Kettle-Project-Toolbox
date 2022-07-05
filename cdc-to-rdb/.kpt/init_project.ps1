#CODER BY xiaoyao9184 1.0
#TIME 2022-06-30


Function Initialize-Project() {
    $copy_item_list = Import-Csv -Path "$script_dir/$script_name.csv" -Delimiter ";" | Where-Object {
        $_.type -eq "copy"
    } | ForEach-Object {
        if ($IsWindows) {
            $_.path -replace '/','\'
        } else {
            $_.path
        }
    }
    $link_item_list = Import-Csv -Path "$script_dir/$script_name.csv" -Delimiter ";" | Where-Object {
        $_.type -eq "link"
    } | ForEach-Object {
        if ($IsWindows) {
            $_.path -replace '/','\'
        } else {
            $_.path
        }
    } 

    $kpt_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        $script_dir + "/../../")
    $project_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        $script_dir + "/../")
    $project_name = Split-Path -Leaf $project_path
    $tar_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        $kpt_path + "/$project_name")
    
    $env:kpt_project_name = "$project_name"
    $env:target_project_path = "$tar_path"
    $env:copy_item_name_list = $copy_item_list -join ";" 
    $env:link_item_name_list = $link_item_list -join ";"
    
    if ($IsWindows) {
        $bat_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
            $kpt_path + "/tool/link_project.bat")
        Start-Process "$bat_path" 
        # -Verb RunAs
    } else {
        $sh_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
            $kpt_path + "/tool/link_project.sh")
        Start-Process "$sh_path" 
        # -Verb RunAs
    }
}


$script_dir = Split-Path -parent $MyInvocation.MyCommand.Definition
$script_name = Split-Path -LeafBase $MyInvocation.MyCommand.Definition
#Run alone by default
$CallStack = Get-PSCallStack | Where-Object  {$_.Command -ne "<ScriptBlock>"}
if($CallStack.Count -eq 1){
    Initialize-Project 
    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}