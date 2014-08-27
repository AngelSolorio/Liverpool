//
//  RefundData.h
//  CardReader
//
//  Created by Jonathan Esquer on 15/01/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundData : NSObject
{
	NSString *saleDate;
	NSString *originalTerminal;
    NSString *originalDocto;
    NSString *originalSeller;
    NSString *originalStore;
    NSString *refundReason;
    NSString* refundCauseNumber;
}

@property (nonatomic,retain)    NSString *saleDate;
@property (nonatomic,retain)    NSString *originalTerminal;
@property (nonatomic,retain)    NSString *originalDocto;
@property (nonatomic,retain)    NSString *originalSeller;
@property (nonatomic,retain)    NSString *originalStore;
@property (nonatomic,retain)    NSString *refundReason;
@property (nonatomic,retain)    NSString *refundCauseNumber;


-(void) initData:(NSString*)codebar;
-(void) changeDateFormat;
@end
