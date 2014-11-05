//
//  EmployeeSaleViewController.h
//  CardReader


#import <UIKit/UIKit.h>
#import <VMF/VMFramework.h>
#import  <ExternalAccessory/ExternalAccessory.h>
#import "LineaSDK.h"


@interface EmployeeSaleViewController : UIViewController<LineaDelegate,VFIPinpadDelegate,UIBarPositioningDelegate> {
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
