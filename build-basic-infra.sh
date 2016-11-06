#!/bin/bash
alias azure=azure.cmd

# Variables
nroVMsbySubnet=2
location=eastus
rgName=reddsystem-rg
vnName=reddsystem-vnet

vnSubnet1Name=subnet1
vnSubnet2Name=subnet2
vnSubnet3Name=subnet3

# Create Resourse Group
azure group create -n $rgName -l $location

# Create Network
azure network vnet create -g $rgName -n $vnName -a 10.0.0.0/16 -l $location

# Create Subnet Improove with do
azure network vnet subnet create -g $rgName -e $vnName -n $vnSubnet1Name -a 10.0.1.0/24
azure network vnet subnet create -g $rgName -e $vnName -n $vnSubnet2Name -a 10.0.2.0/24
azure network vnet subnet create -g $rgName -e $vnName -n $vnSubnet3Name -a 10.0.3.0/24

# Crear Storage 
saSubnet1Name=subnet11reddssytemsa
saSubnet2Name=subnet22reddssytemsa
saSubnet3Name=subnet33reddssytemsa

azure storage account create $saSubnet1Name -g reddsystem-rg -l $location --sku-name LRS --kind Storage
azure storage account create $saSubnet2Name -g reddsystem-rg -l $location --sku-name LRS --kind Storage
azure storage account create $saSubnet3Name -g reddsystem-rg -l $location --sku-name LRS --kind Storage

# Crear Availabilties Sets
avSetSubnet1Name=subnet1AvSet
avSetSubnet2Name=subnet2AvSet
avSetSubnet3Name=subnet3AvSet

azure availset create -g $rgName -l $location -n $avSetSubnet1Name
azure availset create -g $rgName -l $location -n $avSetSubnet2Name
azure availset create -g $rgName -l $location -n $avSetSubnet3Name

# Build VMs

vmSize="Standard_A3"

publisher="Canonical"
offer="UbuntuServer"
sku="14.04.2-LTS"
version="latest"

osDiskName="osdiskdb"
dataDiskName="datadisk"
username='cloudroot'
password='CloudM4ster!'

# subnet1 VMS
#
for ((i=1;i<=nroVMsbySubnet; i++)); 
do
    # VM Name
    vmName=s1vm00$i
    nicName=nicS1VM00$i

    # NIC
    azure network nic create --resource-group $rgName \
        --name $nicName \
        --subnet-name $vnSubnet1Name \
        --subnet-vnet-name $vnName \
        --location $location
    
    azure vm create --resource-group $rgName \
        --name $vmName \
        --location $location \
        --vm-size $vmSize \
        --subnet-id $vnSubnet1Name \
        --availset-name $avSetSubnet1Name \
        --nic-names $nicName \
        --os-type linux \
        --image-urn $publisher:$offer:$sku:$version \
        --storage-account-name $saSubnet1Name \
        --admin-username $username \
        --admin-password $password

done

# subnet2 VMS
#
for ((i=1;i<=nroVMsbySubnet; i++)); 
do
    # VM Name
    vmName=s2vm00$i
    nicName=nicS2VM00$i

    # NIC
    azure network nic create --resource-group $rgName \
        --name $nicName \
        --subnet-name $vnSubnet2Name \
        --subnet-vnet-name $vnName \
        --location $location
    
    azure vm create --resource-group $rgName \
        --name $vmName \
        --location $location \
        --vm-size $vmSize \
        --subnet-id $vnSubnet2Name \
        --availset-name $avSetSubnet2Name \
        --nic-names $nicName \
        --os-type linux \
        --image-urn $publisher:$offer:$sku:$version \
        --storage-account-name $saSubnet2Name \
        --admin-username $username \
        --admin-password $password

done

# subnet3 VMS
#
for ((i=1;i<=nroVMsbySubnet; i++)); 
do
    # VM Name
    vmName=s3vm00$i
    nicName=nicS3VM00$i

    # NIC
    azure network nic create --resource-group $rgName \
        --name $nicName \
        --subnet-name $vnSubnet3Name \
        --subnet-vnet-name $vnName \
        --location $location
    
    azure vm create --resource-group $rgName \
        --name $vmName \
        --location $location \
        --vm-size $vmSize \
        --subnet-id $vnSubnet3Name \
        --availset-name $avSetSubnet3Name \
        --nic-names $nicName \
        --os-type linux \
        --image-urn $publisher:$offer:$sku:$version \
        --storage-account-name $saSubnet3Name \
        --admin-username $username \
        --admin-password $password

done

#
# Agregar balanceadores y cerrar
#
azure network lb create -g $rgName -n lbsubnet1External -l $location
azure network lb create -g $rgName -n lbsubnet2 -l $location
azure network lb create -g $rgName -n lbsubnet3 -l $location

echo Done!