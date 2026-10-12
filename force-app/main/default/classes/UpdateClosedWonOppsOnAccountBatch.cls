public with sharing class UpdateClosedWonOppsOnAccountBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id
            FROM Account
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }

        Map<Id, Integer> closedWonCountByAccountId = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT AccountId accId, COUNT(Id) oppCount
            FROM Opportunity
            WHERE AccountId IN :accountIds
                AND IsClosed = true
                AND IsWon = true
            GROUP BY AccountId
        ]) {
            closedWonCountByAccountId.put(
                (Id) ar.get('accId'),
                Integer.valueOf(ar.get('oppCount'))
            );
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : scope) {
            Integer closedWonCount = closedWonCountByAccountId.containsKey(acc.Id)
                ? closedWonCountByAccountId.get(acc.Id)
                : 0;

            accountsToUpdate.add(
                new Account(
                    Id = acc.Id,
                    Closed_Won_Opportunities__c = closedWonCount
                )
            );
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: add notifications/logging if needed.
    }
}