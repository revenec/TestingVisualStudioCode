trigger MaintenanceRequest on Case (after update) {

    MaintenanceRequestHelper.updateWorkOrders(Trigger.old,Trigger.new);
    system.debug('test');
    system.debug('test');
    system.debug('test');
}