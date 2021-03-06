//
//  BalanceViewController.h
//  CardReader
//
#import <UIKit/UIKit.h>
#import "BalanceRequest.h"
#import "LineaSDK.h"
#import "TicketGeneratorViewController.h"

@interface BalanceViewController : UIViewController<LineaDelegate,WsCompleteDelegate,UITextFieldDelegate> {
	
	UITextField* txtAccountNumber;
	UIButton* btnBalance;
	
	UIButton* btnMonedero;
	UIButton* btnDilisa;
	UIButton* btnLPC;

	Linea                       *scanDevice;
	//labels
	UILabel* lblBalance;
	UILabel* lastBalance;
	UILabel* dueBalance;
	UILabel* cycleExpire;
	UILabel* minPayment;
	UILabel* woRefinanciamientPayment;
	UILabel* NonInterestPayment;
	UILabel* date;
	UILabel* lblsTexto1;
	UILabel* lblsTexto2;
	UILabel* lblsTexto3;
	UILabel* lblsTexto4;
	UILabel* lblsTexto5;
	UILabel* lblsTexto6;
	UILabel* lblsTexto7;
	//End labels
	UISegmentedControl* segmentType;
	NSString* segmentTextType;
	NSString* cardNumber;
	BOOL	 ticket;
	int balanceType;
	
}
@property (nonatomic, retain) IBOutlet UITextField* txtAccountNumber;
@property (nonatomic, retain) IBOutlet UIButton* btnBalance;
@property (nonatomic, retain) IBOutlet UIButton* btnMonedero;
@property (nonatomic, retain) IBOutlet UIButton* btnDilisa;
@property (nonatomic, retain) IBOutlet UIButton* btnLPC;

@property (nonatomic, retain) IBOutlet UILabel* lblBalance;
@property (nonatomic, retain) IBOutlet UILabel* lastBalance;
@property (nonatomic, retain) IBOutlet UILabel* dueBalance;
@property (nonatomic, retain) IBOutlet UILabel* cycleExpire;
@property (nonatomic, retain) IBOutlet UILabel* minPayment;
@property (nonatomic, retain) IBOutlet UILabel* woRefinanciamientPayment;
@property (nonatomic, retain) IBOutlet UILabel* NonInterestPayment;
@property (nonatomic, retain) IBOutlet UILabel* date;
@property (nonatomic, retain) IBOutlet UILabel* lblsTexto1;
@property (nonatomic, retain) IBOutlet UILabel* lblsTexto2;
@property (nonatomic, retain) IBOutlet UILabel* lblsTexto3;
@property (nonatomic, retain) IBOutlet UILabel* lblsTexto4;
@property (nonatomic, retain) IBOutlet UILabel* lblsTexto5;
@property (nonatomic, retain) IBOutlet UILabel* lblsTexto6;
@property (nonatomic, retain) IBOutlet UILabel* lblsTexto7;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentType;
@property (nonatomic, retain) IBOutlet 	NSString* segmentTextType;
@property (nonatomic)					BOOL ticket;

-(IBAction) balanceQuery;
-(void) startRequest:(NSString*) barCode;
-(void) balanceRequestParsing:(NSData*) data;
-(IBAction) exitBalanceConsult;
//-(IBAction) selectedSegmentType;
-(void) clearFields;
-(void) hiddenFields:(BOOL)type;
-(void) printTicketBalance;
-(NSString*) typeOfBalance;
-(IBAction) selectedSegmentTypeMonedero;
-(IBAction) selectedSegmentTypeDilisa;
//-(IBAction) selectedSegmentTypeLPC;
-(void) startRequestBalanceMonedero:(NSString*) barCode;
-(paymentType) setPaymentType:(int) type;

@end
