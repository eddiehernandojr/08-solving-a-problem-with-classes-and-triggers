public class AccountTriggerHandler {
    public static void createCampaign(List<Account> newList) {
        List<Campaign> camps = new List<Campaign>();

        for (Account acct : newList) {
            if (acct.AnnualRevenue > 0) {
                camps.add(new Campaign(Name = 'Webinar for New Customer', 
                                    Type = 'Webinar', 
                                    Status = 'Planned', 
                                    StartDate = Date.today() + 14, 
                                    EndDate = Date.today() + 14, 
                                    IsActive = true, 
                                    BudgetedCost = acct.AnnualRevenue * 0.01));
            }
        }

        insert camps;
    }

    public static void checkRelatedOpps(List<Account> old, Map<Id, Account> oldMap) {
        for (Account acct : [SELECT Id FROM Account 
                            WHERE Id IN (SELECT AccountId FROM Opportunity)     
                            AND Id IN :old]) {
            oldMap.get(acct.Id).addError('Cannot delete account with related open opportunities.');
        }
    }
}
