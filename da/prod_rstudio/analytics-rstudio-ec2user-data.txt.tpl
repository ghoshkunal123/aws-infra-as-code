#<script>
#c:\Support\patch\forcewsus_user.cmd
#</script>
<powershell>
  start-sleep -s 60
  $wmi =Get-WmiObject Win32_NetworkAdapterConfiguration -filter "ipenabled = 'true'"
  $wmi.SetDNSServerSearchOrder('10.131.14.220')
  $domain = (Get-SSMParameterValue -Name fngn.com-domain).Parameters[0].Value
  $username = (Get-SSMParameterValue -Name fngn.com-domainjoiner).Parameters[0].Value
  $password = (Get-SSMParameterValue -Name domainjoiner-password -WithDecryption $True).Parameters[0].Value | ConvertTo-SecureString -asPlainText -Force
  $credential = New-Object System.Management.Automation.PSCredential($username,$password)
  Add-Computer -DomainName $domain -newname anly-rstudio -Credential $credential
  Restart-Computer -force

</powershell>
#<persist>true</persist>
