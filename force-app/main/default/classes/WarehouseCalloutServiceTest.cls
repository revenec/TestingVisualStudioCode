@isTest(seeAllData=true)
public with sharing class WarehouseCalloutServiceTest {
    @isTest
    static void test() {
        
        Integer EquipmentBeforeTest = [SELECT Id FROM Product2].size();

        Test.setMock(HttpCalloutMock.class, new WareHouseCalloutServiceMock());
        
        Test.startTest();
            HttpResponse result = WareHouseCalloutService.runWarehouseEquipmentSync();
            WareHouseCalloutServiceMock mock = new WareHouseCalloutServiceMock();
            WareHouseCalloutService.updateEquipment(mock.respond(null).getBody());
        Test.stopTest();
        
        Integer EquipmentAfterTest = [SELECT Id FROM Product2].size();

        System.assert(EquipmentBeforeTest != EquipmentAfterTest);
    }
}
