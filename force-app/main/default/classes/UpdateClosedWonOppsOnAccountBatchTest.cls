@IsTest
private class UpdateClosedWonOppsOnAccountBatchTest {
    @IsTest
    static void batchUpdatesClosedWonCountOnAccounts() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Acme Corp'),
            new Account(Name = 'Blue Peak')
        };
        insert accounts;

        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Name = 'Acme Won 1',
                AccountId = accounts[0].Id,
                StageName = 'Closed Won',
                CloseDate = Date.today()
            ),
            new Opportunity(
                Name = 'Acme Won 2',
                AccountId = accounts[0].Id,
                StageName = 'Closed Won',
                CloseDate = Date.today()
            ),
            new Opportunity(
                Name = 'Acme Lost',
                AccountId = accounts[0].Id,
                StageName = 'Closed Lost',
                CloseDate = Date.today()
            ),
            new Opportunity(
                Name = 'Blue Peak Won',
                AccountId = accounts[1].Id,
                StageName = 'Closed Won',
                CloseDate = Date.today()
            ),
            new Opportunity(
                Name = 'Blue Peak Open',
                AccountId = accounts[1].Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            )
        };
        insert opps;

        Test.startTest();
        Database.executeBatch(new UpdateClosedWonOppsOnAccountBatch(), 200);
        Test.stopTest();

        Account acme = [
            SELECT Closed_Won_Opportunities__c
            FROM Account
            WHERE Id = :accounts[0].Id
            LIMIT 1
        ];

        Account bluePeak = [
            SELECT Closed_Won_Opportunities__c
            FROM Account
            WHERE Id = :accounts[1].Id
            LIMIT 1
        ];

        System.assertEquals(2, acme.Closed_Won_Opportunities__c,
            'Acme should have 2 closed-won opportunities.');
        System.assertEquals(1, bluePeak.Closed_Won_Opportunities__c,
            'Blue Peak should have 1 closed-won opportunity only.');
    }
}