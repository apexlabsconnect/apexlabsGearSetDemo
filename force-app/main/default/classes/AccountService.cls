/**
 * Service class for Account business logic.
 * Delegates all persistence operations (DML) here; no SOQL/DML in handler or trigger.
 */
public with sharing class AccountService {

    private static final String ERROR_NULL_INPUT = 'Account list cannot be null or empty.';
    private static final String DEFAULT_CONTACT_FIRST_NAME = 'Primary';

    // ─── Public API ──────────────────────────────────────────────────────

    /**
     * Creates one default Contact per Account in the provided list.
     * Designed to run from the after-insert trigger context where Account Ids are available.
     * Bulkified: a single DML statement inserts all contacts.
     *
     * @param accounts List of newly inserted Account records (Trigger.new from after insert)
     * @throws AccountServiceException if the DML insert fails
     * @example
     * // Called automatically via AccountTriggerHandler.afterInsert
     * AccountService.createContactsForAccounts(Trigger.new);
     */
    public static void createContactsForAccounts(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return;
        }

        List<Contact> contactsToInsert = new List<Contact>();

        for (Account account : accounts) {
            contactsToInsert.add(buildDefaultContact(account));
        }

        try {
            insert contactsToInsert;
        } catch (DmlException e) {
            throw new AccountServiceException(
                'Failed to create Contacts for Accounts: ' + e.getMessage(),
                e
            );
        }
    }

    // ─── Private Helpers ─────────────────────────────────────────────────

    /**
     * Constructs a default Contact linked to the given Account.
     * Override field defaults here as business needs evolve.
     *
     * @param account The parent Account record
     * @return A new unsaved Contact record
     */
    private static Contact buildDefaultContact(Account account) {
        return new Contact(
            FirstName   = DEFAULT_CONTACT_FIRST_NAME,
            LastName    = account.Name,
            AccountId   = account.Id,
            //Email       = account.Email__c != null ? account.Email__c : null,
            Phone       = account.Phone
        );
    }

    // ─── Exception ───────────────────────────────────────────────────────

    /**
     * Custom exception for AccountService errors.
     */
    public class AccountServiceException extends Exception {}
}