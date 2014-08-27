//
//  EmployeeSaleViewController.h
//  CardReader


#import <UIKit/UIKit.h>
#import "LineaSDK.h"


@interface EmployeeSaleViewController : UIViewController<LineaDelegate> {
	Linea                       *scanDevice;
	UITextField					*txtCardNumber;
	UIButton					*btnOk;
}
@property (nonatomic,retain) IBOutlet UITextField	*txtCardNumber;
@property (nonatomic,retain) IBOutlet UIButton		*btnOk;

-(IBAction) exitEmployeeSale;
-(void) showScanItemView;
-(IBAction) validateManualCardNumber;

@end
