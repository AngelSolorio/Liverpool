//
//  Warranty.m
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 15/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "Warranty.h"

@implementation Warranty
@synthesize cost = _cost;
@synthesize detail = _detail;
@synthesize percentage = _percentage;
@synthesize sku = _sku;
@synthesize warrantyId = _warrantyId;
@synthesize department = _department;
@synthesize quantity = _quantity;
@synthesize warrantyForGift = _warrantyForGift;

- (void)dealloc {
    [self.cost release];
    [self.detail release];
    [self.percentage release];
    [self.sku release];
    [self.warrantyId release];
    [self.department release];
    [super dealloc];
}
@end
