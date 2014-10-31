//
//  SomsGroup.m
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 29/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "SomsGroup.h"

@implementation SomsGroup
@synthesize productList =_productList;
@synthesize warrantyList = _warrantyList;
@synthesize warrantyGroup = _warrantyGroup;

-(WarrantyGroup *)warrantyGroup{
    if(!_warrantyGroup) _warrantyGroup = [[WarrantyGroup alloc] init];
    return _warrantyGroup;
}
-(NSMutableArray *)productList{
    if(!_productList) _productList = [[NSMutableArray alloc] init];
    return _productList;
}

-(NSMutableArray *)warrantyList{
    if(!_warrantyList) _warrantyList = [[NSMutableArray alloc] init];
    return _warrantyList;
}

-(void)dealloc{
    [self.productList release];
    [self.warrantyList release];
    [self.warrantyGroup release];
    [super dealloc];
}
@end
