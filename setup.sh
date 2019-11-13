#!/bin/bash

# Setup script for altizator.js server(less) end
# Version 0.1
#
# Author Christopher Frenning chfrenni@microsoft.com @chrfrenning
# Open Source github.com/chrfrenning/altizator - see repo for license
#
# Notes: This is an early version and has [many|some|unknown] issues
#
# TODO: Parameterize resource group name and location of services
# TODO: Split resource group name and resource name vars into two separate vars
# NOTE: Adding random part to resource and rg names to hope for global uniqueness

# Create random number for resource creation
# TODO: More parameterization of the setup should happen here, which resources to create?
# Keeping this at the beginning of the script to make basic customization easy
rnd=$(cut -c1-6 /proc/sys/kernel/random/uuid)
rgn=altizator00$rnd
location=westeurope

# Ensure we have the right resource providers
# TODO: Enumerate all we're using and list here
# We may need a mechanism to wait for them all to complete before proceeding
az provider register --namespace Microsoft.DocumentDB
az provider register --namespace Microsoft.CognitiveServices
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.Storage

# Time to get going and do some real stuff!
echo Deploying altizator Resources
az group create --location $location --name $rgn

# Create storage account
# This is used to host a static website with the altizator.js script
az storage account create -n $rgn -g $rgn --sku "Standard_LRS" --location $location --kind "StorageV2" --access-tier "Hot"

storageKey=$(az storage account keys list -n $rgn -g $rgn --query "[?keyName=='key1'].value" -o tsv)
echo StorageKey: $storageKey
# TODO: Create static website and deploy javascript file

# TODO: Create and connect a CDN to this to ensure global scale

# Create CosmosDB
# Now creating single region storage, expand to use RAGRS and set up alt endpoint in CDN for failover
az cosmosdb create -n $rgn -g $rgn --locations regionName=$location failoverPriority=0 isZoneRedundant=False --default-consistency-level "Eventual"

cosmosKey=$(az cosmosdb keys list -n $rgn -g $rgn --query "primaryMasterKey" -o tsv)
echo CosmosKey: $cosmosKey

# Create cognitive services
az cognitiveservices account create --name $rgn --resource-group $rgn --kind CognitiveServices --sku S0 --location $location

cognitiveServicesKey=$(az cognitiveservices account keys list -n yapp00c88dc6 -g yapp00c88dc6 --query "key1" -o tsv)
echo CognitiveKey: $cognitiveServicesKey

# TODO: Deploy and configure Azure Functions
# TODO: Add Functions behind CDN for failover
