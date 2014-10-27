//
//  ScanViewController.h
//  CardReader
//


#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "LiverPoolRequest.h"
#import "GenericCancelViewController.h"

@class FindItemModel;
@interface ScanViewController : UIViewController 
								<UITableViewDataSource, UITableViewDelegate,
								 LineaDelegate,WsCompleteDelegate,UITextFieldDelegate,CancelActionDelegate,UIAlertViewDelegate>
{
	IBOutlet UITableView        *aTableView;
	IBOutlet UITextView         *textDescription;
	IBOutlet UITextField		*txtSKUManual;
	IBOutlet UIButton			*btnScan;
	IBOutlet UIButton			*btnPay;
    IBOutlet UILabel            *lblSKU;
	IBOutlet UIBarButtonItem    *barButtonRight;
             UIBarButtonItem    *barButtonLeft;
    UIButton            * btton;
	Linea                       *scanDevice;

	NSMutableArray				*productList;
	NSMutableString             *status;
	NSMutableString             *debug;
	float                         total;
	int							selectedItemIndex;
    NSNumber                    *warrantiesEnabled;
    
}

@property (retain, nonatomic) IBOutlet UITextView   *textDescription;
@property (retain, nonatomic) IBOutlet UITextField  *txtSKUManual;
@property (retain, nonatomic) IBOutlet UIButton     *btnScan;
@property (retain, nonatomic) IBOutlet UIButton     *btnPay;
@property (retain, nonatomic) IBOutlet UILabel      *lblSKU;
//@property (retain, nonatomic) IBOutlet UIBarButtonItem   *barButtonLeft;
@property (retain, nonatomic) IBOutlet UIBarButtonItem   *barButtonRight;
@property (retain, nonatomic) IBOutlet UIBarButtonItem   *barButtonLeft;
@property (retain, nonatomic) IBOutlet UITableView       *aTableView;

//-(void)designTweaks;
//-(IBAction)startScanBarCode:(id)sender;
-(IBAction)stopScanBarCode:(id)sender;
-(IBAction)payItems:(id)sender;
-(IBAction) logout;
-(void)connectionState:(int)state;
-(void)enableCharging;
-(void)updateBattery;
-(void)setBarbuttonImage:(int)imageToLoad;
//-(void)turnOnEditing;
//-(void)turnOffEditing;
-(void)totalAddition:(id)object;
-(void)setDataIntoArray:(FindItemModel *)itemObject;
-(void) findItemRequestParsing:(NSData*) data;
-(void) startRequest:(NSString*) barCode;
-(NSString*) displayPromotionDiscount:(int) index;
-(void) applyPromotionsToProducts:(FindItemModel*) aItemWithPromo;
//-(void) isSKUSameSection:(FindItemModel*) aItemWithPromo;
-(void) removeProductsFromList;
-(void) setLayoutForTransaction;
-(void) startSOMSRequest;
-(void) somsItemsRequestParsing:(NSData*) data;
-(void) startComandaRequest;
-(IBAction)addTipToTicket:(id)sender;
-(void) comandaItemsRequestParsing:(NSData*) data;
-(void) editItemForTransaction:(NSIndexPath*) indexPath;

-(void) startRequestForTransaction;
-(BOOL) isValidSKU:(id) item;
-(void) startRequestWithPrice:(NSString*) barCode :(NSString*) price;
-(IBAction)addSKURefund:(id)sender;
-(BOOL) isValidRefundChange:(FindItemModel*) item;
-(void)reloadTableViewWithData:(NSMutableArray *)pList;
@end
