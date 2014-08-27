//
//  CardDataViewController.h
//  CardReader

#import <UIKit/UIKit.h>
#import "LineaSDK.h"

@class Card;
@protocol CardDataDelegate
-(void) performCardDataTransaction:(Card*) cardData;
@end

@interface CardDataViewController : UIViewController <LineaDelegate,UITextFieldDelegate>{

	UILabel *lblCardNumber;
	UILabel *lblUserName;
	UILabel *lblExpirationDate;
	UILabel *lblPaymentAmount;
	UITextField *txtAuthCode;
	Card	*cardData;
	id <CardDataDelegate> delegate;
	Linea                       *scanDevice;
	NSString *cardNumber;
	UISegmentedControl		   *ctrlPaymentType;
	int cardType;
	UIButton					*btnHideAuthCode;

}

@property (nonatomic,retain) IBOutlet UILabel *lblCardNumber;
@property (nonatomic,retain) IBOutlet UILabel *lblUserName;
@property (nonatomic,retain) IBOutlet UILabel *lblExpirationDate;
@property (nonatomic,retain) IBOutlet UILabel *lblPaymentAmount;
@property (nonatomic,retain) IBOutlet UITextField *txtAuthCode;
@property (nonatomic,retain) IBOutlet UIButton *btnHideAuthCode;
@property (nonatomic,retain)		  Card	  *cardData;
@property (nonatomic,retain)	id <CardDataDelegate> delegate;
@property(nonatomic,retain) IBOutlet	UISegmentedControl *ctrlPaymentType;


-(void) showCardDataView;
-(void) hideCardDataView;
-(IBAction) continueTransaction;
-(BOOL) validatePaymentData;
-(IBAction) selectedPaymentType;
-(IBAction) hideAuthCodeForNewDilisa;

@end
