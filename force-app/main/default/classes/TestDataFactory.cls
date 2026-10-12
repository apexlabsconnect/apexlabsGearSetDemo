/**
 * Centralised test data factory. All @TestSetup methods delegate here.
 */
@IsTest
public class TestDataFactory {

    /**
     * Creates Account records.
     * @param count   Number of accounts to create
     * @param doInsert  Whether to insert into the database
     * @return List of Account records
     */
    public static List<Account> createAccounts(Integer count, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        if (doInsert) {
            insert accounts;
        }
        return accounts;
    }

    /**
     * Creates Contact records linked to the provided Account.
     * @param accountId  Parent Account Id
     * @param count      Number of contacts to create
     * @param doInsert   Whether to insert into the database
     * @return List of Contact records
     */
    public static List<Contact> createContacts(Id accountId, Integer count, Boolean doInsert) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                FirstName = 'First ' + i,
                LastName  = 'Last ' + i,
                AccountId = accountId
            ));
        }
        if (doInsert) {
            insert contacts;
        }
        return contacts;
    }
}