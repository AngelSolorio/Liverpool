//
//  MonederoCardViewController.h
//  CardReader


#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "BalanceRequest.h"


@interface MonederoCardViewController : UIViewController <LineaDelegate,WsCompleteDelegate>{
	Linea                       *scanDevice;
	UITextField				*txtMonederoNumber;
	UIButton				*btnOk;
	UIButton				*btnCancel;
}

@property (nonatomic,retain) IBOutlet	UITextField *txtMonederoNumber;
@property (nonatomic,retain) IBOutlet	UIButton	*btnOk;;
@property (nonatomic,retain) IBOutlet	UIButton	*btnCancel;


-(IBAction) validateMonederoCard;
-(void) startRequestBalanceMonedero:(NSString*) barCode;
-(IBAction) exitMonedero;
@end
