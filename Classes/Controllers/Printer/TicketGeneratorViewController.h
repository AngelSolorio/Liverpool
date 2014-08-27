//
//  TicketGeneratorViewController.h
//  CardReader
//


#import <UIKit/UIKit.h>
#import "Card.h"
#import "PrinterQueue.h"
#import "RefundData.h"
#import "WithdrawDataList.h"
#import "WithdrawData.h"
@class FindItemModel;
@class CloseTerminalData;
@class CancelTicketData;
typedef enum {
	creditType,
	LPCType,
	dilisaType,
	monederoType,
    cashType

} paymentType;
@interface TicketGeneratorViewController : UIViewController {

	UITextView *txtAProducts;
	NSArray *productList;
	Card    *card;
	paymentType pType;
	NSDate *date;
	NSMutableArray *cardArray;
	NSMutableArray *promotionPlanArray;
    BOOL printGiftTicket;
    int SOMSDeliveryType;
    NSString *somsOrderDeliveryDate;
    NSString *somsDeliveryNumber;
    NSString *RFCCode;
    RefundData *refundData;

}

@property (nonatomic,retain) IBOutlet	UITextView *txtAProducts;
@property (nonatomic,assign)			NSArray *productList;
@property (nonatomic,assign)			Card    *card;
@property (nonatomic,assign)			NSMutableArray *cardArray;
@property (nonatomic,assign)			NSMutableArray *promotionPlanArray;
@property (nonatomic,assign)			BOOL printGiftTicket;
@property (nonatomic,assign)			int SOMSDeliveryType;
@property (nonatomic,assign)			NSString *somsOrderDeliveryDate;
@property (nonatomic,assign)			NSString *somsDeliveryNumber;
@property (nonatomic,retain)			NSString *RFCCode;
@property (nonatomic,assign)			RefundData *refundData;




-(IBAction) removeTicketTestView;
//-(void) printTicket;
//-(void) WriteToPrinter:(NSString*) stringToPrint;
-(void) setPaymentType:(int) type;
//-(void) printTicketAirtime:(NSString*) phoneNumber;
-(void) printTicketBalance:(NSString*) balance;
//-(void) printTicketMonedero;
//-(BOOL) GetOnlineStatus;
-(void) printTwoPaymentTicket;
-(void) printTicketGift;
-(void) printComprobant;
-(void) printCloseDataTicket:(CloseTerminalData*)closeData;
-(void) printCancelDataTicket:(CancelTicketData*)cancelData;
-(void)printWithdrawalTicket:(WithdrawDataList*)drawList;
-(void) printSOMSVoucher;
-(BOOL)checkPrinterStatus;

-(NSString*) getAuthorizationNumber:(Card*) cardData;
-(NSString*) generateItemBarcodeWithZeros:(NSString*) codebar;
-(NSString*) getSaleTypeHeader;
-(NSString*) generateTicketCodeBar;
-(NSString*) getPaymentType:(Card*) aCard;
-(NSString*) getCardNumberMaskFormat:(NSString*) aCardNumber;
-(NSString*) generateTextualAmountDescription:(float) amount;
-(NSString*) generateDate;
-(NSString*) generateTicketGiftCodeBar:(FindItemModel*) item :(float) discount;
-(NSString*) getOrderNumber;
-(NSString*) getSOMSAgreements;
-(NSString*)getItemDeliveryDate:(NSString*) somsDate;
-(NSString*) getQuantityTicket:(FindItemModel*) item;
-(NSString*) getExtendedPrice:(FindItemModel*) item;
-(NSString*) getCashChangeinfo:(NSString*) cashChange;
-(NSString*) getInstallmentsText:(Card*)aCard;

-(void) setMonederoDepositText:(NSString*) amount;

-(NSString*) getRefundDataWarning;
-(NSString*) getRefundDataInfo;

-(NSString*)stringWithoutAccentsFromString:(NSString*)s;
-(NSString*) printExternalPagareText:(NSString*) cardType;

-(NSString*) printAffiliationNumber:(Card*) aCard;

-(NSString*) printBalanceMessage:(NSString*)balance;

-(NSString*) printAuthCodeForDilisaCancel:(NSString*)type :(NSString*)authCode;

@end
