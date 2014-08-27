//
//  Error.m
//  CardReader
//


#import "Error.h"


@implementation Error
@synthesize number,description;



- (void) dealloc
{
	[number release], number=nil;
	[description release], description=nil;
	[super dealloc];
}

@end
