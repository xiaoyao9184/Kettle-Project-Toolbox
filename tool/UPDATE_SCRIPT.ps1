#CODER BY xiaoyao9184 1.0
#TIME 2022-04-15
#FILE UPDATE_SCRIPT

Function Get-SourceFile($source_name,$source_folder) {
    $match_file = Get-ChildItem $source_folder -File -Recurse | Where-Object {
        $_.name -CEQ $source_name
    }
    return $match_file
}

Function Get-SourceName($target_file) {
    $source_file_name = Get-Content $target_file | Where-Object {
        $_ -match "::FILE (.*)|# FILE (.*)"
    } | ForEach-Object {
        $a = $_ | Select-String -Pattern "::FILE (.*)|# FILE (.*)"
        return ($a.matches.groups[1].value) ?
            $a.matches.groups[1].value :
            $a.matches.groups[2].value
    }
    # check null
    return ($source_file_name) ?
        $source_file_name + $target_file.extension :
        $source_file_name
}

Function Get-TargetSource($target_folder_path_list,$source_folder_path_list,$target_include_list) {
    $target_folder_path_list = $target_folder_path_list | Where-Object {$_}
    $source_folder_path_list = $source_folder_path_list | Where-Object {$_}
   
    # target folder to file
    $target_file_list = $target_folder_path_list | ForEach-Object {
        Get-ChildItem $_ -Include $target_include_list -File -Recurse
    }
    # target file with source file add to map
    $arr = @()
    foreach ($target_file in $target_file_list){
        $obj = New-Object -TypeName psobject
        $arr += $obj
        $obj | Add-Member -MemberType NoteProperty -Name target -Value $target_file

        $name = Get-SourceName $target_file
        if ($name){
            $obj | Add-Member -MemberType NoteProperty -Name name -Value $name
        } else {
            continue
        }

        foreach ($source_folder in $source_folder_path_list){
            $source_file = Get-SourceFile $name $source_folder
            if ($source_file){
                $obj | Add-Member -MemberType NoteProperty -Name source -Value $source_file
                break
            }
        }
    }
    return $arr
}

Function Update-Script($target_path,$source_path,$target_include) {
    # check interactive
    $non_interactive = Assert-IsNonInteractiveShell

    # default param
    if(! $target_path){
        Write-Host ""
        Write-Host "Need input target path(empty will use '../default'):"
        $target_path = $non_interactive ? $null : (Read-Host)
        if(! $target_path) {
            $target_path = $script_dir + "/../default;"
            Write-Host "param target_path is" $target_path
        }
    }
    if(! $source_path){
        Write-Host ""
        Write-Host "Need input source path(empty will use '../shell;'):"
        $source_path = $non_interactive ? $null : (Read-Host)
        if(! $source_path) {
            $source_path = $script_dir + "/../shell;"
            Write-Host "param source_path is" $source_path
        }
    }
    if(! $target_include){
        Write-Host ""
        Write-Host "Need input target include(empty will use '*.bat,*.sh'):"
        $target_include = $non_interactive ? $null : (Read-Host)
        if(! $target_include) {
            $target_include = "*.bat,*.sh"
            Write-Host "param target_include is" $target_include
        }
    }

    # string param to object
    $target_folder_path_list = $target_path.Split(";")
    $source_folder_path_list = $source_path.Split(";")
    $target_include_list = $target_include.Split(",")

    # core call
    $list = Get-TargetSource `
        $target_folder_path_list `
        $source_folder_path_list `
        $target_include_list

    Write-Host "replace source target:"
    # replace file
    foreach ($item in $list){
        if($item.source){
            Copy-Item $item.source $item.target -Force
            Write-Host $item.target "<-" $item.source
        } else {
            Write-Host $item.target "<- ?" -ForegroundColor red
        }
    }
    Write-Host ""
    Write-Host "update done"
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
    Update-Script
    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}