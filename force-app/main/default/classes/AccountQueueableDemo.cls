public class AccountQueueableDemo implements Queueable {

    private Id accountId;

    public AccountQueueableDemo(Id accountId) {
        this.accountId = accountId;
    }

    public void execute(QueueableContext context) {

        Account acc = [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        Contact con = new Contact();

        con.FirstName = 'Queueable';
        con.LastName = 'Demo';
        con.AccountId = acc.Id;
        con.Phone = acc.Phone;

        insert con;

        System.debug(
            'First Contact created: ' + con.Id
        );

        // Chain another Queueable job
        System.enqueueJob(
            new CreateSecondContactJob(accountId)
        );
    }
}