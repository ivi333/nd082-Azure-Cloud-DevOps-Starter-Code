#Create the policy
az policy definition create --name tagging-policy --display-name "Require a tag on resources" --description "Enforces existence of a tag. Does not apply to resource groups." --rules azurepolicy-tag.rules.json --params azurepolicy-tag.params.json --mode All

#Show the policy
az policy definition show --name "tagging-policy"

#Set tag-policy to full subscription
az policy assignment create --name tagging-policy --display-name "Deny resource creation without a tag" --policy /subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.Authorization/policyDefinitions/tagging-policy --params azurepolicy-assignment-tag.json

#Show assignment
az policy assignment show --name tagging-policy