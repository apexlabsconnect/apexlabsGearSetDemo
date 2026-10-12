/**
 * Test class for AccountContactService.
 * Covers: happy path, blank-name validation, and DML-error error-log capture.
 */
@IsTest
private class AccountContactServiceTest {

    // ─── Happy Path ──────────────────────────────────────────────────────────

    @IsTest
    static void shouldCreateAccountAndContact_WhenValidInput() {
        // Given
        String accountName = 'Test Corp';
        String firstName   = 'Jane';
        String lastName    = 'Doe';
        String email       = 'jane@testcorp.com';

        // When
        Test.startTest();
        Id accountId = AccountContactService.createAccountAndContact(
            accountName, firstName, lastName, email
        );
        Test.stopTest();

        // Then
        Assert.isNotNull(accountId, 'A valid Account Id should be returned');

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        Assert.areEqual(1, accounts.size(), 'Exactly one Account should exist');
        Assert.areEqual(accountName, accounts[0].Name, 'Account name should match');

        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Email, AccountId
            FROM Contact
            WHERE AccountId = :accountId
        ];
        Assert.areEqual(1, contacts.size(), 'Exactly one Contact should be created');
        Assert.areEqual(firstName, contacts[0].FirstName, 'Contact first name should match');
        Assert.areEqual(lastName,  contacts[0].LastName,  'Contact last name should match');
        Assert.areEqual(email,     contacts[0].Email,     'Contact email should match');
    }

    @IsTest
    static void shouldCreateAccountAndContact_WhenNoEmail() {
        // Given / When
        Test.startTest();
        Id accountId = AccountContactService.createAccountAndContact(
            'No Email Corp', 'John', 'Smith', null
        );
        Test.stopTest();

        // Then
        Assert.isNotNull(accountId, 'Account should be created without an email');
        List<Contact> contacts = [SELECT Email FROM Contact WHERE AccountId = :accountId];
        Assert.areEqual(1, contacts.size(), 'One Contact should be created');
        Assert.isNull(contacts[0].Email, 'Contact email should be null');
    }

    // ─── Blank-Name Validation ───────────────────────────────────────────────

    @IsTest
    static void shouldThrowException_WhenAccountNameIsBlank() {
        Test.startTest();
        try {
            AccountContactService.createAccountAndContact('', 'Jane', 'Doe', null);
            Assert.fail('Expected AccountContactServiceException for blank account name');
        } catch (AccountContactService.AccountContactServiceException e) {
            Assert.isTrue(
                e.getMessage().contains('accountName'),
                'Exception message should mention accountName'
            );
        }
        Test.stopTest();
    }

    @IsTest
    static void shouldThrowException_WhenLastNameIsBlank() {
        Test.startTest();
        try {
            AccountContactService.createAccountAndContact('Acme', 'Jane', '', null);
            Assert.fail('Expected AccountContactServiceException for blank last name');
        } catch (AccountContactService.AccountContactServiceException e) {
            Assert.isTrue(
                e.getMessage().contains('lastName'),
                'Exception message should mention lastName'
            );
        }
        Test.stopTest();
    }

    // ─── Error Log Capture ───────────────────────────────────────────────────

    @IsTest
    static void shouldLogError_WhenDmlExceptionOccurs() {
        // Simulate a DML failure by passing a Contact last name that is too long
        // (255+ chars triggers a STRING_TOO_LONG DmlException on insert).
        String tooLong = 'X'.repeat(256);

        Test.startTest();
        Id result = AccountContactService.createAccountAndContact(
            'Error Corp', 'Error', tooLong, null
        );
        Test.stopTest();

        Assert.isNull(result, 'Null should be returned when a DML error occurs');

        List<Error_Log__c> logs = [
            SELECT Error_Message__c, Exception_Type__c, Source__c,
                   Class_Name__c, Error_Date_Time__c
            FROM Error_Log__c
        ];
        Assert.areEqual(1, logs.size(), 'One Error_Log__c record should be created');
        Assert.isNotNull(logs[0].Error_Message__c,  'Error message should be populated');
        Assert.isNotNull(logs[0].Exception_Type__c, 'Exception type should be populated');
        Assert.areEqual('API', logs[0].Source__c,   'Source should be API');
        Assert.isNotNull(logs[0].Error_Date_Time__c,'Error date/time should be populated');
    }
}