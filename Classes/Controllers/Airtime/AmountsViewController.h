//
//  AmountsViewController.h
//  CardReader
//

#import <UIKit/UIKit.h>


@interface AmountsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	UITableView* amountsTable;
	NSArray* amounts;
	NSIndexPath *amountSelectedIndex;
}
@property(nonatomic,retain) IBOutlet	UITableView* amountsTable;
@property(nonatomic,retain)				NSIndexPath *amountSelectedIndex;

-(void) loadAmounts;
-(BOOL) isAmountSelected;
-(NSString*) getAmountSelected;

@end
