public with sharing class MaintenanceRequestHelper
{

    public static void updateWorkOrders(List<Case> lstPreviousCases, List<Case> lstNewCases)
    {
        Set<String> setValidTypes = new Set<String>{'Routine Maintenance','Repair'};
        Map<Id,Case> mapCaseIdToPreviousCaseValues = new Map<Id,Case>();
        Map<Id,Case> mapCaseIdToCasesToInsert = new Map<Id,Case>();
        Case caseToAdd;
        Set<String> setCasesIds = new Set<String>();
        
        System.debug('Login details test for merge classes');
        //Get the previous values
        for(Case caseOld : lstPreviousCases)
        {
            mapCaseIdToPreviousCaseValues.put(caseOld.Id, caseOld);
        }

        System.debug('Test level 22');
        for(Case caseUse : lstNewCases)
        {
            System.debug('Test example');
            if(setValidTypes.contains(caseUse.Type) && 
               caseUse.Status.equals('Closed') && 
               mapCaseIdToPreviousCaseValues.get(caseUse.Id) != null &&
               !'Closed'.equals(mapCaseIdToPreviousCaseValues.get(caseUse.Id).Reason))
            {
                caseToAdd = new Case();
                caseToAdd.Vehicle__c = caseUse.Vehicle__c;
                caseToAdd.Equipment__c = caseUse.Equipment__c;
                caseToAdd.Date_Reported__c = Date.today();
                caseToAdd.Subject = caseUse.Subject + ' (Follow Up)';
                caseToAdd.Type = 'Routine Maintenance';
                caseToAdd.Date_Due__c = null;
                mapCaseIdToCasesToInsert.put(caseUse.Id,caseToAdd);
                setCasesIds.add(caseUse.Id);
            }
        }
        
        //Get the due date for life cyrcle
        for(Work_Part__c workPart : [SELECT Id, Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c 
                                    FROM Work_Part__c 
                                    WHERE Maintenance_Request__c IN: setCasesIds])
        {
            if(mapCaseIdToCasesToInsert.get(workPart.Maintenance_Request__c) != null)
            {
                Case caseTemp = mapCaseIdToCasesToInsert.get(workPart.Maintenance_Request__c);
                Date DateDue = workPart.Equipment__r.Maintenance_Cycle__c != null ? Date.today().AddDays((Integer) workPart.Equipment__r.Maintenance_Cycle__c) : null;
                
                if((caseTemp.Date_Due__c == null && DateDue != null) || (caseTemp.Date_Due__c != null && DateDue != null && DateDue < caseTemp.Date_Due__c))
                {
                    caseTemp.Date_Due__c = DateDue;
                    mapCaseIdToCasesToInsert.put(workPart.Maintenance_Request__c, caseTemp);
                }
            }
        }

        if(!mapCaseIdToCasesToInsert.isEmpty()){insert mapCaseIdToCasesToInsert.values();}
    }
}
