trigger ContactTriggerForAccount on Contact (after insert, after update, after delete, after undelete) {
    
    Set<Id> accountIds = new Set<Id>();
    
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
        for (Contact con: Trigger.new){
            accountIds.add(con.AccountId);   
        }
    }
    
    if(Trigger.IsUpdate || Trigger.isDelete){
        for (Contact con: Trigger.Old){
            accountIds.add(con.AccountId);   
        }
    }
    Map<Id, Integer> contactCountMap = new Map<id, Integer>();
    List<Account> listToUpdate = new List<Account>();
    
    for (AggregateResult ar : [
        SELECT AccountId, COUNT(Id) contactCount
        FROM Contact
        WHERE AccountId IN :accountIds
        GROUP BY AccountId
    ]) {
        contactCountMap.put(
            (Id) ar.get('accountId'),
            (Integer) ar.get('contactCount')
        );
    }
    
    
    for (Id accId: accountIds){
        Account acc = new Account (Id = accId);
        acc.Number_of_Contacts__c = contactCountMap.get(accId);
        listToUpdate.add(acc);
    }
    
    update listToUpdate;
    
}