//
//  Rules.m
//  CardReader
//


#import "Rules.h"
#import "Tools.h"
#import "FindItemModel.h"
@implementation Rules
/*
+(BOOL) isValidTransactionLPCDILISA:(NSArray *)aProductList :(NSString *)aCardNumber
{
	DLog(@"isValidTransactionLPCDILISA");
	Promotions *promotion=nil;
	for (FindItemModel *item in aProductList) {
		for (Promotions *promo in item.discounts) {
			if ([promo.promoTypeBenefit isEqualToString:@"paymentPlanBenefit"])
			{	
				promotion=promo;
				break;
			}
		}
	}
	if (promotion==nil) 
		return YES;
	else {
		DLog(@"isValidTransactionLPCDILISA 2d part");

			BOOL result;
			//if the DILISA/LPC promo has prefixs
			if([promotion.promoPrefixs length]>0)
			{
				DLog(@"isValidTransactionLPCDILISA with prefix");

				NSArray *prefixs=[self getPrefixesFromPaymentPlan:promotion];
				result=[self prefixInDilisaLPCCard:aCardNumber aPrefixList:prefixs];				
				if (!result) {
					NSString* message=[NSString stringWithFormat:@"%@ no es valida para el tipo de tarjeta favor de remover la promocion o cambiar el tipo de tarjeta para realizar el pago D1",promotion.promoDescription];
					[Tools displayAlert:@"Error"  message:message];
				}
				
			}	
			//if the DILISA/LPC promo had excludePrefix
			else if([promotion.promoExcludePrefixs length]>0)
			{
				DLog(@"isValidTransactionLPCDILISA with excludes");

				NSArray *excludePrefixs=[self getExcludePrefixesFromPaymentPlan:promotion];
				result=[self prefixInDilisaLPCCard:aCardNumber aPrefixList:excludePrefixs];				
				result=!result;
				if (!result) {
					NSString* message=[NSString stringWithFormat:@"%@ no es valida para el tipo de tarjeta favor de remover la promocion o cambiar el tipo de tarjeta para realizar el pago D2",promotion.promoDescription];
					message=[message lowercaseString];
					[Tools displayAlert:@"Error"  message:message];
				}
			}
		return result;
	}
	
}
// validate if the card BIN is accepted in the promotion 
+(BOOL) isValidTransactionCredit:(NSArray*) aProductList :(NSString*) aCardNumber
{
	Promotions *promotion=nil;
	for (FindItemModel *item in aProductList) {
		for (Promotions *promo in item.discounts) {
			if ([promo.promoTypeBenefit isEqualToString:@"paymentPlanBenefit"])
			{	
				promotion=promo;
				break;
			}
		}
	}
	if (promotion==nil) 
		return YES;
	else {
		NSArray *prefixs=[self getPrefixesFromPaymentPlan:promotion];
		BOOL result=[self prefixInBINCard:aCardNumber maxRange:6 withPrefixs:prefixs];
		//NSString *tender=[self getTenderFromPaymentPlan:promotion];
		//NSString *BIN=[self getBINCard];			  
		if (!result) {
			NSString* message=[NSString stringWithFormat:@"%@ no es valida para el tipo de tarjeta favor de remover la promocion o cambiar el tipo de tarjeta para realizar el pago",promotion.promoDescription];
			message=[message lowercaseString];
			[Tools displayAlert:@"Error"  message:message];
		}
		return result;
	}

}
+(BOOL) prefixInDilisaLPCCard:(NSString*) aCardNumber aPrefixList:(NSArray*)aPrefixList
{   DLog(@"prefixInDilisaLPCCard cardnumber:%@ prefixArray:%@",aCardNumber,aPrefixList);
	BOOL isValid=NO;
	NSString * BIN = [aCardNumber substringWithRange:NSMakeRange(0, 1)];
	DLog (@"BIN prefixInDilisaLPCCard %@",BIN);
	NSString * prefix;
	
	
	if ([BIN isEqualToString:@"1"])
		prefix=@"32";
	if ([BIN isEqualToString:@"2"])
		prefix=@"32";
	if ([BIN isEqualToString:@"3"])
		prefix=@"61";
	if ([BIN isEqualToString:@"5"])
		prefix=@"35";
	if ([BIN isEqualToString:@"7"])
		prefix=@"37";
	if ([BIN isEqualToString:@"8"])
		prefix=@"77";
	//if ([BIN isEqualToString:@"4"]) //special case dilisa employee/client
//		{
//			NSString * BINLPCEmployee = [aCardNumber substringWithRange:NSMakeRange(0, 7)];
//			NSString * BINLPCClient = [aCardNumber substringWithRange:NSMakeRange(0, 6)];
//
//			if ([BINLPCEmployee isEqualToString:@"4178499"]) 
//				prefix=@"85";
//			else if ([BINLPCClient isEqualToString:@"417849"]) 
//				prefix=@"32";
//		}
	
	DLog(@"Prefijo convertido :%@", prefix);
	for (NSString* prefixs in aPrefixList) {
		if ([prefix isEqualToString:prefixs]) 
			isValid=YES;
	}
	return isValid;
}
+(BOOL) prefixInBINCard:(NSString*) aCardNumber maxRange:(int)aRange withPrefixs:(NSArray*) aPrefixList
{   DLog(@"prefixInBINCard cardnumber:%@ prefixArray:%@",aCardNumber,aPrefixList);
	BOOL isValid=NO;
	NSRange binRange;
	for (NSString *prefix in aPrefixList) {
		binRange=[aCardNumber rangeOfString:prefix options:NSCaseInsensitiveSearch range:NSMakeRange(0, aRange)];
			if(binRange.location != NSNotFound)
			{	isValid=YES;
				break;
			}
	}
	return isValid;
}*/

//remove the promos that is not valid for the monedero.
+(NSMutableArray*) filterPromotionMonedero:(NSMutableArray *)aPromotionGroup :(NSString *)aCardNumber
{
	DLog(@"filterPromotionMonedero");
	NSMutableArray *testMutableArray=[NSMutableArray arrayWithArray:aPromotionGroup];
	
    //patch 1.4.5 rev2
//	for (Promotions *promo in aPromotionGroup) {
//		if ([promo.promoTypeBenefit isEqualToString:@"paymentPlanBenefit"]||[promo.promoTypeBenefit isEqualToString:@"factorLoyaltyBenefit"])
//		{	
//				NSString* message=[NSString stringWithFormat:@"%@ promociones a plazo no son validas para monedero, promocion removida",promo.promoDescription];
//				DLog(@"%@",message);
//				DLog(@"REMOVIO INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promo.promoDescription);
//				[testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];
//				
//			
//		}
//		else
//		{
//			//DLog(@"REMOVIO INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promo.promoDescription);
//			//[testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];
//			
//		}
//	}
    [testMutableArray removeAllObjects];
	aPromotionGroup=[NSMutableArray arrayWithArray:testMutableArray];
	[aPromotionGroup retain];
	return aPromotionGroup;
}

//remove the promos that is not valid for the card.
+(NSMutableArray*) filterPromotionCreditCar:(NSMutableArray *)aPromotionGroup :(NSString *)aCardNumber
{
	DLog(@"filterPromotionCreditCar");
	NSMutableArray *testMutableArray=[NSMutableArray arrayWithArray:aPromotionGroup];

	for (Promotions *promo in aPromotionGroup) {
			if ([promo.promoTypeBenefit isEqualToString:@"paymentPlanBenefit"])
			{	
				NSArray *prefixs=[self getPrefixesFromPaymentPlan:promo];
				BOOL result;
				if ([promo.planId isEqualToString:@"874"]||[promo.planId isEqualToString:@"875"]) 
					result=NO;				
				else
					result=[self prefixInBINCard:aCardNumber maxRange:6 withPrefixs:prefixs];
				
				if (!result) {
					NSString* message=[NSString stringWithFormat:@"%@ no es valida para el tipo de tarjeta favor de remover la promocion o cambiar el tipo de tarjeta para realizar el pago",promo.promoDescription];
					DLog(@"%@",message);
					DLog(@"REMOVIO INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promo.promoDescription);
					[testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];

				}
			}
			else
			{
				DLog(@"REMOVIO INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promo.promoDescription);
				[testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];
		
			}
		}
	aPromotionGroup=[NSMutableArray arrayWithArray:testMutableArray];
	[aPromotionGroup retain];
	return aPromotionGroup;
}


+(NSMutableArray*) filterPromotionLPCDilisa:(NSMutableArray *)aPromotionGroup :(NSString *)aCardNumber
{
	DLog(@"filterPromotionLPCDilisa");
	NSMutableArray *testMutableArray=[NSMutableArray arrayWithArray:aPromotionGroup];

		for (Promotions *promo in aPromotionGroup) {
			if ([promo.promoTypeBenefit isEqualToString:@"paymentPlanBenefit"])
			{	
				//if the DILISA/LPC promo has prefixs
				
				BOOL result;
				if([promo.promoPrefixs length]>0)
				{
					DLog(@"filterPromotionLPCDilisa with prefix");
					
					NSArray *prefixs=[self getPrefixesFromPaymentPlan:promo];
					result=[self prefixInDilisaLPCCard:aCardNumber aPrefixList:prefixs];				
					if (!result) {
						NSString* message=[NSString stringWithFormat:@"%@ no es valida para el tipo de tarjeta favor de remover la promocion o cambiar el tipo de tarjeta para realizar el pago D1",promo.promoDescription];
						DLog(@"%@",message);
						DLog(@"REMOVIO INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promo.promoDescription);
						[testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];
												
					}
					
				}	
				//if the DILISA/LPC promo had excludePrefix
				else if([promo.promoExcludePrefixs length]>0)
				{
					DLog(@"filterPromotionLPCDilisa with excludes");
					
					NSArray *excludePrefixs=[self getExcludePrefixesFromPaymentPlan:promo];
					result=[self prefixInDilisaLPCCard:aCardNumber aPrefixList:excludePrefixs];				
					result=!result;
					if (!result) {
						NSString* message=[NSString stringWithFormat:@"%@ no es valida para el tipo de tarjeta favor de remover la promocion o cambiar el tipo de tarjeta para realizar el pago D2",promo.promoDescription];
						DLog(@"%@",message);
						DLog(@"REMOVIO INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promo.promoDescription);
						[testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];
						
						
					}
				}
			}else {
				DLog(@"REMOVIO INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promo.promoDescription);
				[testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];
				
			}

		}
	
	aPromotionGroup=[NSMutableArray arrayWithArray:testMutableArray];
	[aPromotionGroup retain];
return aPromotionGroup;	
	
}
+(BOOL) prefixInDilisaLPCCard:(NSString*) aCardNumber aPrefixList:(NSArray*)aPrefixList
{   DLog(@"prefixInDilisaLPCCard cardnumber:%@ prefixArray:%@",aCardNumber,aPrefixList);
	BOOL isValid=NO;
	NSString * BIN = [aCardNumber substringWithRange:NSMakeRange(0, 1)];
	DLog (@"BIN prefixInDilisaLPCCard %@",BIN);
	NSString * prefix;
	
	
	if ([BIN isEqualToString:@"1"])
		prefix=@"32";
	if ([BIN isEqualToString:@"2"])
		prefix=@"32";
	if ([BIN isEqualToString:@"3"])
		prefix=@"61";
	if ([BIN isEqualToString:@"5"])
		prefix=@"35";
	if ([BIN isEqualToString:@"7"])
		prefix=@"37";
	if ([BIN isEqualToString:@"8"])
		prefix=@"77";
	if ([BIN isEqualToString:@"4"]) //special case dilisa employee/client
			{
				NSString * BINLPCEmployee = [aCardNumber substringWithRange:NSMakeRange(0, 7)];
				NSString * BINLPCClient = [aCardNumber substringWithRange:NSMakeRange(0, 6)];
	
				if ([BINLPCEmployee isEqualToString:@"4178499"]) 
					prefix=@"85";
				else if ([BINLPCClient isEqualToString:@"417849"]) 
					prefix=@"32";
			}
	
	DLog(@"Prefijo convertido :%@", prefix);
	for (NSString* prefixs in aPrefixList) {
		if ([prefix isEqualToString:prefixs]) 
			isValid=YES;
	}
	return isValid;
}
+(BOOL) prefixInBINCard:(NSString*) aCardNumber maxRange:(int)aRange withPrefixs:(NSArray*) aPrefixList
{   DLog(@"prefixInBINCard cardnumber:%@ prefixArray:%@",aCardNumber,aPrefixList);
	BOOL isValid=NO;
	NSRange binRange;
	for (NSString *prefix in aPrefixList) {
		binRange=[aCardNumber rangeOfString:prefix options:NSCaseInsensitiveSearch range:NSMakeRange(0, aRange)];
		if(binRange.location != NSNotFound)
		{	isValid=YES;
			break;
		}
	}
	return isValid;
}

+(NSArray*) getPrefixesFromPaymentPlan:(Promotions*) aPromo
{
	
	NSString *prefixString=aPromo.promoPrefixs;
	NSArray* prefixArray=[prefixString componentsSeparatedByString:@","];
	return prefixArray;
}
+(NSArray*) getExcludePrefixesFromPaymentPlan:(Promotions*) aPromo
{
	NSString *excludePrefixString=aPromo.promoExcludePrefixs;
	NSArray* excludePrefixArray=[excludePrefixString componentsSeparatedByString:@","];
	return excludePrefixArray;
}
+(NSString*) getTenderFromPaymentPlan:(Promotions*) aPromo
{
	return @"";
}
+(NSString*) getBINCard:(NSString*) aCardNumber
{
	return @"";
}
+(BOOL) isLPCBINCard:(NSString*) aCardNumber
{
    NSString * BINLPCEmployee = [aCardNumber substringWithRange:NSMakeRange(0, 7)];
    NSString * BINLPCClient = [aCardNumber substringWithRange:NSMakeRange(0, 6)];
	
    if ([BINLPCEmployee isEqualToString:@"4178499"])
        return YES;
    else if ([BINLPCClient isEqualToString:@"417849"])
        return YES;
    else
        return NO;
}
+(BOOL) isMonederoBINCard:(NSString*) aCardNumber
{
    NSString * BINMon = [aCardNumber substringWithRange:NSMakeRange(0, 2)];
	
    if ([BINMon isEqualToString:@"99"])
        return YES;
    else
        return NO;
}
//check if is a dilisa card, and check if is and old dilisa
//returns YES if is DILISA
//result isOldDIlisa if is a old dilisa

+(BOOL) isDilisaBINCard:(NSString*) aCardNumber :(NSInteger *) isOldDilisa
{
    NSString * BIN = [aCardNumber substringWithRange:NSMakeRange(0, 6)];
    int binF=[BIN integerValue];
    DLog(@"binS: %@ , isoldDilisa:%i",BIN,*isOldDilisa);
    DLog(@"binF: %i , isoldDilisa:%i",binF,*isOldDilisa);

    switch (binF) {
        //OLD DILISA
        case 100000://Crédito Liverpool
            *isOldDilisa=1;
            return YES;
            break;
        case 300000://Crédito FF
            *isOldDilisa=1;
            return YES;
            break;
        case 200000://Crédito LiverTU
            *isOldDilisa=1;
            return YES;
            break;
        case 210000://Crédito FabricaTe
            *isOldDilisa=1;
            return YES;
            break;
        case 500000://Crédito Empleados Liverpool
            *isOldDilisa=1;
            return YES;
            break;
        case 600000://Crédito Empleados Fabricas de Francia
            *isOldDilisa=1;
            return YES;
            break;
        case 700000://Credito Loverpool Corporativa        
            *isOldDilisa=1;
            return YES;
            break;
        case 800000://Credito Fabricas de Francia Corporativa        
            *isOldDilisa=1;
            return YES;
            break;
        // NEW DILISA
        case 130000://Crédito Liverpool
            *isOldDilisa=0;
            return YES;
            break;
        case 330000 ://Crédito Fabricas de Francia             
            *isOldDilisa=0;
            return YES;
            break;
        case 230000 ://Crédito LiverTú
            *isOldDilisa=0;
            return YES;
            break;
        case 231000 ://Crédito FabricaTé                
            *isOldDilisa=0;
            return YES;
            break;
        case 530000 ://Crédito Empleados Liverpool            
            *isOldDilisa=0;
            return YES;
            break;
        case 630000 ://Crédito Empleados Fabricas de Francia        
            *isOldDilisa=0;
            return YES;
            break;
        case 730000 ://Credito Loverpool Corporativa        
            *isOldDilisa=0;
            return YES;
            break;
        case 830000 ://Credito Fabricas de Francia Corporativa        
            *isOldDilisa=0;
            return YES;
            break;
        default:
            DLog(@"binF: %i , isoldDilisa:%i",binF,*isOldDilisa);
            return NO;
            break;
    }

}

+(BOOL) isCreditBinCard:(NSString*) aCardNumber{
    BOOL isCreditCard=NO;
    
    
    return isCreditCard;
    
    
}


/*
+(BOOL) itemWithPaymentPlanPromoMonedero:(NSArray*) aProductList
{
	BOOL isPlanPromo=NO;
	for (FindItemModel *item in aProductList) {
		for (Promotions *promo in item.discounts) {
			if ([promo.promoTypeBenefit isEqualToString:@"paymentPlanBenefit"])
			{	isPlanPromo=YES;
				[Tools displayAlert:@"Aviso" message:@"Promocion En plazos no es valida para pago en monedero"];
			}
		}
	}
	return isPlanPromo;
	
}*/
+(BOOL) isEmployeeCard:(NSString*) aCardNumber
{
	BOOL isEmployee=NO;
	if ([aCardNumber length]<16||[aCardNumber length]>16) {
        DLog(@"No empleado invalido");
        return NO;
    }
	DLog(@"isEmployeeCard cardnumber:%@",aCardNumber);
	NSString * BINLPC = [aCardNumber substringWithRange:NSMakeRange(0, 7)];
	NSString * BIN3 = [aCardNumber substringWithRange:NSMakeRange(0, 3)];
	NSString * BIN4 = [aCardNumber substringWithRange:NSMakeRange(0, 4)];

	if ([BINLPC isEqualToString:@"4178499"]) {
		DLog(@"Bin LPC empleado");
		return YES;
	}
	if ([BIN3 isEqualToString:@"500"]) {
		DLog(@"Bin DILISA empleado");
		return YES;
	}
	if ([BIN3 isEqualToString:@"600"]) {
		DLog(@"Bin DILISA FF empleado");
		return YES;
	}
    if ([BIN3 isEqualToString:@"630"]) {
		DLog(@"Bin DILISA FF empleado");
		return YES;
	}
	if ([BIN4 isEqualToString:@"5300"]) {
		DLog(@"Bin DILISA CVV2 empleado");
		return YES;
	}
	return isEmployee;
}
+(void) validPayTypeForEmployee:(UISegmentedControl*) aType
{
	[aType setEnabled:NO forSegmentAtIndex:3];
}

+(BOOL) isTipAdded:(NSMutableArray*)productList
{
    BOOL tip=NO;
    for (FindItemModel *item in productList) {
        if ([item.description isEqualToString:@"Propina"]) {
            DLog(@"ya existe propina!");
            tip=YES;
        }
    }
    return tip;
}

@end
