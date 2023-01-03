$file= Import-Csv -Path "C:\Users\suvasara\Desktop\AzTS-Modules\vnet-peering\peering.csv"
foreach ($row in $file)
{
#Calling Variables row by row
   $VNET = $row.VNETname
   $RG1 = $row.RG1
   $RemoteVnet = $row.RemoteVNETname
   $RG2 = $row.RG2
   $DNSIPs = $row.DNSservers
   Write-Host $VNET,$RemoteVnet,$DNSIPs,$RG1,$RG2
#Setting up Custom DNS servers for a VNET 
   Write-Host "Setting up Custom DNS servers for the VNET" -ForegroundColor Green
   $virtualNetwork1=Get-AzVirtualNetwork -Name $VNET -ResourceGroupName $RG1
   foreach ($IP in $DNSIPs)
   {
   $newObject = New-Object -type PSObject -Property @{"DnsServers" = $DNSIPs}
   $virtualNetwork1.DhcpOptions = $newObject
   }
   Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork1
}
