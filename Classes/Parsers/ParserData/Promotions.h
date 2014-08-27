//
//  Promotions.h
//  CardReader
//
//

#import <Foundation/Foundation.h>


@interface Promotions : NSObject <NSCopying>{
	NSString *promoDescription;
	NSString *promoDescriptionPrinter;
	NSString *promoDiscountPercent;
	NSString *promoAplicationMethod;
	NSString *promoBaseAmount;
	NSString *promoMagnitude;
	NSString *promoQty;
	NSString *promoValue;
	NSString *promoProrationMethod;
	NSString *promoTypeBenefit;
	NSString *promoInstallment;
	NSString *promoInstallmentSelected;
	NSString *header;
	int promoType; //deprecated.
	NSString *planId;
	NSString *promoTypeMonedero;
	NSString *promoPrefixs;
	NSString *promoExcludePrefixs;
	NSString *promoTender;
	NSString *promoBank;
    int extraPercentagePromo; //0:no% 1:RECARGA MONEDERO 2:ADICIONAL DILISA

}
@property (nonatomic,retain) NSString *promoDescription;
@property (nonatomic,retain) NSString *promoDescriptionPrinter;
@property (nonatomic,retain) NSString *promoDiscountPercent;
@property (nonatomic,retain) NSString *promoAplicationMethod;
@property (nonatomic,retain) NSString *promoBaseAmount;
@property (nonatomic,retain) NSString *promoMagnitude;
@property (nonatomic,retain) NSString *promoQty;
@property (nonatomic,retain) NSString *promoValue;
@property (nonatomic,retain) NSString *promoProrationMethod;
@property (nonatomic,retain) NSString *promoTypeBenefit;
@property (nonatomic,retain) NSString *promoInstallment;
@property (nonatomic,retain) NSString *promoInstallmentSelected;
@property (nonatomic,retain) NSString *header;
@property (nonatomic,retain) NSString *planId;
@property (nonatomic,retain) NSString *promoTypeMonedero;
@property (nonatomic,retain) NSString *promoPrefixs;
@property (nonatomic,retain) NSString *promoExcludePrefixs;
@property (nonatomic,retain) NSString *promoTender;
@property (nonatomic,retain) NSString *promoBank;
@property (nonatomic) int promoType;
@property (nonatomic) int extraPercentagePromo;


@end
