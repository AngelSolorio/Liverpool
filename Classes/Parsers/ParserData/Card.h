//
//  Card.h
//  CardReader
//

#import <Foundation/Foundation.h>


@interface Card : NSObject <NSCopying> {

	NSString *track1;
	NSString *track2;
	NSString *track3;
	NSString *authCode;
	NSString *cardNumber;
	NSString *cardType;
	NSString *expireDate;
	NSString *userName;
	NSString *monederoNumber;
	NSString *amountToPay;
	NSString *planId;
	NSString *planInstallment;
	NSString *planDescription;
	NSString *authNumber;
    NSString *installmentsAmount;
    NSString *bank;
    NSString *balance;
    NSString *monederoDeposit;
    NSString *cashChange;

    //se queda con el planID de la tarjeta que fallo RESOLVER
	
}
@property (nonatomic,retain) 	NSString *track1;
@property (nonatomic,retain) 	NSString *track2;
@property (nonatomic,retain) 	NSString *track3;
@property (nonatomic,retain) 	NSString *authCode;
@property (nonatomic,retain) 	NSString *cardNumber;
@property (nonatomic,retain) 	NSString *cardType;
@property (nonatomic,retain) 	NSString *expireDate;
@property (nonatomic,retain) 	NSString *userName;
@property (nonatomic,retain) 	NSString *monederoNumber;
@property (nonatomic,retain) 	NSString *amountToPay;
@property (nonatomic,retain) 	NSString *planId;
@property (nonatomic,retain) 	NSString *planInstallment;
@property (nonatomic,retain) 	NSString *planDescription;
@property (nonatomic,retain)	NSString *authNumber;
@property (nonatomic,retain)	NSString *installmentsAmount;
@property (nonatomic,retain)	NSString *bank;
@property (nonatomic,retain)	NSString *balance;
@property (nonatomic,retain)	NSString *monederoDeposit;
@property (nonatomic,retain)	NSString *cashChange;

@end
