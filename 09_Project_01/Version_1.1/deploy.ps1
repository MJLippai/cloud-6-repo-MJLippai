$OID=az ad signed-in-user show --query objectId

az deployment sub create -l westeurope -f main.bicep -p zparam.json -p objectIDuser=$OID
