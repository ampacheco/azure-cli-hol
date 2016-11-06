# #!/bin/bash
# alias azure=azure.cmd

# # azure login
# # azure config mode arm
# # azure account list
# # azure account set $(azure account list |grep -i Sale| awk '{print $6}')

rgName="reddsystem-rg"
regionName="eastus"
vnName="reddsystem-vnet" 
vnSubnetName1="Subnet-1"  #10.0.1.0/24
vnSubnetName2="Subnet-2"  #10.0.2.0/24
vnSubnetName3="Subnet-3"  #10.0.3.0/24

# ipLBExternal="lbExternalIP"
# lbExternalSubnet1="lbExternalSubnet1"

# # Create Resourse Group
# azure group create -n $rgName -l $regionName

# # Create Network
# azure network vnet create -g $rgName -n $vnName -a 10.0.0.0/16 -l $regionName

# # Create Subnet Improove with do
# azure network vnet subnet create -g $rgName -e $vnName -n $vnSubnetName1 -a 10.0.1.0/24
# azure network vnet subnet create -g $rgName -e $vnName -n $vnSubnetName2 -a 10.0.2.0/24
# azure network vnet subnet create -g $rgName -e $vnName -n $vnSubnetName3 -a 10.0.3.0/24

# # Create Public IP, always the same
# azure network public-ip create -g $rgName -n $ipLBExternal -l $regionName -a static -i 4

# # Create Load Balancer
# azure network lb create -g $rgName -n $lbExternalSubnet1 -l $regionName

# # Create a Public IP for the Load Balancer
# azure network lb frontend-ip create -g $rgName -l $lbExternalSubnet1 -n FrontendPool -i $ipLBExternal

# # Create the Address Pool for the Load Balancer
# azure network lb address-pool create -g $rgName -l $lbExternalSubnet1 -n BackendPool

# # Add Rules
# azure network lb inbound-nat-rule create --resource-group $rgName --lb-name $lbExternalSubnet1 --name ssh1 --protocol tcp --frontend-port 21 --backend-port 22

# # Create a NIC 1
# azure network nic create \
# 	--resource-group $rgName \
# 	--name nicSubnet1Vm1 \
# 	--subnet-name $vnSubnetName1 \
# 	--subnet-vnet-name  $vnName \
# 	-l $regionName \
# 	-d "/subscriptions/bea58bdb-2c49-43b7-bdfe-492a2025632d/resourceGroups/reddsystem-rg/providers/Microsoft.Network/loadBalancers/lbExternalSubnet1/backendAddressPools/BackendPool" \
# 	-e "/subscriptions/bea58bdb-2c49-43b7-bdfe-492a2025632d/resourceGroups/reddsystem-rg/providers/Microsoft.Network/loadBalancers/lbExternalSubnet1/inboundNatRules/ssh1"

# Create Storage Account
# azure storage account create reddsystemvhdssubnet1 -g reddsystem-rg -l eastus --sku-name LRS --kind Storage

# Create Availability Set
#azure availset create -g $rgName -l $regionName -name $avSetName

# Create VM

# Set variables to use for backend resource group
vmSize="Standard_A3"
publisher="Canonical"
offer="UbuntuServer"
sku="14.04.2-LTS"
version="latest"
osDiskName="osdiskdb"
dataDiskName="datadisk"
nicNamePrefix="NICDB"
ipAddressPrefix="192.168.2."
username='cloud'
password='CloudM4ster!'
numberOfVMs=2

#Create the VM
azure vm create cosvm1subnet1 --resource-group $rgName \
    --location $regionName \
    --vm-size $vmSize \
    --subnet-id $vnSubnetName1\
    --availset-name avSetSubnet1 \
    --nic-names nicSubnet1Vm1 \
    --os-type linux \
    --image-urn $publisher:$offer:$sku:$version \
    --storage-account-name reddsystem0011sa \
    --storage-account-container-name vhds \
    --os-disk-vhd $osDiskName$suffixNumber.vhd \
    --admin-username $username \
    --admin-password $password