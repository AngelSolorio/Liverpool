//
//  Session.m
//  CardReader
//


#import "Session.h"


@implementation Session
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
	}
    
    return self;
}
+(void)setPrinterName:(NSString*) aPrinterName
{
	[printerName release];
	printerName=[aPrinterName copy];
}
+(NSString*)getPrinterName
{
	return printerName;
}

+(void) setUserName:(NSString*) aUserName
{
	[user release];
	user=[aUserName copy];
}
+(NSString*)getUserName
{
	return user;
}
+(void) setPassword:(NSString*) aPassword
{
	[password release];
	password=[aPassword copy];
}
+(NSString*)getPassword
{
	return password;
}

+(void) setTerminal:(NSString*) aTerminal{
	[terminal release];
	terminal= [aTerminal copy];
}
+(NSString*)getTerminal{
	return terminal;
}
+(void) setStore:(NSString*) aStore{
	[store release];
	store=[aStore copy];
}
+(NSString*)getStore{
	return store;
}

+(void) setStorePrint:(NSString*) aStorePrint{
	[storePrint release];
	storePrint=[aStorePrint copy];
}
+(NSString*)getStorePrint{
	return storePrint;
}

+(void) setIdStore:(NSString*) aIdStore{
	[idStore release];
	idStore=[aIdStore copy];
}
+(NSString*)getIdStore{
	return idStore;
}
+(void) setDocTo:(NSString*) adocTo
{
	[docTo release];
	docTo=[adocTo copy];
    
}
+(NSString*)getDocTo
{
	return docTo;
    
}
+(void) setMonederoNumber:(NSString*) amonederoNumber
{
	[monederoNumber release];
	monederoNumber=[amonederoNumber copy];
	
}
+(NSString*)getMonederoNumber
{
	return monederoNumber;
	
}
+(void) setMonederoAmount:(NSString*) amonederoAmount
{
	[monederoAmount release];
	monederoAmount=[amonederoAmount copy];
	
}
+(NSString*)getMonederoAmount
{
	return monederoAmount;
	
}
+(void) setMonederoPercent:(NSString*) amonederoPercent;
{
	[monederoPercentage release];
	monederoPercentage=[amonederoPercent copy];
	
}
+(NSString*)getMonederoPercent;
{
	return monederoPercentage;
	
}
+(void) setUName:(NSString*) aName;
{
	[name release];
	name=[aName copy];
	
}
+(NSString*)getUName
{
	return name;
	
}
+(void) setMonthyInterest:(NSString*) aInterest
{
	[monthyInterest release];
	monthyInterest=[aInterest copy];
	
}
+(NSString*)getMonthyInterest
{
	return monthyInterest;
	
}
+(void) setStatus:(Status) aStatus
{
    
	status=aStatus;
	DLog(@"Status actual %d ",status);
}
+(Status) getStatus
{
	DLog(@"Status actual %d ",status);
	return status;
}
+(void) setSaleType:(SaleType)aSaleType
{
	saleType=aSaleType;
	DLog(@"StatusSale actual %d ",saleType);
}
+(SaleType) getSaleType
{
	DLog(@"StatusSale actual %d ",saleType);
	return saleType;
}
+(void) setBank:(NSString*)aBank{
	[bank release];
	bank=[aBank copy];
    
}
+(NSString*)getBank{
	return bank;
}

+(void) setIndexPromoGroup:(int)aIndexPromoGroup
{
	indexPromoGroup=aIndexPromoGroup;
    
}
+(int) getIndexPromoGroup
{
	return indexPromoGroup;
}

+(void) setPlanId:(NSString*) aPlanId
{
	[planId release];
	planId=[aPlanId copy];
}
+(NSString*)getPlanId
{
	return planId;
}
+(void) setPlanInstallment:(NSString*) aPlanInstallment;
{
	[planInstallment release];
	planInstallment=[aPlanInstallment  copy];
}

+(NSString*)getPlanInstallment
{
	return planInstallment;
}
+(void) setPlanDescription:(NSString*) aPlanDescription;
{
	[planDescription release];
	planDescription=[aPlanDescription  copy];
}
+(NSString*)getPlanDescription;
{
	return planDescription;
}
+(void) setEmployeeAccount:(NSString*) aEmployeeAccount
{
	[employeeAccount release];
	employeeAccount=[aEmployeeAccount copy];
	
}
+(NSString*)getEmployeeAccount
{
	return employeeAccount;
	
}

+(void) SetServerAddress:(NSString*) aServerAddress;
{
	[serverAddress release];
	serverAddress=[aServerAddress copy];
	
}
+(NSString*)getServerAddress;
{
	return serverAddress;
	
}
+(void) SetStoreAddress:(NSString*) aStoreAddress;
{
	[storeAddress release];
	storeAddress=[aStoreAddress copy];
	
}
+(NSString*)getStoreAddress;
{
	return storeAddress;
	
}
+(void) setIsTicketGift:(BOOL) flag
{
    isTicketGift=flag;
}
+(BOOL) getIsTicketGift
{
    return isTicketGift;
}
+(void) setIsEmployeeSale:(BOOL) flag
{
    isEmployeeSale=flag;
}

+(BOOL) getIsEmployeeSale
{
    return isEmployeeSale;
}
+(void) setAddTip:(BOOL)flag
{
    addTip=flag;
}

+(BOOL) getAddTip
{
    return addTip;
}
+(void) setHasDeliveryDate:(BOOL) flag
{
    hasDeliveryDate=flag;
}
+(BOOL) getHasDeliveryDate
{
    return hasDeliveryDate;
}
+(void) setSomsOrder:(NSString*) aSomsOrder;
{
    [somsOrder release];
	somsOrder=[aSomsOrder copy];
}
+(NSString*) getSomsOrder
{
    return somsOrder;
}
+(void) setComandaOrder:(NSString *)aComandaOrder
{
    [comandaOrder release];
	comandaOrder=[aComandaOrder copy];
}
+(NSString*) getComandaOrder
{
    return comandaOrder;
}

+(void) setRefundCauseNumber:(int) aRefundId
{
	refundCauseNumber=aRefundId;
}
+(int)getRefundCauseNumber
{
    return refundCauseNumber;
}
+(void) setRefundCodeBar:(NSString*) aCodeBar
{
    [refundCodeBar release];
	refundCodeBar=[aCodeBar copy];
}

+(NSString*)getRefundCodeBar
{
    return refundCodeBar;
}
+(void) resetValues
{
	refundCauseNumber=0;
	monederoNumber=@"";
	monederoAmount=@"";
	monederoPercentage=@"";
	name=@"";
	monthyInterest=@"";
	bank=@"";
    
    
    isEmployeeSale=NO;
    isTicketGift=NO;
    addTip=NO;
    hasDeliveryDate=NO;
    
    
    indexPromoGroup=0;
    planId=@"";
    planInstallment=@"";
    planDescription=@"";
    
    employeeAccount=@"";
    somsOrder=@"";
    comandaOrder=@"";
    
    
}

+(void) setBancomerAffNumber:(NSString*) aff{
    [bancomerAffNumber release];
    bancomerAffNumber=[aff copy];
}
+(void) setAmexAffNumber:(NSString*) aff{
    [amexAffNumber release];
    amexAffNumber=[aff copy];
}
+(NSString*)getBancomerAffNumber{
    return bancomerAffNumber;
}
+(NSString*)getAmexAffNumber{
    return amexAffNumber;
}

+(BOOL)hasWarranties
{
    return hasWarranties;
}

+(void)setHasWarranties:(BOOL)hasWarrty{
    hasWarranties = hasWarrty;
}

-(void) dealloc
{
    [storePrint release];
    [somsOrder release];
    [storeAddress release];
    [serverAddress release];
	[planDescription release];
	[employeeAccount release];
	[monthyInterest release];
	[name release];
	[printerName release];
	[user release];
	[password release];
	[terminal release];
	[idStore release];
	[store release];
	[docTo release];
	[monederoNumber release];
	[monederoAmount release];
	[monederoPercentage release];
    
	[super	dealloc];
}
@end
