//
//  WarrantyGroup.m
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 30/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "WarrantyGroup.h"

@implementation WarrantyGroup
@synthesize warranties = _warranties;
@synthesize findItemModel = _findItemModel;

-(FindItemModel *)findItemModel{
    if (!_findItemModel) _findItemModel = [[FindItemModel alloc] init];
    return _findItemModel;
}

-(NSMutableArray *)warranties{
    if(!_warranties) _warranties = [[NSMutableArray alloc] init];
    return _warranties;
}

-(void)dealloc{
    [self.warranties release];
    [self.findItemModel release];
    [super dealloc];
}
@end
