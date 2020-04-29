@isTest
public with sharing class WarehouseSyncScheduleTest {
   
    @isTest
    static void test()
    {
        WarehouseSyncSchedule testSchedule = new WarehouseSyncSchedule();
        
        Test.startTest();
            String testJobId = system.schedule('ScheduleApexTest', '0 0 0 1 * ? 2022', testSchedule);
        Test.stopTest();
        System.assert(testJobId != null);
    }
}
