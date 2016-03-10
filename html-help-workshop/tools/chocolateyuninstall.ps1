$ErrorActionPreference = 'Stop';

$packageName = 'html-help-workshop'

$machine_key   = 'HKLM:\SOFTWARE\Microsoft\HTML Help Workshop'
$machine_key6432 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\HTML Help Workshop'
$htmlhelp_dir = Get-ItemProperty -Path @($machine_key6432,$machine_key) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty InstallDir -First 1
$htmlhelp_uninstall = Join-Path $htmlhelp_dir "htmlhelp.inf"

$rundll_exe = Join-Path $Env:SystemRoot "System32\rundll32.exe"
$rundll_exe6432 = Join-Path $Env:SystemRoot "SysWOW64\rundll32.exe"
$rundll = @($rundll_exe6432,$rundll_exe) | Where { Test-Path $_ } | Select-Object -First 1

Start-ChocolateyProcessAsAdmin "advpack.dll,LaunchINFSection ""$htmlhelp_uninstall"",,1,N" $rundll
