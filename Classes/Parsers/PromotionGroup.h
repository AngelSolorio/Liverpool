//
//  PromotionGroup.h
//  CardReader


#import <Foundation/Foundation.h>


@interface PromotionGroup : NSObject {

	NSMutableArray* promotionGroupArray;
	int section;
}

@property (nonatomic,retain) 	NSMutableArray* promotionGroupArray;
@property (nonatomic)			int section;
@end
