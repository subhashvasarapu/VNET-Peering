$file= Import-Csv -Path "C:\Users\suvasara\Desktop\AzTS-Modules\vnet-peering\peering.csv"
foreach ($row in $file)
{
#Calling Variables row by row
   $VNET = $row.VNETname
   $RG1 = $row.RG1
   $RemoteVnet = $row.RemoteVNETname
   $RG2 = $row.RG2
   $DNSIPs = $row.DNSservers
   Write-Host $VNET,$RemoteVnet,$DNSIPs,$RG1,$RG2,$dnsipsplit
#Setting up Custom DNS servers for a VNET 
   Write-Host "Setting up Custom DNS servers for the VNET" -ForegroundColor Green
   $virtualNetwork1=Get-AzVirtualNetwork -Name $VNET -ResourceGroupName $RG1
   $dnsipsplit = $DNSIPs -split ","
   foreach ($IP in $dnsipsplit)
   {
   $virtualNetwork1.DhcpOptions.DnsServers += $IP
   }
   Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork1
}
