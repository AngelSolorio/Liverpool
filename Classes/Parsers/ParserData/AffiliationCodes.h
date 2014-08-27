//
//  AffiliationCodes.h
//  CardReader
//
//  Created by Jonathan Esquer on 24/01/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AffiliationCodes : NSObject
{
    NSString* affiliationNumber;
    NSString* bankName;

}
@property (nonatomic, copy) NSString *affiliationNumber;
@property (nonatomic, copy) NSString *bankName;

@end
