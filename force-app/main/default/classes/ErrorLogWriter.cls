/**
 * Isolated without-sharing helper that persists Error_Log__c records.
 * Keeping elevated access in its own class limits the scope of privilege
 * escalation — the caller (AccountContactService) runs with sharing.
 */
public without sharing class ErrorLogWriter {

    /**
     * Inserts a single Error_Log__c record.
     * Failures are swallowed to prevent error-logging from masking the
     * original exception in the calling transaction.
     *
     * @param errorLog  The pre-populated Error_Log__c record to insert
     */
    public static void insertLog(Error_Log__c errorLog) {
        if (errorLog == null) {
            return;
        }
        try {
            insert errorLog; // NOPMD: intentional without sharing for audit logging
        } catch (Exception ex) {
            // Intentionally swallowed — error logging must never surface and
            // mask the original exception in the calling transaction.
            String swallowed = ex.getMessage();
        }
    }
}