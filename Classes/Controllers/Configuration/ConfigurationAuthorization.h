//
//  ConfigurationAuthorization.h
//  CardReader


#import <UIKit/UIKit.h>
#import "LiverPoolRequest.h"


@interface ConfigurationAuthorization : UIViewController <WsCompleteDelegate>/*<UITextFieldDelegate>*/{

	UITextField *txtStoreID;
	UITextField *txtPassword;
	UIButton    *btnOk;
}

@property (nonatomic, retain) IBOutlet	UITextField *txtStoreID;
@property (nonatomic, retain) IBOutlet	UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet  UIButton    *btnOk;

-(IBAction) validatePassword;
-(void) loginRequestParsing:(NSData*) data;

@end
