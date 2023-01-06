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
#Functional code
Write-Host "starting vnet peering" -ForegroundColor Green
$virtualNetwork1=Get-AzVirtualNetwork -Name $VNET -ResourceGroupName $RG1
$virtualNetwork2=Get-AzVirtualNetwork -Name $RemoteVnet -ResourceGroupName $RG2
Add-AzVirtualNetworkPeering `
  -Name myVirtualNetwork1-myVirtualNetwork2 `
  -VirtualNetwork $virtualNetwork1 `
  -RemoteVirtualNetworkId $virtualNetwork2.Id
Add-AzVirtualNetworkPeering `
  -Name myVirtualNetwork2-myVirtualNetwork1 `
  -VirtualNetwork $virtualNetwork2 `
  -RemoteVirtualNetworkId $virtualNetwork1.Id
Get-AzVirtualNetworkPeering `
  -ResourceGroupName $RG1 `
  -VirtualNetworkName $VNET `
  | Select PeeringState

  #Deleting the existing DNS servers for a VNET 
  Write-Host "Deleting the existing DNS servers for a VNET " -ForegroundColor Green
  $virtualNetwork2=Get-AzVirtualNetwork -Name $RemoteVnet -ResourceGroupName $Rg2
  #$dnsipsplit = $DNSIPs -split ","
  $virtualNetwork1.DhcpOptions.DnsServers = null
  Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork1

  #Setting up Custom DNS servers for a VNET 
  Write-Host "Setting up Custom DNS servers for the VNET" -ForegroundColor Green
  $virtualNetwork2=Get-AzVirtualNetwork -Name $RemoteVnet -ResourceGroupName $Rg2
  $dnsipsplit = $DNSIPs -split ","
  foreach ($IP in $dnsipsplit)
  {
  $virtualNetwork1.DhcpOptions.DnsServers += $IP
  }
  Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork1

}
