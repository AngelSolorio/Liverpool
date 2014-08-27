//
//  ItemDiscountsViewController.h
//  CardReader
//

#import <UIKit/UIKit.h>
#import "LiverPoolRequest.h"

@class FindItemModel;
@class Promotions;  // Ruben

@interface ItemDiscountsViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,WsCompleteDelegate> {

	UITableView			*aTableView;
	UIButton			*btnOk;
	UITextField			*txtDiscount;
	UITextField			*txtOption;
	UISegmentedControl	*ctrlFixedDiscounts;
	UISegmentedControl	*ctrlDiscountType;
	FindItemModel		*itemModel;
	NSMutableArray		*testArray;
	NSIndexPath			*promotionIndex;
	UILabel				*lblSign;
	NSMutableArray		*productList;
	NSMutableArray		*promotionGroupSelected;
    NSMutableArray      *testArrayDisplay;

}

@property (nonatomic,retain) IBOutlet UITableView			*aTableView;
@property (nonatomic,retain) IBOutlet UIButton				*btnOk;
@property (nonatomic,retain) IBOutlet UITextField			*txtDiscount;
@property (nonatomic,retain) IBOutlet UITextField			*txtOption;
@property (nonatomic,retain) IBOutlet UILabel				*lblSign;
@property (nonatomic,retain) IBOutlet UISegmentedControl	*ctrlFixedDiscounts;
@property (nonatomic,retain) IBOutlet UISegmentedControl	*ctrlDiscountType;
@property (nonatomic,assign)		  FindItemModel			*itemModel;
@property (nonatomic,assign)		  NSMutableArray		*productList;



- (IBAction) discountSelected;
- (IBAction) discountTypeSelected;
-(BOOL) isValidDiscount:(UITextField*) discount;
-(IBAction) savetoDiscountList;
//-(IBAction) savetoPromoList;
-(void) startPromoRequest;
-(void) findPromoRequestParsing:(NSData*) data;
-(void) assignPromoType;
-(int) assignDiscountType;
-(NSString*) calculateDiscounts:(NSString*) aPrice;
-(NSString*) assignDiscountTypeName;
//-(void) isMonederoPromotion;
-(void) calculateSuccesiveDiscounts;
//-(BOOL)isDuplicatedPromotion:(Promotions*)promotion;  // Ruben
-(NSString*) displayPromoInfoCell :(Promotions*) promo;

@end
