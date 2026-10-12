/**
 * Test class for ErrorLogWriter.
 * Covers: null guard, successful insert, and swallowed exception paths.
 */
@IsTest
private class ErrorLogWriterTest {

    @IsTest
    static void shouldDoNothing_WhenNullLogPassed() {
        // Given / When — should not throw
        Test.startTest();
        ErrorLogWriter.insertLog(null);
        Test.stopTest();

        // Then — no record inserted
        Assert.areEqual(0, [SELECT COUNT() FROM Error_Log__c], 'No log should be created for null input');
    }

    @IsTest
    static void shouldInsertLog_WhenValidRecordPassed() {
        // Given
        Error_Log__c log = new Error_Log__c(
            Error_Message__c   = 'Test error',
            Exception_Type__c  = 'System.DmlException',
            Error_Date_Time__c = System.now(),
            Source__c          = 'API'
        );

        // When
        Test.startTest();
        ErrorLogWriter.insertLog(log);
        Test.stopTest();

        // Then
        List<Error_Log__c> inserted = [SELECT Id, Error_Message__c FROM Error_Log__c];
        Assert.areEqual(1, inserted.size(), 'Exactly one Error_Log__c should be inserted');
        Assert.areEqual('Test error', inserted[0].Error_Message__c, 'Error message should match');
    }

    @IsTest
    static void shouldSwallowException_WhenInsertFails() {
        // Given — insert a record first, then pass the same instance again
        // so the second insert hits a duplicate Id DML error
        Error_Log__c log = new Error_Log__c(
            Error_Message__c   = 'Dup error',
            Exception_Type__c  = 'System.DmlException',
            Error_Date_Time__c = System.now(),
            Source__c          = 'API'
        );
        insert log;

        // Re-use the same SObject instance (already has an Id) — insert will throw
        Test.startTest();
        ErrorLogWriter.insertLog(log);
        Test.stopTest();

        // Then — should not throw; record count stays at 1
        Assert.areEqual(1, [SELECT COUNT() FROM Error_Log__c], 'Record count should remain 1 after swallowed exception');
    }
}