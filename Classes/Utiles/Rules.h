//
//  Rules.h
//  CardReader


#import <Foundation/Foundation.h>
#import "TicketGeneratorViewController.h"
#import "Promotions.h"
@interface Rules : NSObject {

	paymentType payType;
}
+(NSArray*) getPrefixesFromPaymentPlan:(Promotions*) aPromo;
+(NSArray*) getExcludePrefixesFromPaymentPlan:(Promotions*) aPromo;
+(NSString*) getTenderFromPaymentPlan:(Promotions*) aPromo;
+(NSString*) getBINCard:(NSString*) aCardNumber;
+(BOOL) prefixInBINCard:(NSString*) aCardNumber maxRange:(int)aRange withPrefixs:(NSArray*) aPrefixList;
+(BOOL) prefixInDilisaLPCCard:(NSString*) aCardNumber aPrefixList:(NSArray*)aPrefixList;
+(BOOL) isEmployeeCard:(NSString*) aCardNumber;
+(void) validPayTypeForEmployee:(UISegmentedControl*) aType;
+(NSMutableArray*) filterPromotionCreditCar:(NSMutableArray *)aPromotionGroup :(NSString *)aCardNumber;
+(NSMutableArray*) filterPromotionLPCDilisa:(NSMutableArray *)aPromotionGroup :(NSString *)aCardNumber;
+(NSMutableArray*) filterPromotionMonedero:(NSMutableArray *)aPromotionGroup :(NSString *)aCardNumber;
+(BOOL) isTipAdded:(NSMutableArray*)productList;
+(BOOL) isDilisaBINCard:(NSString*) aCardNumber :(NSInteger *) isOldDilisa;
+(BOOL) isLPCBINCard:(NSString*) aCardNumber;
+(BOOL) isMonederoBINCard:(NSString*) aCardNumber;
+(BOOL) isCreditBinCard:(NSString*) aCardNumber;

@end
