//
//  Card.m
//  CardReader
//

#import "Card.h"


@implementation Card

@synthesize track1,track2,track3,authCode,cardNumber,cardType,expireDate,userName,monederoNumber;
@synthesize planId;
@synthesize amountToPay;
@synthesize planInstallment;
@synthesize planDescription;
@synthesize authNumber;
@synthesize installmentsAmount;
@synthesize bank;
@synthesize balance;
@synthesize monederoDeposit;
@synthesize cashChange;
-(id) copyWithZone: (NSZone *) zone
{
	Card *cardCopy = [[Card allocWithZone: zone] init]; //possible leak
	
	// Cambio Ruben - Se agrego autorelease a los copy - 18/Enero/2012
	[cardCopy setTrack1:[[track1 copy]autorelease]];
	[cardCopy setTrack2:[[track2 copy]autorelease]];
	[cardCopy setTrack3:[[track3 copy]autorelease]];
	[cardCopy setAuthCode:[[authCode copy]autorelease]];
	[cardCopy setCardNumber:[[cardNumber copy]autorelease]];
	[cardCopy setCardType:[[cardType copy]autorelease]];
	[cardCopy setExpireDate:[[expireDate copy]autorelease]];
	[cardCopy setUserName:[[userName copy]autorelease]];
	[cardCopy setAmountToPay:[[amountToPay copy]autorelease]];
	[cardCopy setPlanId:[[planId copy]autorelease]];
	[cardCopy setPlanInstallment:[[planInstallment copy]autorelease]];
	[cardCopy setPlanDescription:[[planDescription copy]autorelease]];
	[cardCopy setAuthNumber:[[authNumber copy]autorelease]];
    [cardCopy setInstallmentsAmount:[[installmentsAmount copy]autorelease]];
    [cardCopy setBank:[[bank copy]autorelease]];
    [cardCopy setBalance:[[balance copy]autorelease]];
    [cardCopy setMonederoDeposit:[[monederoDeposit copy]autorelease]];
    [cardCopy setCashChange:[[cashChange copy]autorelease]];


	return cardCopy;
}


-(void) dealloc
{
    [cashChange release];
    [monederoDeposit release];
    [balance release];
    [bank release];
    [installmentsAmount release];
	[authNumber release];
	[planDescription release];
	[planId release];
	[amountToPay release];
	[userName release];
	[track1 release];
	[track2 release];
	[track3 release];
	[authCode release];
	[cardNumber release];
	[cardType release];
	[expireDate release];
	[monederoNumber release];
	[super dealloc];
}

@end
