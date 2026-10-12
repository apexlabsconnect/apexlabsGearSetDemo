public with sharing class AccountSearchController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String accountName) {

        if (String.isBlank(accountName)) {
            return new List<Account>();
        }

        return [
            SELECT Id, Name, Industry, Phone, Website
            FROM Account
            WHERE Name LIKE :('%' + accountName + '%')
            ORDER BY Name
            LIMIT 50
        ];
    }
}