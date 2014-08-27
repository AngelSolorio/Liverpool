//
//  FindItemModel.m
//  CardReader
//

#import "FindItemModel.h"


@implementation FindItemModel
@synthesize barCode,brand,department,generic,itemCount,itemType,priceExtended;
@synthesize lineType,price,description,discounts,promo,itemForGift,deliveryDate;
-(id)init
{
	if ((self = [super init])) {
		discounts=[[NSMutableArray alloc] init];
        itemCount=@"1";
        deliveryDate=@"";
        description=@"";
	}
	
	return self;
}
-(NSString*) getXMLdescription
{
    NSString* xmlDescription=[description stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    xmlDescription=[xmlDescription stringByReplacingOccurrencesOfString:@"\u00d0" withString:@"N"];
 
    return xmlDescription;
}
-(void) dealloc
{
    [deliveryDate release];
    [priceExtended release];
	[barCode release];
	[brand release];
	[department release];
	[generic release]; 
	[itemCount release];
	[itemType release];
	[lineType release];
	[price release];
	[description release];
	[discounts release];
	[super dealloc];
}
@end
