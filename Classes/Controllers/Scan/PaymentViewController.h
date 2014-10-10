//
//  PaymentViewController.h
//  CardReader
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LineaSDK.h"
#import "ScanViewController.h"
#import "SignPrintView.h"
#import "Card.h"
#import "NumberKeypadDecimalPoint.h"
#import "RefundData.h"

//typedef enum {
//    DILISA,
//    DILISA_CVV2,
//    LPC,
//    MONEDERO,
//    BANCOMER,
//    BANAMEX,
//    AMEX,
//    EXTERNAL,
//    INHOUSE,
//    CASH
//}CARD_BIN;

@interface PaymentViewController : UIViewController
<LineaDelegate,MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate,WsCompleteDelegate,UITextFieldDelegate>
{
	CGFloat animatedDistance;
	IBOutlet UILabel                   *lblTitle;
	IBOutlet UILabel                   *lblCard;
	IBOutlet UILabel                   *lblCardNumber;
	IBOutlet UILabel                   *lblUser;
	IBOutlet UILabel                   *lblUserText;
	IBOutlet UILabel                   *lblDate;
	IBOutlet UILabel                   *lblDateText;
	IBOutlet UILabel                   *lblSubtitle;
	IBOutlet UILabel                   *lblOperation;
	IBOutlet UILabel                   *lblBalance;

	IBOutlet UIButton				   *btnPay;
	IBOutlet UIBarButtonItem           *barBtnCancel;
	IBOutlet UIBarButtonItem           *barBtnSMS;
	IBOutlet UIBarButtonItem           *barBtnEmail;
	IBOutlet UIBarButtonItem           *barBtnDone;
    IBOutlet UIBarButtonItem           *barBtnBack;
	IBOutlet UIButton					*btnHideAuthCode;
	IBOutlet UIButton					*btnPromo;
	IBOutlet UITextField			   *txtAuthCode;
	IBOutlet UITextField			   *txtAmount;
	NSArray								*productList;
	NSArray								*productListWithPromos;

	float                                total;
    //temp vars
    int                                somsDeliveryType;
    NSString                            *somsDeliveryDate;
    NSString                            *somsDeliveryNumber;
    NSString                            *RFCCode;
    RefundData                          *refundData;
    //
	Linea                              *scanDevice;
	NSMutableString						*status;
	
	Card								*cardData;
	BOOL								firstPaymentDone;
	NSMutableArray						*cardsArray;
	NSString							*balanceToPay;
	NSMutableArray						*filteredPlanGroup;
	NSMutableArray						*promotionGroup;
	NSMutableArray						*originalPromotionGroup;
    NumberKeypadDecimalPoint			*numberKeyPad;
    
    
    int                                 cardType;

}

@property (retain, nonatomic) IBOutlet UILabel                   *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel                   *lblCard;
@property (retain, nonatomic) IBOutlet UILabel                   *lblCardNumber;
@property (retain, nonatomic) IBOutlet UILabel                   *lblUser;
@property (retain, nonatomic) IBOutlet UILabel                   *lblUserText;
@property (retain, nonatomic) IBOutlet UILabel                   *lblDate;
@property (retain, nonatomic) IBOutlet UILabel                   *lblDateText;
@property (retain, nonatomic) IBOutlet UILabel                   *lblSubtitle;
@property (retain, nonatomic) IBOutlet UILabel                   *lblOperation;
@property (retain, nonatomic) IBOutlet UILabel                   *lblBalance;
@property (retain, nonatomic) IBOutlet UITextField			     *txtAuthCode;
@property (retain, nonatomic) IBOutlet UITextField			     *txtAmount;
@property (retain, nonatomic) IBOutlet UIButton					 *btnPay;
@property (retain, nonatomic) IBOutlet UIBarButtonItem			 *barBtnCancel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem			 *barBtnSMS;
@property (retain, nonatomic) IBOutlet UIBarButtonItem			 *barBtnEmail;
@property (retain, nonatomic) IBOutlet UIBarButtonItem			 *barBtnDone;
@property (retain, nonatomic) IBOutlet UIBarButtonItem			 *barBtnBack;
@property (retain, nonatomic) IBOutlet UIButton					 *btnHideAuthCode;
@property (assign, nonatomic)		   NSArray					 *productList;
@property (assign, nonatomic)		   NSArray					 *productListWithPromos;

@property (retain, nonatomic)		   NSMutableArray			 *cardsArray;
@property (assign, nonatomic)		   NSMutableArray			 *filteredPlanGroup;
@property (assign, nonatomic)		   	NSMutableArray			*promotionGroup;
@property (assign, nonatomic)		   	NSMutableArray			*originalPromotionGroup;

@property (nonatomic, retain) NumberKeypadDecimalPoint *numberKeyPad;
@property (retain, nonatomic) IBOutlet UIView *cardReaderView;
@property (retain, nonatomic) IBOutlet UIView *amountReaderView;

@property (assign, nonatomic) IBOutlet UIButton *btnCashPay;
@property (assign, nonatomic) IBOutlet UIButton *btnCardPay;
@property (assign, nonatomic) IBOutlet UIButton *btnMonederoPay;
@property (assign, nonatomic) IBOutlet UIButton *btnAmountBack;
@property (assign, nonatomic) IBOutlet UIButton *btnAmountOk;
@property (assign, nonatomic) IBOutlet UIButton *btnCardBack;
@property (assign, nonatomic) IBOutlet UIButton *btnCardOk;


-(void) animationDidEnd:(NSString*) message forResult:(BOOL) paymentDone;
-(void) startRequest;
-(void) paymentRequestParsing:(NSData*) data;
-(void) refundPaymentParsing:(NSData*) data;
-(void) printingRequestParsing:(NSData*) data;
-(BOOL) validatePaymentData;
-(void) logoutRequest;
-(void) startRequestBalanceMonedero:(NSString*) barCode;
-(void) balanceRequestParsing:(NSData*) data;
-(void) cancelPaymentRequestParsing:(NSData*) data;
-(void) promotionValidForTransaction;
-(BOOL) canPrint;
-(BOOL) isValidAmountValue;
-(void) addCardToCardArray;
//-(void) blockPaymentOptionsAfterFirstPayment;
-(void) resetLabels;
-(void) keyboardSlideDown: (UITextField *) textField;
-(void) keyboardSlideUp: (UITextField *) textField;
-(NSString*) selectTypeOfSale;
-(void) restaurantPaymentsDone:(NSData*) data;
-(void) somsPaymentsDone:(NSData*) data;
-(BOOL) isValidEmployeeCard;
-(void) setLayout;
-(void) cancelPaymentRequest;
-(void) cashCodeData;


- (IBAction)selectedPayment:(id)sender;
-(IBAction) printPDFRequest;
-(IBAction)dismissSelf:(id)sender;
-(IBAction)dismissSelfToLogin;
-(IBAction)sendMail:(id)sender;
-(IBAction)authorization:(id)sender;
-(IBAction) printTicket;
- (IBAction)okAmountBtn:(id)sender;
- (IBAction)removeAllSubviews:(id)sender;
- (IBAction)okCardReadAction:(id)sender;
-(void) showCardReadview;
-(void) showAmountView;
-(void) identifyBINCard;

@end
