/**
 * Routes all Account trigger events to the appropriate AccountService methods.
 * Add new context methods here as business requirements grow; keep each method
 * free of inline SOQL/DML — delegate those to AccountService.
 */
public with sharing class AccountTriggerHandler {

    // ─── Before Contexts ─────────────────────────────────────────────────

    /**
     * Called from AccountTrigger before insert.
     * @param newAccounts Trigger.new — records being inserted (no Id yet)
     */
    public void beforeInsert(List<Account> newAccounts) {
        // Reserved for future before-insert logic (e.g. field defaults, validation)
    }

    /**
     * Called from AccountTrigger before update.
     * @param newAccounts Trigger.new
     * @param oldAccountMap Trigger.oldMap
     */
    public void beforeUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        // Reserved for future before-update logic
    }

    /**
     * Called from AccountTrigger before delete.
     * @param oldAccounts Trigger.old
     * @param oldAccountMap Trigger.oldMap
     */
    public void beforeDelete(List<Account> oldAccounts, Map<Id, Account> oldAccountMap) {
        // Reserved for future before-delete logic
    }

    // ─── After Contexts ──────────────────────────────────────────────────

    /**
     * Called from AccountTrigger after insert.
     * Creates a default Contact for every newly inserted Account.
     * @param newAccounts Trigger.new — records now have Ids
     * @param newAccountMap Trigger.newMap
     */
    public void afterInsert(List<Account> newAccounts, Map<Id, Account> newAccountMap) {
        AccountService.createContactsForAccounts(newAccounts);
    }

    /**
     * Called from AccountTrigger after update.
     * @param newAccounts Trigger.new
     * @param oldAccountMap Trigger.oldMap
     */
    public void afterUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        // Reserved for future after-update logic
    }

    /**
     * Called from AccountTrigger after delete.
     * @param oldAccounts Trigger.old
     * @param oldAccountMap Trigger.oldMap
     */
    public void afterDelete(List<Account> oldAccounts, Map<Id, Account> oldAccountMap) {
        // Reserved for future after-delete logic
    }

    /**
     * Called from AccountTrigger after undelete.
     * @param newAccounts Trigger.new
     * @param newAccountMap Trigger.newMap
     */
    public void afterUndelete(List<Account> newAccounts, Map<Id, Account> newAccountMap) {
        // Reserved for future after-undelete logic
    }
}