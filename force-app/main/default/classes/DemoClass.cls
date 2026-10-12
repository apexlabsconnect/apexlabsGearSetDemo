public class DemoClass {
    
    public void demoMethod(){
        system.debug('This is a Test');
        //ChildClass.insertAccount();
        //List Set Map
        /*List<Account> listToInsert = new List<Account>();
for (integer i = 0; i<= 2; i++){
Account acc = new Account();
acc.Name = 'Test Account' + ' '+ String.valueof(System.now());
listToInsert.add(acc);
}

if(!listToInsert.isEmpty()){
insert listToInsert;
}*/
        
        List<String> sampleList = new List<String>();
        sampleList.add('Ram');
        sampleList.add('Shyam');
        sampleList.add('Shyam');
        // System.debug(sampleList);
        
        Set<String> sampleSet = new Set<String>();
        sampleSet.add('Ram');
        sampleSet.add('Shyam');
        sampleSet.add('Shyam');
        //System.debug(sampleSet);
        
        //Key Value pair
        Map<String, Integer> mapStringNum = new Map<String, Integer>();
        mapStringNum.put('Ram', 1);
        mapStringNum.put('Shyam', 2);
        //System.debug(mapStringNum);
        
        System.debug(mapStringNum.get('Ram'));
        
        boolean containsAValue = mapStringNum.containsKey('Shivam');
        System.debug(containsAValue);
        
        
    }
}