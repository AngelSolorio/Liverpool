//
//  Warranty.h
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 15/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Warranty : NSObject

@property (nonatomic, retain) NSString *cost;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *percentage;
@property (nonatomic, retain) NSString *sku;
@property (nonatomic, retain) NSString *warrantyId;
@property (nonatomic, retain) NSString *department;
@property (nonatomic, retain) NSString *quantity;
@property (nonatomic)         BOOL      warrantyForGift;
@end
