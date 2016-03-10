$ErrorActionPreference = 'Stop';

$packageName = 'html-help-workshop'
$url = 'https://download.microsoft.com/download/0/A/9/0A939EF6-E31C-430F-A3DF-DFAE7960D564/htmlhelp.exe'
$checksum = '53899be5da83419d772d5b97e653da7c'

# a temporary directory for extracted installer files
$temp_dir = Join-Path $Env:TEMP ([System.Guid]::NewGuid().ToString())
New-Item -Type Directory -Path $temp_dir | Out-Null

$htmlhelp_exe = Join-Path $temp_dir "htmlhelp.exe"
$htmlhelp_extracted = Join-Path $temp_dir "htmlhelp"
$htmlhelp_install = Join-Path $htmlhelp_extracted "htmlhelp.inf"

# download and extract
Get-ChocolateyWebFile $packageName $htmlhelp_exe $url -checksum $checksum
Start-ChocolateyProcessAsAdmin "/Q ""/T:$htmlhelp_extracted"" /C" $htmlhelp_exe

$rundll_exe = Join-Path $Env:SystemRoot "System32\rundll32.exe"
$rundll_exe6432 = Join-Path $Env:SystemRoot "SysWOW64\rundll32.exe"
$rundll = @($rundll_exe6432,$rundll_exe) | Where { Test-Path $_ } | Select-Object -First 1

# install from INF; flags = 1 (QUIET), reboot = N
Start-ChocolateyProcessAsAdmin "advpack.dll,LaunchINFSection ""$htmlhelp_install"",,1,N" $rundll

# cleanup temp directory
Remove-Item -Path $temp_dir -Recurse
