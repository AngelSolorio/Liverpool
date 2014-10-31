//
//  WarrantyGroup.h
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 30/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindItemModel.h"
@interface WarrantyGroup : NSObject
@property (retain , nonatomic) NSMutableArray *warranties;
@property (retain, nonatomic) FindItemModel *findItemModel;
@end
