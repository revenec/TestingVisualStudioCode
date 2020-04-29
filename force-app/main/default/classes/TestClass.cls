@isTest(seeAllData=true)
public class TestClass {
    
    @isTest
    static void TestTriggerTypeClose()
    {
        List<Case> lstCases = [SELECT Id FROM Case];

        Case caseTest = [SELECT Id, Type, Status FROM Case WHERE Status <> 'Closed' AND (Type = 'Routine Maintenance' OR Type = 'Repair') limit 1];
        system.debug(caseTest);
        caseTest.Status = 'Closed';
        
        //Create work orders
        Work_Part__c workPart = new Work_Part__c();
        workPart.Maintenance_Request__c = caseTest.Id;
        workPart.Quantity__c = 5;
        workPart.Equipment__c = [SELECT Id FROM Product2 WHERE Maintenance_Cycle__c != null AND Replacement_Part__c = true limit 1].Id;
        insert workPart;

        Test.startTest();
            update caseTest;
        Test.stopTest();
        
        List<Case> lstCasesAfter = [SELECT Id FROM Case];

        System.assert(lstCases.size() + 1 == lstCasesAfter.size());
    }

    static void TestTriggerTypeNew()
    {
        List<Case> lstCases = [SELECT Id FROM Case];

        Case caseTest = [SELECT Id, Type, Status FROM Case WHERE Status <> 'Closed' AND Type != 'Routine Maintenance' AND Type != 'Repair' limit 1];
        system.debug(caseTest);
        caseTest.Status = 'New';

        Test.startTest();
            update caseTest;
        Test.stopTest();
        
        List<Case> lstCasesAfter = [SELECT Id FROM Case];

        System.assert(lstCases.size() == lstCasesAfter.size());
    }

}
