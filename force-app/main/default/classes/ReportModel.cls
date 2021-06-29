public with sharing class ReportModel {
    public String user{get; set;}
    public List<ServiceContract> serviceContracts{get; set;} 
    public Integer servContractCount {get;set;}
    public Decimal salesCommissionSum {get;set;}
    public Integer commissionAdvanceSum {get;set;}
    public Decimal netCommissionTot {get;set;}


    public ReportModel(String user, List<ServiceContract> sc, Integer servContractCount, Decimal salesCommissionSum, Integer commissionAdvanceSum, Decimal netCommissionTot) {
        this.serviceContracts = new List<ServiceContract>(sc);
        this.user = user;
        this.servContractCount = servContractCount;
        this.salesCommissionSum = salesCommissionSum;
        this.commissionAdvanceSum = commissionAdvanceSum;
        this.netCommissionTot = netCommissionTot;
    }
}