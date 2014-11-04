//
//  PaymentResponse.h
//  CardReader



#import <Foundation/Foundation.h>


@interface PaymentResponse : NSObject {
	Boolean isError;
    Boolean hasDeliveryDate;
    Boolean hasEglobalCards;
	NSString* message;
	NSString* docto;
	NSString* monthlyInterest;
	NSString* bank;
	NSString* balanceToPay;
	NSString* authorizationCode;
    NSString* deliveryNumber;
    NSString* deliveryType;
    NSString* orderDeliveryDate;
    NSString* monederoBalance;
    NSString* RFCCode;
    NSString* cashReturned;
    NSString* totalToPay;
    NSString* amountPayed;
    NSString* totalAmountWithdrawn;



}
@property (nonatomic)	Boolean isError;
@property (nonatomic)	Boolean hasDeliveryDate;
@property (nonatomic)	Boolean hasEglobalCards;
@property (nonatomic,retain)	NSString* message;
@property (nonatomic,retain)	NSString* docto;
@property (nonatomic,retain)	NSString* monthlyInterest;
@property (nonatomic,retain)	NSString* bank;	
@property (nonatomic,retain)	NSString* balanceToPay;
@property (nonatomic,retain)	NSString* authorizationCode;
@property (nonatomic,retain)	NSString* deliveryNumber;
@property (nonatomic,retain)	NSString* deliveryType;
@property (nonatomic,retain)	NSString* orderDeliveryDate;
@property (nonatomic,retain)	NSString* monederoBalance;
@property (nonatomic,retain)	NSString* RFCCode;
@property (nonatomic,retain)	NSString* cashReturned;
@property (nonatomic,retain)	NSString* totalToPay;
@property (nonatomic,retain)	NSString* amountPayed;
@property (nonatomic,retain)	NSString* totalAmountWithdrawn;
@property (nonatomic, retain)   NSString* referenceWarranty;
@end
