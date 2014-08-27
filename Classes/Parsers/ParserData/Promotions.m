//
//  Promotions.m
//  CardReader
//
//

#import "Promotions.h"


@implementation Promotions
@synthesize promoDescription,promoDiscountPercent;
@synthesize promoType,promoDescriptionPrinter,promoAplicationMethod;
@synthesize promoBaseAmount;
@synthesize promoMagnitude;
@synthesize promoQty;
@synthesize promoValue;
@synthesize promoProrationMethod;
@synthesize promoTypeBenefit;
@synthesize promoInstallment;
@synthesize promoInstallmentSelected; 
@synthesize header;
@synthesize planId;
@synthesize promoTypeMonedero;
@synthesize promoPrefixs;
@synthesize	promoExcludePrefixs;
@synthesize promoTender;
@synthesize promoBank;
@synthesize extraPercentagePromo;

-(id) copyWithZone: (NSZone *) zone
{
	Promotions *promotionsCopy = [[Promotions allocWithZone: zone] init];
	
	// Cambio Ruben - Se agrego autorelease a los copy - 18/Enero/2012
	[promotionsCopy setPromoDescription:[[promoDescription copy]autorelease]];
	[promotionsCopy setPromoDiscountPercent:[[promoDiscountPercent copy]autorelease]];
	[promotionsCopy setPromoType:promoType];
	[promotionsCopy setPromoDescriptionPrinter:[[promoDescriptionPrinter copy]autorelease]];
	[promotionsCopy setPromoAplicationMethod:[[promoAplicationMethod copy]autorelease]];
	[promotionsCopy setPromoBaseAmount:[[promoBaseAmount copy]autorelease]];
	[promotionsCopy setPromoMagnitude:[[promoMagnitude copy]autorelease]];
	[promotionsCopy setPromoQty:[[promoQty copy]autorelease]];
	[promotionsCopy setPromoValue:[[promoValue copy]autorelease]];
	[promotionsCopy setPromoProrationMethod:[[promoProrationMethod copy]autorelease]];
	[promotionsCopy setPromoTypeBenefit:[[promoTypeBenefit copy]autorelease]];
	[promotionsCopy setPromoInstallment:[[promoInstallment copy]autorelease]];
	[promotionsCopy setPromoInstallmentSelected:[[promoInstallmentSelected copy]autorelease]];
    [promotionsCopy setHeader:[[header copy]autorelease]];
	[promotionsCopy setPlanId:[[planId copy]autorelease]];
	[promotionsCopy setPromoTypeMonedero:[[promoTypeMonedero copy]autorelease]];
	[promotionsCopy setPromoPrefixs:[[promoPrefixs copy]autorelease]];
	[promotionsCopy setPromoExcludePrefixs:[[promoExcludePrefixs copy]autorelease]];
	[promotionsCopy setPromoTender:[[promoTender copy]autorelease]];
	[promotionsCopy setPromoBank:[[promoBank copy]autorelease]];
    [promotionsCopy setExtraPercentagePromo:extraPercentagePromo];

	return promotionsCopy;
}
- (id) init
{
	self = [super init];
	if (self != nil) {
        extraPercentagePromo=0;
	}
	return self;
}
-(void) dealloc
{
	[promoBank release];
	[promoTender release];	
	[promoPrefixs release];
	[promoExcludePrefixs release];
	[promoTypeMonedero release];
	[promoAplicationMethod release];
	[promoBaseAmount release];
	[promoMagnitude release];
	[promoQty release];
	[promoValue release];
	[promoProrationMethod release];
	[promoDescription release];
	[promoDiscountPercent release];
	[promoDescriptionPrinter release];
	[promoTypeBenefit release];
	[promoInstallment release];
	[promoInstallmentSelected release];
	[header release];
	[planId release];
	[super dealloc];
}
@end
