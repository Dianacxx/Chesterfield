public with sharing class myController {
    public List<User> users {get;set;}
    public List<User> displayUsers{get;set;}
    public List<ServiceContract> allServiceContracts{get;set;}
    public List<ServiceContract> displayServiceContracts{get;set;}
    List<ServiceContract> relatedServiceContracts{get;set;}
    public List<ServiceContract> displayRelatedServiceContracts{get;set;}
    Map<String, Schema.SObjectField> userfieldMap = User.sObjectType.getDescribe().fields.getMap();
    Map<String, Schema.SObjectField> servContractfieldMap = ServiceContract.sObjectType.getDescribe().fields.getMap();
    List<String> userFieldNames = new List<String>(userfieldMap.keySet());
    List<String> servContractFieldNames = new List<String>(servContractfieldMap.keySet());
    String isActive = 'Active';


    public myController(){
        String userQuery= 'SELECT '+String.join(userFieldNames, ',')+' FROM User WHERE Name != null ';
        String servContractQuery = 'SELECT ' +String.join(servContractFieldNames, ',')+ ' FROM ServiceContract WHERE Sales_Commission__c != null AND Status = :isActive AND OwnerId !=null';
        allServiceContracts = Database.query(servContractQuery); 
        users = Database.query(userQuery);   
        displayUsers = new List<User>(users);


        for (User user : users) {
                relatedServiceContracts = new List<ServiceContract>();
                System.debug('This are the users --> ' + user.Id);
                for (ServiceContract sc : allServiceContracts) {
                    if (sc.OwnerId==user.Id) {
                        

                        relatedServiceContracts.add(sc);
                    }
                    System.debug('this is the owner --> ' + sc.OwnerId + 'and this is the user--> ' + user.Id);
                }
                System.debug(relatedServiceContracts);
             
                if (relatedServiceContracts != null) {
                    displayRelatedServiceContracts = new List<ServiceContract>(relatedServiceContracts);
                    
                }    
            }
            
    
    }




    
}
