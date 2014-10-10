//
//  ConsultSKUViewController.h
//  CardReader
//


#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import <VMF/VMFramework.h>
#import  <ExternalAccessory/ExternalAccessory.h>
#import "LiverPoolRequest.h"

@class FindItemModel;
@class ItemDetailViewController;
@class ItemDiscountsViewController;
@interface ConsultSKUViewController : UIViewController <LineaDelegate,WsCompleteDelegate,VFIBarcodeDelegate,VFIControlDelegate, VFIPinpadDelegate> {

	FindItemModel *itemModel;
	ItemDetailViewController *itemDetailView;
	ItemDiscountsViewController *itemDiscountView;
	UIView						*productSearch;
	UITextField					*txtBarcode;
	UIButton					*btnRegister;
    NSTimer                     *myTimer;
}
@property (nonatomic,retain) FindItemModel *itemModel;
@property (nonatomic,retain) IBOutlet ItemDetailViewController *itemDetailView;
@property (nonatomic,retain) IBOutlet ItemDiscountsViewController *itemDiscountView;
@property (nonatomic,retain) IBOutlet UIView						*productSearch;
@property (nonatomic,retain) IBOutlet UITextField					*txtBarcode;
@property (nonatomic,retain) IBOutlet UIButton					*btnRegister;




-(IBAction) scanCode;
-(void) startRequest:(NSString*) barCode;
-(void) findItemRequestParsing:(NSData*) data;
-(void) validateResponse;
-(IBAction) showBarcodeTextfield;

@end
