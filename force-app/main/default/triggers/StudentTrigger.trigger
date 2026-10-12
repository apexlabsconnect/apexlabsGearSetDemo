trigger StudentTrigger on Student__c (before insert) {

    for (Student__c student: Trigger.new){
        if(student.Total_Marks__c < 40){
            student.Status__c = 'Fail';
        }
        else{
            student.Status__c = 'Pass';
        }
    }
}