/**

* DEMO CLASS
*
* Demonstrates direct error logging without Platform Events.
*
* Flow:
* 1. Create Account
* 2. Try to create Contact
* 3. Contact insert fails
* 4. Insert Error_Log__c directly
* 5. Throw the original exception
*
* Expected result:
* The transaction is rolled back, so the Account and Error_Log__c
* records should also be rolled back.
  */
  public with sharing class AccountContactServiceDirectAttempt {

  private static final String SOURCE_APEX = 'DIRECT_ATTEMPT';
  private static final String CLASS_NAME = 'AccountContactServiceDirectAttempt';

  /**

  * Creates an Account and intentionally causes a Contact DML error.
    */
    public static Id createAccountAndContact(
    String accountName,
    String firstName,
    String lastName,
    String email
    ) {
    try {

     // Create Account successfully
     Account newAccount = new Account(
         Name = accountName
     );

     insert newAccount;

     System.debug('Account Created: ' + newAccount.Id);


     /*
      * INTENTIONALLY CAUSE AN ERROR
      *
      * Contact LastName is required.
      * We deliberately do not provide LastName.
      */
     Contact newContact = new Contact(
         FirstName = firstName,
         Email = email,
         AccountId = newAccount.Id
     );

     insert newContact;

     return newAccount.Id;

    } catch (Exception e) {

  
     System.debug('Original Error: ' + e.getMessage());

     // Directly insert the error log
     insertErrorLog(e);

     System.debug(
         'Error log insert was executed successfully.'
     );

     // Throw the original exception
     throw e;

    }
    }

  /**

  * Directly inserts the error into Error_Log__c.
    */
    private static void insertErrorLog(Exception e) {

    String stackTrace = e.getStackTraceString();

    Error_Log__c errorLog = new Error_Log__c(
    Error_Message__c = e.getMessage(),
    Exception_Type__c = e.getTypeName(),
    Line_Number__c = e.getLineNumber(),
    Stack_Trace__c = stackTrace,
    Class_Name__c = CLASS_NAME,
    Method_Name__c = 'createAccountAndContact',
    Error_Date_Time__c = System.now(),
    Related_Object__c = 'Account/Contact'//,
   // Source__c = SOURCE_APEX
    );

    insert errorLog;

    System.debug(
    'Error Log Created: ' + errorLog.Id
    );
    }
    }