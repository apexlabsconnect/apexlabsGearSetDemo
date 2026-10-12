public class ChildClass {
    
    public static void insertAccount(){
        Account acc = new Account();
        acc.Name = 'Test Account' + ' '+ String.valueof(System.now());
        insert acc;
        System.debug(acc.Id);
    }
}