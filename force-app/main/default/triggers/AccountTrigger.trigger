trigger AccountTrigger on Account (after insert) {
    List<Account> accountsToUpdate = new List<Account>();

    for (Account acc : Trigger.new) {
        accountsToUpdate.add(new Account(
            Id = acc.Id,
            External_Id__c = acc.Id
        ));
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}