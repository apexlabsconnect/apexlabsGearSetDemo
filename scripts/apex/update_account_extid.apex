List<Account> accsToUpdate = [SELECT Id, External_Id__c FROM Account];
for (Account acc : accsToUpdate) {
    acc.External_Id__c = acc.Id;
}
if (!accsToUpdate.isEmpty()) {
    update accsToUpdate;
}
System.debug('Updated ' + accsToUpdate.size() + ' Account records.');
