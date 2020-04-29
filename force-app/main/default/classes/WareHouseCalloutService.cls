public with sharing class WareHouseCalloutService {
    
    public Static HttpResponse runWarehouseEquipmentSync()
    {
        Http httpSender = new Http();
        HttpRequest request =  new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');

        HttpResponse response = httpSender.send(request);

        if(response.getStatusCode() == 200)
        {
            updateEquipment(response.getBody());
        }
        return response;
    }

    @future(callout=true)
    public static void updateEquipment(String JSONString)
    {
        List<Equipment> lstEquipmentsFromServer = Equipment.parse(JSONString);
        Map<String,Equipment> mapExtIdToEquipmentsFromServer = new Map<String,Equipment>();
        List<Product2> lstEquipmentsToUpdate = new List<Product2>();

        //Get the external id from the equipments to update the records in the system
        for(Equipment equi : lstEquipmentsFromServer)
        {
            mapExtIdToEquipmentsFromServer.put(equi.sku,equi);
        }
        
        //Process to updta records
        for(Product2 equiExisting :     [SELECT Name,
                                                Replacement_Part__c, 
                                                Current_Inventory__c,
                                                Maintenance_Cycle__c,
                                                Lifespan_Months__c,
                                                Cost__c,
                                                Warehouse_SKU__c 
                                            FROM  Product2
                                            WHERE Warehouse_SKU__c IN: mapExtIdToEquipmentsFromServer.keySet()])
        {
            lstEquipmentsToUpdate.add(matchEquipments(equiExisting,mapExtIdToEquipmentsFromServer.get(equiExisting.Warehouse_SKU__c)));
            mapExtIdToEquipmentsFromServer.remove(equiExisting.Warehouse_SKU__c);
        }

        //Process to create records in the system
        for(Equipment equiExisting : mapExtIdToEquipmentsFromServer.values())
        {
            lstEquipmentsToUpdate.add(matchEquipments(null,equiExisting));
        }

        upsert lstEquipmentsToUpdate;
    }
    public Static Product2 matchEquipments(Product2 equipUpdate, Equipment equipFromWareHouse)
    {
        Product2 equip;

        if(equipUpdate != null)
        {
            equip = equipUpdate;
        }
        else 
        {
            equip =  new  Product2();   
        }
        
        equip.Replacement_Part__c = equipFromWareHouse.replacement;
        equip.Current_Inventory__c = equipFromWareHouse.quantity;
        equip.Name = equipFromWareHouse.name;
        equip.Maintenance_Cycle__c = equipFromWareHouse.maintenanceperiod;
        equip.Lifespan_Months__c = equipFromWareHouse.lifespan;
        equip.Cost__c = equipFromWareHouse.cost;
        equip.Warehouse_SKU__c = equipFromWareHouse.sku;
        return equip;
    }

}
