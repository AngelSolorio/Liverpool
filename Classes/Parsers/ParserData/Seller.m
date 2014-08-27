//
//  Seller.m
//  CardReader
//


#import "Seller.h"


@implementation Seller

@synthesize userName,password,name;


-(void) dealloc
{
	[name release];
	[userName release];
	[password release];
	[super dealloc];
}
@end
