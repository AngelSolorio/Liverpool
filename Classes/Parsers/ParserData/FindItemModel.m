//
//  FindItemModel.m
//  CardReader
//

#import "FindItemModel.h"

@implementation FindItemModel
@synthesize barCode,brand,department,generic,itemCount,itemType,priceExtended;
@synthesize lineType,price,description,discounts,promo,itemForGift,deliveryDate,warranty,isWarranty,isFree;
-(id)init
{
	if ((self = [super init])) {
        NSLog(@"init find item model");
		discounts=[[NSMutableArray alloc] init];
        itemCount=@"1";
        deliveryDate=@"";
        description=@"";
	}
	return self;
}

-(void)initWarranty{
    warranty = [[Warranty alloc] init];
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
    [warranty release];
	[super dealloc];
}
@end
