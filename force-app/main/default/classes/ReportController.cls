public with sharing class ReportController {
     
    // List<User> users = [SELECT Id, Name FROM User WHERE Name != null ];
    // List<ServiceContract> serviceContracts = [SELECT Name, Commission_Advance__c, Commission__c	, Owner_Name__c, Sales_Commission__c, Net_Commission__c FROM ServiceContract  WHERE Commission_Date__c = LAST_N_MONTHS:12 LIMIT 1000 ];

    private List<ServiceContract> userServiceContracts = new List<ServiceContract>();
    public List<ReportModel> model{get; set;}
    Integer count {get;set;}
    public Integer userCount {get;set;}
    Decimal salesCommissionSum {get;set;}
    Integer commissionAdvanceSum {get;set;}
    Decimal netCommissionTot {get;set;}
    Decimal decCommAdvSum {get;set;}
    public Date initialDate {get;set;}
    public Date endDate {get;set;}
    public ApexPages.StandardController stdCntrlr {get; set;}
    private final ServiceContract myServContract;


    public ReportController(ApexPages.StandardController controller){
        stdCntrlr = controller;
        this.myServContract =(ServiceContract)stdCntrlr.getRecord();
    }
    public Pagereference CreateReport(){
        PageReference pdf = Page.ReportLayout;
        
        List<User> users = [SELECT Id, Name FROM User WHERE Name != null ];
        List<ServiceContract> serviceContracts = [SELECT Name, Commission_Advance__c, Commission__c	, Owner_Name__c, Sales_Commission__c, Net_Commission__c FROM ServiceContract
        WHERE  Commission_Date__c >:initialDate AND Commission_Date__c <:endDate LIMIT 1000];
        System.debug(serviceContracts.size());
        model = new List<ReportModel>();
        count = 0;
        salesCommissionSum = 0;
        userCount = 0;
        commissionAdvanceSum = 0;
        decCommAdvSum =0; 
        netCommissionTot = 0;
        for(User u: users){
            for(ServiceContract sc : serviceContracts){
                if(u.Name == sc.Owner_name__c){
                    if (sc.Sales_Commission__c == null) {
                        sc.Sales_Commission__c = 0;
                    }
                    if (sc.Commission_Advance__c == null) {
                        sc.Commission_Advance__c = 0;
                    }
                    
                    count ++;
                    userServiceContracts.add(sc);
                    salesCommissionSum = salesCommissionSum + sc.Sales_Commission__c;
                    decCommAdvSum = decCommAdvSum + sc.Commission_Advance__c;
                    netCommissionTot = netCommissionTot + sc.Net_Commission__c;
                    System.debug('SALES COMMISSION SUM -->'+ salesCommissionSum);
                    System.debug('COMMISSION ADVANCE SUM -->'+ commissionAdvanceSum);
                }
                commissionAdvanceSum = Integer.valueOf(decCommAdvSum);
            }
            if(userServiceContracts.size() > 0){
                userCount++;
                model.add(new ReportModel(u.Name, userServiceContracts, count, salesCommissionSum, commissionAdvanceSum, netCommissionTot));
            }
            
            userServiceContracts.clear();
            count = 0; 
            // userCount = 0;     
            salesCommissionSum = 0;
            commissionAdvanceSum = 0;
            decCommAdvSum =0;
            netCommissionTot = 0;
        }
        return new PageReference('/apex/ReportLayout');
    }
}