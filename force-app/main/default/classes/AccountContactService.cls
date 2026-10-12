/**

* Creates an Account and a related Contact in a single transaction.
*
* When an error occurs:
* 1. Error details are published to Error_Log_PE__e.
* 2. The original exception is thrown back to the caller.
* 3. The Platform Event trigger stores the error in Error_Log__c.
     */
     public with sharing class AccountContactService {

  private static final String SOURCE_APEX = 'API';
  private static final String CLASS_NAME = 'AccountContactService';

  /**

  * Creates an Account and a Contact linked to it.
  *
  * @param accountName Name for the new Account
  * @param firstName First name for the new Contact
  * @param lastName Last name for the new Contact
  * @param email Email address for the new Contact
  * @return Id of the newly created Account
    */
    public static Id createAccountAndContact(
    String accountName,
    String firstName,
    String lastName,
    String email
    ) {
    try {


     // Validation
     if (String.isBlank(accountName)) {
         throw new AccountContactServiceException(
             'accountName cannot be blank.'
         );
     }

     if (String.isBlank(lastName)) {
         throw new AccountContactServiceException(
             'lastName cannot be blank.'
         );
     }

     // Create Account
     Account newAccount = new Account(
         Name = accountName
     );

     Database.insert(newAccount, AccessLevel.USER_MODE);

     // Create Contact
     Contact newContact = new Contact(
         FirstName = firstName,
         LastName = lastName,
         Email = String.isBlank(email) ? null : email,
         AccountId = newAccount.Id
     );

     Database.insert(newContact, AccessLevel.USER_MODE);

     return newAccount.Id;
  

    } catch (Exception e) {

    
     // Publish error details to Platform Event
     publishError(
         e,
         'createAccountAndContact',
         null,
         'Account/Contact'
     );

     // Throw the original error back to the caller/user
     throw e;
   

    }
    }

  /**

  * Publishes error information to Error_Log_PE__e.
    */
    private static void publishError(
    Exception e,
    String methodName,
    Id relatedId,
    String relatedObject
    ) {
    try {

 
     String stackTrace = e.getStackTraceString();

     Error_Log_PE__e errorEvent = new Error_Log_PE__e(
         Error_Message__c = e.getMessage(),
         Exception_Type__c = e.getTypeName(),
         Line_Number__c = e.getLineNumber(),
         Stack_Trace__c = stackTrace,
         Class_Name__c = parseClassName(stackTrace),
         Method_Name__c = methodName,
         Error_Date_Time__c = System.now(),
         User_Id__c = UserInfo.getUserId(),
         Related_Record_Id__c =
             relatedId != null
                 ? String.valueOf(relatedId)
                 : null,
         Related_Object__c = relatedObject,
         Source__c = SOURCE_APEX
     );

     EventBus.publish(errorEvent);
    

    } catch (Exception loggingException) {

   
     /*
      * Do not replace the original business exception
      * with a logging exception.
      */
     System.debug(
         'Error while publishing error event: ' +
         loggingException.getMessage()
     );
   

    }
    }

  /**

  * Parses the class name from the stack trace.
    */
    private static String parseClassName(String stackTrace) {

    if (String.isBlank(stackTrace)) {
    return CLASS_NAME;
    }

    try {


     String firstLine = stackTrace.split('\n')[0];

     List<String> parts = firstLine.split('\\.');

     if (parts.size() >= 2) {
         return parts[1];
     }


    } catch (Exception e) {
    // Fall back to default class name
    }

    return CLASS_NAME;
    }

  /**

  * Custom exception for AccountContactService validation errors.
    */
    public class AccountContactServiceException extends Exception {}
    }