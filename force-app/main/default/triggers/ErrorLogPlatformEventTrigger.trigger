trigger ErrorLogPlatformEventTrigger on Error_Log_PE__e (after insert) {
    
    
    List<Error_Log__c> errorLogs = new List<Error_Log__c>();
    
    for (Error_Log_PE__e errorEvent : Trigger.new) {
        
        Error_Log__c errorLog = new Error_Log__c(
            Error_Message__c = errorEvent.Error_Message__c,
            Exception_Type__c = errorEvent.Exception_Type__c,
            Line_Number__c = errorEvent.Line_Number__c,
            Stack_Trace__c = errorEvent.Stack_Trace__c,
            Class_Name__c = errorEvent.Class_Name__c,
            Method_Name__c = errorEvent.Method_Name__c,
            Error_Date_Time__c = errorEvent.Error_Date_Time__c,
            Related_Record_Id__c = errorEvent.Related_Record_Id__c,
            Related_Object__c = errorEvent.Related_Object__c,
            Source__c = errorEvent.Source__c
        );
        
        // User_Id__c on PE is Text(18)
        // User__c on Error_Log__c is assumed to be Lookup(User)
        if (!String.isBlank(errorEvent.User_Id__c)) {
            errorLog.User__c = errorEvent.User_Id__c;
        }
        
        errorLogs.add(errorLog);
    }
    
    if (!errorLogs.isEmpty()) {
        insert errorLogs;
    }
    
    
}