//
//  WithdrawDataList.m
//  CardReader
//
//  Created by Jonathan Esquer on 27/09/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "WithdrawDataList.h"

@implementation WithdrawDataList
@synthesize withdrawList;
@synthesize totalAmountWithdrawn;

- (id) init
{
	self = [super init];
	if (self != nil) {
		withdrawList=[[NSMutableArray alloc] init];
        totalAmountWithdrawn=@"";
	}
	return self;
}

-(void)addWithdrawToList:(NSString*) amt :(NSString*) qty
{
    WithdrawData *data=[[WithdrawData alloc] init];
    
    [data setAmount:amt];
    [data setQuantity:qty];
    
    [withdrawList addObject:data];
    DLog(@"drawData added");
    DLog(@"withdrawList %@",withdrawList);
    [data release];
}

-(NSMutableArray*) getWithdrawList
{
    return withdrawList;
}
-(void) dealloc{
    [super dealloc];
    [withdrawList release];
    [totalAmountWithdrawn release];
}

@end
