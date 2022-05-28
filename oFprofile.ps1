# $profile（C:\Users\[username]\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1）に
# ."[oFprofile.ps1を保存したパス]\oFprofile.ps1" を記述する

function ofpgen
{
    Param(
        [parameter(mandatory=$true)][string]$projectPath,
        [string]$options
    )
    $oFConfig = [XML](Get-Content $PSScriptRoot\oFconfig)
    $oFPath = $oFConfig.config.oFPath

    $argument = "-o`"$oFPath`" $options `"$projectPath`""
    $appPath = "$oFPath\projectGenerator\resources\app\app\projectGenerator"
    Start-Process -FilePath $appPath -ArgumentList "$argument" -Wait
    echo "done!"
}

function ofupdate
{
    if (Test-Path *.sln) {
        $currentDir = (Get-Location).Path
        $projectPath = $currentDir
        $options = ""
        echo "update..."
        ofpgen $projectPath $options
    } else {
        echo "Current Dir is not oF Project Folder..."
        break
    }
}

function ofcodeset
{
    Param([parameter(mandatory=$true)][string]$projectName)
    echo "vscode setting...";

    $workspaceConfigPath = ".\$projectName\$projectName.code-workspace"
    if ( -not (Test-Path ./$projectName/.vscode)) {
        mkdir .\$projectName\.vscode | out-null
    }
    $cppConfigPath = ".\$projectName\.vscode\c_cpp_properties.json"

    $oFConfig = [XML](Get-Content $PSScriptRoot\oFconfig)
    $oFPath = $oFConfig.config.oFPath
    $oFPathRep = $oFPath.Replace("\", "/")

    $workspaceConfig = (Get-Content $PSScriptRoot\oFvscode_temp\temp.code-workspace | foreach { $_ -replace "{oFPath}", $oFPathRep })
    Write-Output $workspaceConfig | Out-File -Encoding UTF8 $workspaceConfigPath

    $cppConfig = (Get-Content $PSScriptRoot\oFvscode_temp\c_cpp_properties.json | foreach { $_ -replace "{oFPath}", $oFPathRep })
    Write-Output $cppConfig | Out-File -Encoding UTF8 $cppConfigPath

    echo "done!";
}

function ofinit
{
    Param([parameter(mandatory=$true)][string]$projectName)
    $currentDir = (Get-Location).Path
    $projectPath = "$currentDir\$projectName"
    $options = "-p`"vs`""
    echo "init..."
    ofpgen $projectPath $options
    ofcodeset $projectName
}

function ofcode
{
    Param([parameter(mandatory=$true)][string]$projectName)
    $currentDir = (Get-Location).Path
    $projectPath = "$currentDir\$projectName"
    $workPath = "$projectPath\$projectName.code-workspace"
    if (Test-Path $workPath) {
        echo "Open vscode"
        start $workPath
        cd $projectPath
    } else {
        echo "There is not oF Project Folder..."
        break
    }
}

function ofaddon
{
    Param(
        [string]$sw,
        [string]$addons
    )
    if (Test-Path *.sln) {
        $addonSelection = @(cat ./addons.make)

        $oFConfig = [XML](Get-Content $PSScriptRoot\oFconfig)
        $oFPath = $oFConfig.config.oFPath
        $addonList = @(ls -Name "$oFPath\addons")

        switch ($sw) {
            "list" {
                echo $addonSelection
                break
            }
            "apply" {
                $addonArray = $addons.Split(",")
                $validText = ""
                $validNum = 0
                foreach ($i in $addonArray) {
                    foreach ($j in $addonList) {
                        if ($i -eq $j) {
                            if ($validNum -eq 0) {
                                $validText = $i
                            } else {
                                $validText =  $validText + "," + $i
                            }
                            $validNum = $validNum + 1
                            break
                        }
                    }
                }
                $currentDir = (Get-Location).Path
                $projectPath = $currentDir
                $options = "-p`"vs`" -a`"$validText`""
                echo "apply addon `"$validText`"..."
                echo "update..."
                ofpgen $projectPath $options
                break
            }
            default {
                echo $addonList
                break
            }
        }
    } else {
        echo "Current Dir is not oF Project Folder..."
        break
    }
}

function ofbuild
{
    Param(
        [string]$sw
    )
    if (Test-Path *.sln) {
        $buildConfig = "/p:Configuration=Debug"
        $buildTarget = "/t:Build"
        switch ($sw) {
            "db"{
                # Debug Build
                $buildConfig = "/p:Configuration=Debug"
                $buildTarget = "/t:Build"
                break
            }
            "dbr" {
                # Debug Build Run
                $buildConfig = "/p:Configuration=Debug"
                $buildTarget = "/t:Build,Run"
                break
            }
            "dc"{
                # Debug Clean
                $buildConfig = "/p:Configuration=Debug"
                $buildTarget = "/t:Clean"
                break
            }
            "rb"{
                # Release Build
                $buildConfig = "/p:Configuration=Release"
                $buildTarget = "/t:Build"
                break
            }"rbr"{
                # Release Build Run
                $buildConfig = "/p:Configuration=Release"
                $buildTarget = "/t:Build,Run"
                break
            }
            "rc"{
                # Release Clean
                $buildConfig = "/p:Configuration=Release"
                $buildTarget = "/t:Clean"
                break
            }
            default {
                # Debug Build
                break
            }
        }
        ofupdate
        $oFConfig = [XML](Get-Content $PSScriptRoot\oFconfig)
        $MSBuildPath = $oFConfig.config.MSBuildPath
        $PlatformToolset = $oFConfig.config.PlatformToolset
        Invoke-Expression "$MSBuildPath /p:PlatformToolset=$PlatformToolset $buildTarget $buildConfig"
    } else {
        echo "Current Dir is not oF Project Folder..."
        break
    }
}

function ofrun
{
    Param(
        [string]$sw
    )
    if (Test-Path *.sln) {
        $currentDir = (Get-Location).Path
        $parentDir = Split-Path $currentDir -Parent
        $projectName = Split-Path $currentDir -Leaf
        $exePath = "${currentDir}\bin\${projectName}_debug.exe"
        switch ($sw) {
            "d"{
                # Debug
                $exePath = "${currentDir}\bin\${projectName}_debug.exe"
                break
            }
            "r"{
                # Release
                $exePath = "${currentDir}\bin\${projectName}.exe"
                break
            }
            default {
                # Debug
                break
            }
        }
        Invoke-Expression $exePath
    } else {
        echo "Current Dir is not oF Project Folder..."
        break
    }
}
