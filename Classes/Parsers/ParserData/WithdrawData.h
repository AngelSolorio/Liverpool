//
//  WithdrawData.h
//  CardReader
//
//  Created by Jonathan Esquer on 20/09/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
	cashWithdraw
} WithDrawType;
@interface WithdrawData : NSObject
{
	NSString *amount;
	NSString *quantity;
    WithDrawType type;
    
}

@property (nonatomic,retain)    NSString *amount;
@property (nonatomic,retain)    NSString *quantity;
@property (nonatomic)       WithDrawType type;

//-(void) initData:(NSString*)codebar;
//-(void) changeDateFormat;
@end
