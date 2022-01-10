trigger AccountTrigger on Account (before delete, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            AccountTriggerHandler.checkRelatedOpps(Trigger.Old, Trigger.OldMap);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.createCampaign(Trigger.New);
        }
    }
}