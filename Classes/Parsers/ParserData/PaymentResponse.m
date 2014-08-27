//
//  PaymentResponse.m
//  CardReader

#import "PaymentResponse.h"


@implementation PaymentResponse
@synthesize 	hasDeliveryDate,isError,message,docto,monthlyInterest,bank,balanceToPay,authorizationCode;
@synthesize     deliveryType,deliveryNumber,orderDeliveryDate,monederoBalance,RFCCode,cashReturned,totalToPay,amountPayed;
@synthesize     totalAmountWithdrawn,hasEglobalCards;

- (void) dealloc
{
    [totalAmountWithdrawn release];
    [amountPayed release];
    [totalToPay release];
    [cashReturned release];
    [RFCCode release];
    [monederoBalance release];
    [orderDeliveryDate release];
    [deliveryNumber release];
    [deliveryType release];
	[bank release];bank=nil;
	[monthlyInterest release];monthlyInterest=nil;
	[message release],message=nil;
	[docto release],docto=nil;
	[balanceToPay release], balanceToPay=nil;
	[authorizationCode release], authorizationCode=nil;
	[super dealloc];
}


@end
