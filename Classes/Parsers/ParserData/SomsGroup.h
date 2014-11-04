//
//  SomsGroup.h
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 29/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WarrantyGroup.h"
@interface SomsGroup : NSObject
@property (retain , nonatomic) NSMutableArray *productList;
@property (retain , nonatomic) NSMutableArray *warrantyList;
@property (retain, nonatomic) WarrantyGroup *warrantyGroup;
@end
