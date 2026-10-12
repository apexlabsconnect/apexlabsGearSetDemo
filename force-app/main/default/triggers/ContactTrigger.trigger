trigger ContactTrigger on Contact (before insert, before update, before delete, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            Set<Id> accountIds = new Set<Id>();

            for (Contact c : Trigger.new) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }

            Map<Id, Account> accountMap = new Map<Id, Account>([
                SELECT Id, Industry
                FROM Account
                WHERE Id IN :accountIds
            ]);

            for (Contact con : Trigger.new) {
                if (con.AccountId != null && accountMap.containsKey(con.AccountId)) {
                    con.Industry__c = accountMap.get(con.AccountId).Industry;
                }
            }
        } else if (Trigger.isDelete) {
            for (Contact c : Trigger.old) {
                c.addError('You cannot delete the record');
            }
        }
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Contact con : Trigger.new) {
            contactsToUpdate.add(new Contact(
                Id = con.Id,
                External_Id__c = con.Id
            ));
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}