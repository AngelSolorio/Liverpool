//
//  LoginResponse.m
//  CardReader
//


#import "LoginResponse.h"


@implementation LoginResponse
@synthesize 	code,nameU;
-(void) dealloc
{
	[code release];
	[nameU release];

	[super dealloc];
}
@end
