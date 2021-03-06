//
//  Balance.m
//  CardReader

#import "Balance.h"
#import "Error.h"

@implementation Balance
@synthesize error,nc,sa;
@synthesize suc, sv, svc, pm, pmni, flp, tipoCuenta, pm_sinrefin, pm_conrefin,fe;

- (id) init
{
	self = [super init];
	if (self != nil) {
		error=[[Error alloc] init];
	}
	return self;
}
-(BOOL) isError{
	if (error.number!=nil) {
		if(error.description!=nil){
			return TRUE;
		}
	}
	return FALSE;
	
}
//-(NSString*) description{
//	if ([self isError]) {
//		return error.description;
//	}
//		return @"BalanceVacio";
//	
//	
//}
- (void) dealloc
{
	[error release],error=nil;
	[nc release], nc=nil;
	[sa release], sa=nil;
	[suc release], suc=nil;
	[sv release], sv=nil;
	[svc release], svc=nil;
	[pm release], pm=nil;
	[pmni release],pmni=nil; 
	[flp release], flp=nil;
	[tipoCuenta release], tipoCuenta=nil;
	[pm_sinrefin release], pm_sinrefin=nil;
	[pm_conrefin release], pm_conrefin=nil;
	[fe release], fe=nil;
	[super dealloc];
}

@end
