//
//  ItemDetailViewController.h
//  CardReader


#import <UIKit/UIKit.h>
#import "FindItemModel.h"
#import "GenericDialogViewController.h"
#import "CustomCell.h"
@interface ItemDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,GenericActionDelegate>{

	UILabel		*lblProductName;
	UILabel		*lblBarcode;
	UILabel		*lblPrice;
	UILabel		*lblDepartment;
	UILabel		*lblBgDepartment;
	UILabel		*lblBgDiscount;
    UILabel		*lblBgModifiers;
	UILabel		*lblDiscount;
    UILabel		*lblQuantity;
	UIButton	*btnDiscount;
	UIButton	*btnPromotions;
	FindItemModel *itemModel;
	UILabel     *lblBackground;
    UIButton    *btnGift;
    UIScrollView *scrollView;
    BOOL        qtyFLag;
    
	
}
@property(nonatomic, retain)	IBOutlet	UILabel		*lblProductName;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblBarcode;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblPrice;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblDepartment;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblBgDiscount;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblDiscount;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblBgDepartment;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblBgModifiers;
@property(nonatomic, retain)	IBOutlet	UILabel		*lblQuantity;
@property(nonatomic, retain)	IBOutlet	UIButton	*btnDiscount;
@property(nonatomic, retain)	IBOutlet	UIButton	*btnPromotions;
@property(nonatomic, retain)	IBOutlet	UIButton	*btnGift;

@property(nonatomic, assign)				FindItemModel *itemModel;
@property(nonatomic, retain)	IBOutlet	UILabel     *lblBackground;
@property(nonatomic, retain)	IBOutlet	UIScrollView *scrollView;
@property (assign, nonatomic) IBOutlet UITableView *aTableView;
@property (assign, nonatomic) IBOutlet UILabel *lblOriginalPrice;
@property (assign, nonatomic) IBOutlet UIButton *btnQuantity;


-(void) displayItemInfo:(FindItemModel*) itemModel;
-(IBAction) promotionScreen;
-(IBAction) manualDiscountScreen;
-(IBAction) itemForGift:(id)sender;
-(IBAction) setQuantityForItem:(id)sender;
-(IBAction) setModifierForItem:(id)sender;
-(void) performAction:(NSString*) txtData : (ActionType) actionType;
-(void) performExitAction;

@end
