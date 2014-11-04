//
//  Session.h
//  CardReader
//


#import <Foundation/Foundation.h>

typedef enum {
	INVALID_SESSION,
	VALID_SESSION,
	CLOSE_SESSION
	
}Status;
typedef enum {
    NORMAL_CLIENT_TYPE,
    NORMAL_EMPLOYEE_TYPE,
	SOMS_CLIENT_TYPE,
    SOMS_EMPLOYEE_TYPE,
    FOOD_CLIENT_TYPE,
    CANCEL_TYPE,
    REFUND_NORMAL_TYPE,
    REFUND_NORMAL_EMPLOYEE_TYPE,
    REFUND_SOMS_TYPE,
    REFUND_SOMS_EMPLOYEE_TYPE,
    DULCERIA_CLIENT_TYPE, //there is no Employee Sale option
    CANCEL_PAYMENT_TYPE,
    WITHDRAW_CASH_ACTION_TYPE
}SaleType;

NSString *printerName;
NSString *user;
NSString *password;
NSString *terminal;
NSString *idStore;
NSString *store;
NSString *docTo;
NSString *referenceWarranty;
NSString *monederoNumber;
NSString *monederoAmount;
NSString *monederoPercentage;
NSString *name;
NSString *monthyInterest;
NSString *bank;
NSString *serverAddress;
NSString *storeAddress;
NSString *storePrint;
int      refundCauseNumber;
NSString *refundCodeBar;


Status status;
SaleType saleType;
BOOL isEmployeeSale;
BOOL isTicketGift;
BOOL addTip;
BOOL hasDeliveryDate;
BOOL hasWarranties;

int		 indexPromoGroup;
NSString *planId;
NSString *planInstallment;
NSString *planDescription;

NSString *employeeAccount;
NSString *somsOrder;
NSString *comandaOrder;

NSString *bancomerAffNumber;
NSString *amexAffNumber;


@interface Session : NSObject



+(void)setPrinterName:(NSString*) aPrinterName;
+(void) setUserName:(NSString*) aUserName;
+(void) setPassword:(NSString*) aPassword;
+(void) setTerminal:(NSString*) aTerminal;
+(void) setStore:(NSString*) aStore;
+(void) setStorePrint:(NSString*) aStorePrint;
+(void) setIdStore:(NSString*) aIdStore;
+(void) setDocTo:(NSString*) adocTo;
+(void) setReferenceWarranty:(NSString *)referenceWrty;
+(void) setMonederoNumber:(NSString*) amonederoNumber;
+(void) setMonederoAmount:(NSString*) amonederoAmount;
+(void) setMonederoPercent:(NSString*) amonederoPercent;
+(void) setUName:(NSString*) aName;
+(void) setMonthyInterest:(NSString*) aInterest;
+(void) setBank:(NSString*)aBank;
+(void) setStatus:(Status) status;
+(void) setSaleType:(SaleType)aSaleType;
+(void) setIsEmployeeSale:(BOOL) flag;

+(void) setIndexPromoGroup:(int)aIndexPromoGroup;
+(void) setPlanId:(NSString*) aPlanId;
+(void) setPlanInstallment:(NSString*) aPlanInstallment;
+(void) setPlanDescription:(NSString*) aPlanDescription;

+(void) setEmployeeAccount:(NSString*) employeeAccount;
+(void) SetServerAddress:(NSString*) aServerAddress;
+(void) SetStoreAddress:(NSString*) aStoreAddress;
+(void) setSomsOrder:(NSString*) aSomsOrder;
+(void) setComandaOrder:(NSString*) aComandaOrder;
+(void) setRefundCauseNumber:(int) aRefundId;
+(void) setRefundCodeBar:(NSString*) aCodeBar;

+(void) setIsTicketGift:(BOOL) flag;
+(void) setAddTip:(BOOL) flag;
+(void) setHasDeliveryDate:(BOOL) flag;

+(void) setBancomerAffNumber:(NSString*) aff;
+(void) setAmexAffNumber:(NSString*) aff;

+(void)verifyWarrantyPresence:(NSArray *)pList;

+(NSString*)getPrinterName;
+(NSString*)getUserName;
+(NSString*)getPassword;
+(NSString*)getTerminal;
+(NSString*)getStore;
+(NSString*)getStorePrint;
+(NSString*)getIdStore;
+(NSString*)getDocTo;
+(NSString *)getReferenceWarranty;
+(NSString*)getMonederoNumber;
+(NSString*)getMonederoAmount;
+(NSString*)getMonederoPercent;
+(NSString*)getUName;
+(NSString*)getMonthyInterest;
+(NSString*)getBank;
+(int) getIndexPromoGroup;
+(NSString*)getPlanId;
+(NSString*)getPlanInstallment;
+(NSString*)getPlanDescription;
+(NSString*)getEmployeeAccount;
+(NSString*)getServerAddress;
+(NSString*)getStoreAddress;
+(NSString*)getSomsOrder;
+(NSString*)getComandaOrder;
+(int) getRefundCauseNumber;
+(NSString*)getRefundCodeBar;
+(NSString*)getBancomerAffNumber;
+(NSString*)getAmexAffNumber;

+(BOOL)hasWarranties;

+(Status) getStatus;
+(SaleType) getSaleType;
+(BOOL) getIsEmployeeSale;
+(BOOL) getIsTicketGift;
+(BOOL) getAddTip;
+(BOOL) getHasDeliveryDate;
+(void) resetValues;



@end
