$OID=az ad signed-in-user show --query objectId

az deployment sub create -l westeurope -f pgen.main.bicep -p pwparam.json -p objectIDuser=$OID

$kvgen_name=az keyvault list -g pgengroup115-test --query [0].name

az deployment sub create -l westeurope -f main.bicep -p zparam.json -p kvg_name=$kvgen_name objectIDuser=$OID