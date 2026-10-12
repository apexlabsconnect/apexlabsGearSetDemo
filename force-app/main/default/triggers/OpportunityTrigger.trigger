trigger OpportunityTrigger on Opportunity (after insert) {
    List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

    for (Opportunity opp : Trigger.new) {
        opportunitiesToUpdate.add(new Opportunity(
            Id = opp.Id,
            External_Id__c = opp.Id
        ));
    }

    if (!opportunitiesToUpdate.isEmpty()) {
        update opportunitiesToUpdate;
    }
}
