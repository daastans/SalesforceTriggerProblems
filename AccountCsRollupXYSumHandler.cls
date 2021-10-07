public with sharing class AccountCsRollupXYSumHandler {
    public AccountCsRollupXYSumHandler() {

    }

    public static void AddAmount(List<Contact> newContacts){
        
        //Duplicate Code
        Set<String> reqAccIds=new Set<String>();
        
        for(Contact c: newContacts){
            reqAccIds.add(c.AccountId);
        }
        Map<Id,Account> accMap=new Map<Id,Account>([SELECT Id,Rollup_Amount__c,Rollup_Amount_X__c,Rollup_Amount_Y__c FROM Account where Id in :reqAccIds]);
        //Duplicate Code ends

        for(Contact c:newContacts){
            if(c.Type__c == 'Positive'){
                relatedAcc.Rollup_Amount_X__c+=c.Amount_X__c;                    
            }
            else if(c.Type__c == 'Negative'){
                relatedAcc.Rollup_Amount_Y__c+=c.Amount_Y__c;                    
            }
    
            relatedAcc.Rollup_Amount__c	= relatedAcc.Rollup_Amount_X__c +  relatedAcc.Rollup_Amount_Y__c;

        }

        //Duplicate Code
        if(accMap.size() > 0){
            Update accMap.values();
        }       

        
    }
    public static void UpdateAmount(Map<id,Contact> oldContactMap,List<Contact> newContacts){
        
        //Duplicate Code
        Set<String> reqAccIds=new Set<String>();
        
        for(Contact c: newContacts){
            reqAccIds.add(c.AccountId);
        }
                
        Map<Id,Account> accMap=new Map<Id,Account>([SELECT Id,Rollup_Amount__c,Rollup_Amount_X__c,Rollup_Amount_Y__c FROM Account where Id in :reqAccIds]);        
        //Duplicate code ends

        for(Contact c:Trigger.new){
        
            Contact oldContact=Trigger.oldMap.get(c.Id);
            Boolean hasTypeChanged=oldContact.Type__c == c.Type__c;

            if(hasTypeChanged && oldContact.Type__c == 'Negative'){
                relatedAcc.Rollup_Amount_Y__c-=oldContact.Amount_Y__c;
                relatedAcc.Rollup_Amount_X__c+=c.Amount_X__c;   
                }
            else if(hasTypeChanged && oldContact.Type__c == 'Positive'){
                relatedAcc.Rollup_Amount_X__c-=oldContact.Amount_X__c;
                relatedAcc.Rollup_Amount_Y__c+=c.Amount_Y__c;  
                }

                relatedAcc.Rollup_Amount__c	= relatedAcc.Rollup_Amount_X__c +  relatedAcc.Rollup_Amount_Y__c;
            }

        //Duplicate Code
        if(accMap.size() > 0){
            Update accMap.values();
        }
    }
    public static void subtractAmount(Map<id,Contact> oldContactsMap,List<Contact> oldContacts){

        List<Contact> lstAllRecords = [SELECT Id FROM Contact WHERE ID != NULL];
        Map<Id,Contact> deletedRecordsMap =new Map<Id,Contact> ([SELECT Id,FirstName,LastName,AccountId FROM Contact WHERE ID IN :oldContacts AND ID NOT IN : lstAllRecords ALL Rows]);

        //Duplicate Code
        Set<String> reqAccIds=new Set<String>();
        
        for(Contact c: deletedRecordsMap.values()){
            reqAccIds.add(c.AccountId);
        }
        

        Map<Id,Account> accMap=new Map<Id,Account>([SELECT Id,Rollup_Amount__c,Rollup_Amount_X__c,Rollup_Amount_Y__c FROM Account where Id in :reqAccIds]);
        //Duplicate Code ends


        for(Contact delC:deletedRecordsMap.values()){
            Account relatedAcc=accMap.get(delC.AccountId);

            if (delC.Type__c=='Negative') {
                relatedAcc.Rollup_Amount_Y__c-=delC.Amount_Y__c;
            }
            else if(delC.Type__c == 'Positive'){
                relatedAcc.Rollup_Amount_X__c-=delC.Amount_X__c;
            }

            relatedAcc.Rollup_Amount__c	= relatedAcc.Rollup_Amount_X__c +  relatedAcc.Rollup_Amount_Y__c;
        }

        //Duplicate Code
        if(accMap.size() > 0){
            Update accMap.values();
        }
    }

}
