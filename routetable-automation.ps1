# Replace 'myResourceGroup' and 'myVNet' with the names of your resource group and VNet, respectively
$resourceGroupName = 'VNETRG2'
$vnetName = 'vnet2'
# Get the VNet resource
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName

# Get the subnets for the VNet
$subnets = $vnet.Subnets

# Iterate through the subnets
foreach ($subnet in $subnets) {
  # Get the route table for the subnet
  $routeTable = $subnet.RouteTable
  Write-Output $routeTable
  if ($routeTable -ne $null) {
    # Get the route table name
    $routeTableName = $routeTable.Id.Split('/')[-1]
    Write-Output "Route table: $routeTableName"
    
    $routes = Get-AzRouteTable -Name $routeTableName -ResourceGroupName $resourceGroupName | Select-Object -ExpandProperty Routes
    for ($i = 0; $i -lt $routes.Count; $i++) {
        $routeName = $routes[$i].Name
        Write-Output "Deleting Route: $routeName"
        $routetableconfig = Get-AzRouteTable -ResourceGroupName $resourceGroupName -Name $routeTableName
        Write-Output $routetableconfig
        Remove-AzRouteConfig -Name $routeName -RouteTable $routetableconfig | Set-AzRouteTable  
    }
  }         
}
