//
//  FindItemModel.h
//  CardReader
//


#import <Foundation/Foundation.h>
#import "Warranty.h"

@interface FindItemModel : NSObject {

	NSString *barCode;
	NSString *brand;
	NSString *department;
	NSString *generic;
	NSString *itemCount;
	NSString *itemType;
	NSString *lineType;
	NSString *price;
	NSString *description;
    NSString *priceExtended;
    NSString *deliveryDate;

	BOOL	  promo;
	NSMutableArray	 *discounts;
    BOOL      itemForGift;

}
@property (nonatomic, retain) 	NSString *barCode;
@property (nonatomic, retain) 	NSString *brand;
@property (nonatomic, retain) 	NSString *department;
@property (nonatomic, retain) 	NSString *generic;
@property (nonatomic, retain) 	NSString *itemCount;
@property (nonatomic, retain)	NSString *itemType;
@property (nonatomic, retain)	NSString *lineType;
@property (nonatomic, retain)	NSString *price;
@property (nonatomic, retain)	NSString *priceExtended;
@property (nonatomic, retain)	NSString *description;
@property (nonatomic, retain)	NSString *deliveryDate;
@property (nonatomic, retain)	NSMutableArray	 *discounts;
@property (nonatomic)			BOOL	  promo;
@property (nonatomic)			BOOL	  itemForGift;
@property (nonatomic, retain)   Warranty *warranty;
@property (nonatomic)           BOOL      isWarranty;
@property (nonatomic)           BOOL      isFree;

-(NSString*) getXMLdescription;
-(void)initWarranty;



@end
