public class CreateSecondContactJob implements Queueable {

    private Id accountId;

    public CreateSecondContactJob(Id accountId) {
        this.accountId = accountId;
    }

    public void execute(QueueableContext context) {

        Account acc = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        Contact con = new Contact();

        con.FirstName = 'Second';
        con.LastName = 'Queueable';
        con.AccountId = acc.Id;

        insert con;

        System.debug(
            'Second Queueable Contact created: ' + con.Id
        );
    }
}