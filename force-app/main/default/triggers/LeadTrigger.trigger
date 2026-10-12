trigger LeadTrigger on Lead (after insert) {
    
    if (Trigger.isAfter && Trigger.isInsert) {
        try{
            ApexLabsLeadEmailService.sendNewLeadEmails(Trigger.new);  
        }
        catch (Exception e){
            System.debug('e.getMessage:'+ e.getMessage());
        }
    }
}