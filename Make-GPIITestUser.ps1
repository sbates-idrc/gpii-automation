$testUserName = "GPIITestUser"
$testUserPassword = "password"

$logonScriptName = "OnLogon-${testUserName}.bat"

$logonScriptContents = @"
%HOMEDRIVE%
cd %HOMEPATH%
git clone https://github.com/simonbates/gpii-automation
cd gpii-automation
start powershell.exe -File OnLogon.ps1 -WindowStyle Normal
"@

# Create our test user

net user $testUserName $testUserPassword /add

# Configure auto logon

reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d $testUserName /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d $testUserPassword /f

# Set up the logon script

New-Item -ItemType directory -Force C:\Windows\System32\Repl\Import\Scripts
Out-File -FilePath "C:\Windows\System32\Repl\Import\Scripts\$logonScriptName" -Encoding ASCII -InputObject $logonScriptContents
net user $testUserName /scriptpath:$logonScriptName