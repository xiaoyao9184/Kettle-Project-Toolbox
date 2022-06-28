#CODER BY xiaoyao9184 1.0
#TIME 2022-06-28
#Requires -RunAsAdministrator

Function Get-JarNameAndVersionByFilename($filename) {
    $name = $filename -replace '-[0-9].*'
    $version = $filename -replace "$name-"
    $version = $version -replace ".jar"
    
    return $name, $version
}

Function Install-Libs($source_dir,$target_dir) {
    $lib_paths = Get-ChildItem $source_dir -File -Recurse | Where-Object {
        $_.extension -like ".jar"
    }
    foreach ($lib_path in $lib_paths) {
        $filename = $lib_path.Name
        $name, $version = Get-JarNameAndVersionByFilename $filename
        $lib_conflict = ""
        $lib_conflict = Get-ChildItem $target_dir -File -Recurse | Where-Object {
            $_.name -like "$name-[0-9].*jar"
        }
        if($lib_conflict){
            Write-Host "find conflict lib '$lib_conflict' with '$name' '$version'"
            $lib_backup = "$lib_conflict.bak"
            Rename-Item "$lib_conflict" "$lib_backup"
        }
        $lib_link = "$target_dir/" + $lib_path.Name
        $lib_link = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$lib_link")
        $lib_path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$lib_path")
        New-Item -ItemType SymbolicLink -Path "$lib_link" -Target "$lib_path"
    }
}

Function Uninstall-Libs($source_dir,$target_dir) {
    $lib_paths = Get-ChildItem $source_dir -File -Recurse | Where-Object {
        $_.extension -like ".jar"
    }
    foreach ($lib_path in $lib_paths) {
        $lib_link = "$target_dir/" + $lib_path.Name
        $lib_link = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$lib_link")
        $lib_link = Get-Item $lib_link | Where-Object { 
            $_.Attributes -match "ReparsePoint"
        }
        if($lib_link) {
            Remove-Item $lib_link
        }

        $filename = $lib_path.Name
        $name, $version = Get-JarNameAndVersionByFilename $filename
        $lib_backup = ""
        $lib_backup = Get-ChildItem $target_dir -File -Recurse | Where-Object {
            $_.name -like "$name-[0-9].*bak"
        }
        if($lib_backup){
            Write-Host "find backup lib '$lib_backup' with '$name' '$version'"
            $lib_conflict = $lib_backup -replace ".bak$"
            Rename-Item "$lib_backup" "$lib_conflict"
        }
    }
}

Function Use-Libs($action,$source_dir,$target_dir) {
    # check interactive
    $non_interactive = Assert-IsNonInteractiveShell

    # default param
    if(! $action){
        Write-Host ""
        Write-Host "Need input action(install or uninstall):"
        $action = $non_interactive ? $null : (Read-Host)
        if(! $action) {
            $action = "install"
            Write-Host "param action is" $action
        }
    }
    if(! $source_dir){
        Write-Host ""
        Write-Host "Need input source path(empty will use 'cdc-to-rdb/.pdi/lib/kpt-schema-package-9.2.0.0-290-package'):"
        $source_dir = $non_interactive ? $null : (Read-Host)
        if(! $source_dir) {
            $source_dir = $script_dir + "/lib/kpt-schema-package-9.2.0.0-290-package"
            Write-Host "param source_dir is" $source_dir
        }
    }
    if(! $target_dir){
        Write-Host ""
        Write-Host "Need input source path(empty will use 'data-integration/lib'):"
        $target_dir = $non_interactive ? $null : (Read-Host)
        if(! $target_dir) {
            $target_dir = $script_dir + "/../../data-integration/lib"
            Write-Host "param target_dir is" $target_dir
        }
    }

    if($action -eq "install") {
        Install-Libs "$source_dir" "$target_dir"
    } elseif($action -eq "uninstall") {
        Uninstall-Libs "$source_dir" "$target_dir"
    } else {
        Write-Host "Incorrect action!"
        exit 1
    }
}

function Assert-IsNonInteractiveShell {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractive = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonI*' }

    if ([Environment]::UserInteractive -and -not $NonInteractive) {
        # We are in an interactive shell.
        return $false
    }

    return $true
}


$script_dir = Split-Path -parent $MyInvocation.MyCommand.Definition
#Run alone by default
$CallStack = Get-PSCallStack | Where-Object  {$_.Command -ne "<ScriptBlock>"}
if($CallStack.Count -eq 1){
    Use-Libs 
    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}