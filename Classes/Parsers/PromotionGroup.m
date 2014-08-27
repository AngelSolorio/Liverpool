//
//  PromotionGroup.m
//  CardReader


#import "PromotionGroup.h"


@implementation PromotionGroup
@synthesize promotionGroupArray;
@synthesize section;

-(void)dealloc
{
	[promotionGroupArray release];
	[super	dealloc];
}
@end
