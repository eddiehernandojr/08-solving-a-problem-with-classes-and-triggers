@isTest
// Test classes can be either private or public. 
// If you’re using a test class for unit testing only, declare it as private. 
// Public test classes are typically used for test data factory classes.
private class AccountTriggerTest {

    // Records that are created in a test setup method are available to all test methods 
    // in the test class and are rolled back at the end of test class execution. 
    // If a test method changes those records, such as record field updates or record 
    // deletions, those changes are rolled back after each test method finishes execution. 

    @isTest
    static void testCreateCampaign() {       
        List<Account> accts = addAccountRecords();

        Test.startTest();
        List<Database.SaveResult> result = Database.insert(accts, false); 
        Test.stopTest();
        
        // TODO1: add check if Campaign details are correct
        // TODO2: add more tests
        List<Campaign> camps = [SELECT Id FROM Campaign];       
        System.assertEquals(151, camps.size(), 'The actual size is ' + camps.size());
        System.assert(result[0].isSuccess());
        System.assert(result[0].getErrors().size() == 0);
    }

    @isTest
    static void testCheckRelatedOpps() {
        List<Account> accts = addAccountRecords();
        List<Opportunity> opps = new List<Opportunity>(); 

        insert accts;

        for (Account acct : accts) { 
            opps.add(new Opportunity(Name = acct.Name + 'Opportunity', 
                                StageName = 'Prospecting', 
                                CloseDate = System.today().addMonths(1), 
                                AccountId = acct.Id));
        }

        insert opps; 

        List<Account> accts1 = [SELECT Id, AnnualRevenue FROM Account];

        Test.startTest();
        List<Database.DeleteResult> result = Database.delete(accts1, false);
        Test.stopTest();

        System.assert(!result[0].isSuccess());
        System.assert(result[0].getErrors().size() > 0);
        System.assertEquals('Cannot delete account with related open opportunities.', result[0].getErrors()[0].getMessage());
    }

    static List<Account> addAccountRecords() {
        List<Account> accts = new List<Account>();

        for (Integer i = 0; i < 151; i++) {
            // TODO3: remove Type, Industry, and Phone when you move this to a new org
            accts.add(new Account(Name = 'Test Account' + i, 
                            Type = 'Prospect', 
                            Industry = 'Agriculture', 
                            Phone = '(123) 456-7890',
                            AnnualRevenue = 100000));
        }

        return accts;
    }
}
