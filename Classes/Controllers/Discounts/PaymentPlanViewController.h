//
//  PaymentPlanViewController.h
//  CardReader


#import <UIKit/UIKit.h>
#import "Session.h"
#import "GenericDialogViewController.h"
#import "Tools.h"
#import "GenericOptionsViewController.h"
#import "PaymentViewController.h"
@interface PaymentPlanViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,GenericActionDelegate,GenericOptionDelegate>{

	NSMutableArray* filteredPlanGroup;
	NSMutableArray* promotionGroup;
	UITableView   *	aTableView;
	NSIndexPath	*promotionIndex;
    PaymentViewController *payView;
}
@property (nonatomic,assign)			NSMutableArray* filteredPlanGroup;
@property (nonatomic,assign)			NSMutableArray* promotionGroup;
@property (nonatomic,retain)	IBOutlet UITableView   *	aTableView;
@property (nonatomic,assign)			PaymentViewController *payView;


-(void) isPromoWithInstallment;
//-------------------------DELEGATE
-(void) performAction:(NSString*) txtData : (ActionType) actionType;
-(void) performExitAction;
-(void) performOptionAction:(int)index :(NSString *)value;
-(void) hasMonederoPromotion;

@end
