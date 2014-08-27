//
//  WithdrawDataList.h
//  CardReader
//
//  Created by Jonathan Esquer on 27/09/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithdrawData.h"

@interface WithdrawDataList : NSObject
{
    NSMutableArray* withdrawList;
    NSString *totalAmountWithdrawn;

}

@property (nonatomic,retain) 	NSMutableArray* withdrawList;
@property (nonatomic,assign) 	NSString *totalAmountWithdrawn;


-(void)addWithdrawToList:(NSString*) amt :(NSString*) qty;
-(NSMutableArray*) getWithdrawList;

@end
