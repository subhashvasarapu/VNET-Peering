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
   $virtualNetwork1.DhcpOptions = $null
   foreach ($IP in $DNSIPs)
   {
   $vnet.DhcpOptions += $IP
   }
   Set-AzVirtualNetwork -VirtualNetwork $VNET
}

#Setting up Custom DNS servers for a VNET 
Write-Host "Setting up Custom DNS servers for the VNET" -ForegroundColor Green
$virtualNetwork1.DhcpOptions.DnsServers = $null
foreach ($IP in $DNSIPs)
{
$vnet.DhcpOptions.DnsServers += $IP
}
Set-AzureRmVirtualNetwork -VirtualNetwork $VNET
