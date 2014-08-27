//
//  PromotionInstallmentViewController.h
//  CardReader


#import <UIKit/UIKit.h>
#import "Promotions.h"
#import "GenericDialogViewController.h"
@interface PromotionInstallmentViewController : UIViewController <UITableViewDataSource,
																	UITableViewDelegate,GenericActionDelegate> {

	NSArray *installmentArray;
	UITableView *aTableView;
	Promotions *promo;
	UILabel *lblBg;
	UILabel *lblPromoName;
	UILabel *lblPromoPrice;
	UILabel *lblPromoDiscount;
	UILabel *lblPromoFinalPrice;
	UILabel *lblDescription;
	UIButton *btnReturn;
}

@property (nonatomic,retain)			NSArray *installmentArray;
@property (nonatomic,retain) IBOutlet	UITableView *aTableView;
@property (nonatomic,assign)			Promotions *promo;
@property (nonatomic,retain) IBOutlet	UILabel *lblBg;
@property (nonatomic,retain) IBOutlet	UILabel *lblPromoName;
@property (nonatomic,retain) IBOutlet	UILabel *lblPromoPrice;
@property (nonatomic,retain) IBOutlet	UILabel *lblPromoDiscount;
@property (nonatomic,retain) IBOutlet	UILabel *lblPromoFinalPrice;
@property (nonatomic,retain) IBOutlet	UILabel *lblDescription;
@property (nonatomic,retain) IBOutlet	UIButton *btnReturn;


-(void) showInstallmentsTable;
-(void) showPromoDescription;
-(IBAction) goBack;

//-------------------------DELEGATE
-(void) performAction:(NSString*) txtData : (ActionType) actionType;
-(void) performExitAction;
@end
