global class WarehouseSyncSchedule implements Schedulable
{
    global void execute(SchedulableContext sct)
    {
        if(!Test.isRunningTest())WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}
