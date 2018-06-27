<powershell>
  start-sleep -s 60
  # The DNS servers that we want to use
  $newDNSServers = "10.131.14.220","10.131.15.221"
  # Get all network adapters that already have DNS servers set
  $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DNSServerSearchOrder -ne $null}
 
  # Set the DNS server search order for all of the previously-found adapters
  $adapters | ForEach-Object {$_.SetDNSServerSearchOrder($newDNSServers)}
   
  #Getting domain credentials
 
  $domain = (Get-SSMParameterValue -Name fngn.com-domain).Parameters[0].Value
  $username = (Get-SSMParameterValue -Name fngn.com-domainjoiner).Parameters[0].Value
  $password = (Get-SSMParameterValue -Name domainjoiner-password -WithDecryption $True).Parameters[0].Value | ConvertTo-SecureString -asPlainText -Force
  $credential = New-Object System.Management.Automation.PSCredential($username,$password)
  #joining the server to the AD Domain
  Add-Computer -NewName ${computer_name} -DomainName $domain -Credential $credential
 
  #create local folder, copy Landesk and Sentinel One install files to it.
  mkdir c:\tools
  New-PSDrive -name "G" -PSProvider FileSystem -Root \\Land-prd-02.fngn.com\software\tools -Persist -Credential $credential
  Copy-Item -Path G:\*.* -Destination C:\tools
  Remove-PSDrive -Name "G" -force
 
  #start install
   
  cd C:\tools
  Start-Process 'C:\tools\Base Win2012R2 Server Configuration + Monitoring_with_status.exe' -RedirectStandardError c:\tools\LanDeskErrors.txt
  start-sleep -s 300
  msiexec /i 'c:\tools\SentinelInstaller-2_1_2_6003-noVSS.msi' /quiet /l*v LogFile.txt
  start-sleep -s 60
  Restart-Computer -force
 
</powershell>
