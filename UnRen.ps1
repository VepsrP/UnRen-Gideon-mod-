function final {
    Write-Host ""
    Write-Host -NoNewline "Enter 1 to go back to the menu, or any other key to exit: "
    $key = Read-Host
    if($key -eq 1) { menu }
    Exit
}

function extract {
    # Write-Host ""
    # Write-Host "   Creating rpatool..."
    # New-Item -ItemType "file" -Path "$currentdir\rpatool.py" | Out-Null
    # [IO.File]::WriteAllBytes("$currentdir\rpatool.py", [Convert]::FromBase64String($rpatool))

    Write-Host ""
    Write-Host "   Remove RPA archives after extraction?"
    Write-Host -NoNewline "    Enter (y/n)"
    [char]$key = Read-Host
    if ($key -eq "y") {
        Write-Host "   + RPA archives will be deleted"
        Write-Host ""
    } else {
        Write-Host "   + RPA archives won't be deleted"
        Write-Host ""
    }

    Set-Location -Path $gamedir

    if (Test-Path "$pythondir\Lib")
    {
        if($key -eq "y"){
            & "$pythondir\python.exe" "-O" "$currentdir\rpatool.py" "-r" "$gamedir"
        }
        else {
            & "$pythondir\python.exe" "-O" "$currentdir\rpatool.py" "$gamedir"
        }
    } else {
        if($key -eq "y"){
            & "$pythondir\python.exe" "$currentdir\rpatool.py" "-r" "$gamedir"
        }
        else {
            & "$pythondir\python.exe" "$currentdir\rpatool.py" "$gamedir"
        }
    }

    # Remove-Item -Path "$currentdir\rpatool.py"
    final
}

#
function decompile {
    if (Test-Path "$pythondir\Lib")
    {
        & "$pythondir\python.exe" "-O" "$currentdir\unrpyc.py" "-c" "--init-offset" $gamedir
        Write-Host ""
    } else {
        & "$pythondir\python.exe" "$currentdir\unrpyc.py" "-c" "--init-offset" $gamedir
        Write-Host ""
    }
    Write-Host "All Scripts are decompiled"
    final
}

#Drop our console/dev mode enabler into the game folder
function console {
    Write-Host ""
    Write-Host "   Creating Developer/Console file..."
    New-Item -ItemType "file" -Path "$gamedir\unren-console.rpy" -Force | Out-Null
    [IO.File]::WriteAllBytes("$gamedir\unren-console.rpy", [Convert]::FromBase64String($unren_console))

    Write-Host "    + Console: SHIFT+O"
    Write-Host "    + Dev Menu: SHIFT+D"
    final
}

#Drop our Quick Save/Load file into the game folder
function quick {
    Write-Host ""
    Write-Host "   Creating unren-quick.rpy..."
    New-Item -ItemType "file" -Path "$gamedir\unren-quick.rpy" -Force | Out-Null
    [IO.File]::WriteAllBytes("$gamedir\unren-quick.rpy", [Convert]::FromBase64String($unren_quick))

    Write-Host "    Default hotkeys:"
    Write-Host "    + Quick Save: F5"
    Write-Host "    + Quick Load: F9"
    final
}

#Drop our skip file into the game folder
function skip {
    Write-Host ""
    Write-Host "   Creating skip file..."
    New-Item -ItemType "file" -Path "$gamedir\unren-skip.rpy" -Force | Out-Null
    [IO.File]::WriteAllBytes("$gamedir\unren-skip.rpy", [Convert]::FromBase64String($unren_skip))

    Write-Host "    + You can now skip all text using TAB and CTRL keys"
    final
}

#Drop our skip file into the game folder
function rollback {
    Write-Host "   Creating rollback file..."
    New-Item -ItemType "file" -Path "$gamedir\unren-rollback.rpy" -Force | Out-Null
    [IO.File]::WriteAllBytes("$gamedir\unren-rollback.rpy", [Convert]::FromBase64String($unren_rollback))

    Write-Host "    + You can now rollback using the scrollwheel"
    final
}

function menu {
    Write-Host ""
    Write-Host "   Available Options:"
    Write-Host "     1) Extract RPA packages"
    Write-Host "     2) Decompile rpyc files"
    Write-Host "     3) Enable Console and Developer Menu"
    Write-Host "     4) Enable Quick Save and Quick Load"
    Write-Host "     5) Force enable skipping of unseen content"
    Write-Host "     6) Force enable rollback (scroll wheel)"
    Write-Host "     7) Deobfuscate Decompile rpyc files"
    Write-Host "     8) Extract and Decompile"
    Write-Host "     9) All of the above"
    Write-Host ""
    Write-Host -NoNewline "Enter a number:"
    [int] $option = Read-Host
    switch ($option) {
        1 { extract }
        2 { decompile }
        3 { console }
        4 { quick }
        5 { skip }
        6 { rollback }
        Default
        {
            final
        }
    }
}

<#
--------------------------------------------------------------------------------
Configuration:
Set a Quick Save and Quick Load hotkey - http://www.pygame.org/docs/ref/key.html
--------------------------------------------------------------------------------
!! END CONFIG !!
--------------------------------------------------------------------------------
The following variables are Base64 encoded strings for unrpyc and rpatool
Due to batch limitations on variable lengths, they need to be split into
multiple variables, and joined later using powershell.
--------------------------------------------------------------------------------
unrpyc by CensoredUsername
https://github.com/CensoredUsername/unrpyc
--------------------------------------------------------------------------------
#>

<#
--------------------------------------------------------------------------------
rpatool by Shizmob 9a58396 2019-02-22T17:31:07.000Z
https://github.com/Shizmob/rpatool
--------------------------------------------------------------------------------
#>

<#
The file for enabling the console and developer mode.
#>

[string]$unren_console = "aW5pdCA5OTkgcHl0aG9uOg0KICAgIGNvbmZpZy5kZXZlbG9wZXIgPSBUcnVlDQogICAgY29uZmlnLmNvbnNvbGUgPSBUcnVl"

<#
The file for enabling the Quick Save/Load.
#>

[string]$unren_quick = "aW5pdCA5OTkgcHl0aG9uOg0KICAgIHRyeToNCiAgICAgICAgY29uZmlnLnVuZGVybGF5WzBdLmtleW1hcFsncXVpY2tTYXZlJ10gPSBRdWlja1NhdmUoKQ0KICAgICAgICBjb25maWcua2V5bWFwWydxdWlja1NhdmUnXSA9ICdLX0Y1Jw0KICAgICAgICBjb25maWcudW5kZXJsYXlbMF0ua2V5bWFwWydxdWlja0xvYWQnXSA9IFF1aWNrTG9hZCgpDQogICAgICAgIGNvbmZpZy5rZXltYXBbJ3F1aWNrTG9hZCddID0gJ0tfRjknDQogICAgZXhjZXB0Og0KICAgICAgICBwYXNz"

<#
The file for enabling skip.
#>

[string]$unren_skip = "aW5pdCA5OTkgcHl0aG9uOg0KICAgIF9wcmVmZXJlbmNlcy5za2lwX3Vuc2VlbiA9IFRydWUNCiAgICByZW5weS5nYW1lLnByZWZlcmVuY2VzLnNraXBfdW5zZWVuID0gVHJ1ZQ0KICAgIHJlbnB5LmNvbmZpZy5hbGxvd19za2lwcGluZyA9IFRydWUNCiAgICByZW5weS5jb25maWcuZmFzdF9za2lwcGluZyA9IFRydWUNCiAgICB0cnk6DQogICAgICAgIGNvbmZpZy5rZXltYXBbJ3NraXAnXSA9IFsgJ0tfTENUUkwnLCAnS19SQ1RSTCcgXQ0KICAgIGV4Y2VwdDoNCiAgICAgICAgcGFzcw0K"

<#
The file for enabling rollback.
#>

[string]$unren_rollback = "aW5pdCA5OTkgcHl0aG9uOg0KICAgIHJlbnB5LmNvbmZpZy5yb2xsYmFja19lbmFibGVkID0gVHJ1ZQ0KICAgIHJlbnB5LmNvbmZpZy5oYXJkX3JvbGxiYWNrX2xpbWl0ID0gMjU2DQogICAgcmVucHkuY29uZmlnLnJvbGxiYWNrX2xlbmd0aCA9IDI1Ng0KICAgIGRlZiB1bnJlbl9ub2Jsb2NrKCAqYXJncywgKiprd2FyZ3MgKToNCiAgICAgICAgcmV0dXJuDQogICAgcmVucHkuYmxvY2tfcm9sbGJhY2sgPSB1bnJlbl9ub2Jsb2NrDQogICAgdHJ5Og0KICAgICAgICBjb25maWcua2V5bWFwWydyb2xsYmFjayddID0gWyAnS19QQUdFVVAnLCAncmVwZWF0X0tfUEFHRVVQJywgJ0tfQUNfQkFDSycsICdtb3VzZWRvd25fNCcgXQ0KICAgIGV4Y2VwdDoNCiAgICAgICAgcGFzcw=="

<#
--------------------------------------------------------------------------------
!! DO NOT EDIT BELOW THIS LINE !!
--------------------------------------------------------------------------------
#>

[string]$version = "version=ultrahack(v7) (220916)"
[System.Console]::Title = "UnRen.bat $version"

<#
--------------------------------------------------------------------------------
Splash screen
--------------------------------------------------------------------------------
#>

Clear-Host
Write-Host "     __  __      ____               __          __"
Write-Host "    / / / /___  / __ \___  ____    / /_  ____ _/ /_"
Write-Host "   / / / / __ \/ /_/ / _ \/ __ \  / __ \/ __ ^`/ __/"
Write-Host "  / /_/ / / / / _ ,_/| __/ / / / / /_/ / /_/ / /_"
Write-Host "  \____/_/ /_/_/ \_\ \__/_/ /_(_)_.___/\__,_/\__/ $version"
Write-Host "   Sam @ www.f95zone.to"
Write-Host ""
Write-Host "  ----------------------------------------------------"

<#
--------------------------------------------------------------------------------
Set our paths, and make sure we can find python exe
--------------------------------------------------------------------------------
#>
[string]$currentdir = $PWD.Path
if ((Test-Path "$currentdir\lib\py3-windows-x86_64\python.exe") -and ([Environment]::Is64BitOperatingSystem -eq $true))
{
    [string]$pythondir = "$currentdir\lib\py3-windows-x86_64"
} elseif (Test-Path "$currentdir\lib\py3-windows-i686\python.exe")
{
    [string]$pythondir = "$currentdir\lib\py3-windows-i686"
}
if ((Test-Path "$currentdir\lib\py2-windows-x86_64\python.exe") -and ([Environment]::Is64BitOperatingSystem -eq $true))
{
    [string]$pythondir = "$currentdir\lib\py2-windows-x86_64"
} elseif (Test-Path "$currentdir\lib\py2-windows-i686\python.exe")
{
    [string]$pythondir = "$currentdir\lib\py2-windows-i686"
}
if ((Test-Path "$currentdir\lib\windows-x86_64\python.exe") -and ([Environment]::Is64BitOperatingSystem -eq $true))
{
    [string]$pythondir = "$currentdir\lib\windows-x86_64"
} elseif (Test-Path "$currentdir\lib\windows-i686\python.exe")
{
    [string]$pythondir = "$currentdir\lib\windows-i686"
}

if ($null -eq $pythondir)
{
    Write-Host "! Error: Cannot locate python directory, unable to continue."
    Write-Host "  Are you sure we're in the game's root directory?"
    Write-Host ""
    Write-Host "  Press any key to exit..."
    Read-Host
    Exit
}

if ((Test-Path "$currentdir\renpy") -and (Test-Path "$currentdir\game"))
{
    [string]$gamedir = "$currentdir\game\"
} else {
    Write-Host "! Error: Cannot locate game directory, unable to continue."
    Write-Host "  Are you sure we're in the game's root directory?"
    Write-Host ""
    Write-Host "  Press any key to exit..."
    Read-Host
    Exit
}

$Env:PYTHONHOME=$pythondir
if (Test-Path "$currentdir\lib\pythonlib2.7"){
    $Env:PYTHONPATH="$currentdir\lib\pythonlib2.7"
} elseif (Test-Path "$currentdir\lib\python2.7") {
    $Env:PYTHONPATH="$currentdir\lib\python2.7"
} elseif (Test-Path "$currentdir\lib\python3.9") {
    $Env:PYTHONPATH="$currentdir\lib\python3.9"
}

menu
