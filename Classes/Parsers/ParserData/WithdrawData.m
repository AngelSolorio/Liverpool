//
//  WithdrawData.m
//  CardReader
//
//  Created by Jonathan Esquer on 20/09/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "WithdrawData.h"

@implementation WithdrawData
@synthesize amount;
@synthesize quantity;
@synthesize type;


-(void) dealloc{
    [super dealloc];
    [amount release];
    [quantity release];
}

@end
