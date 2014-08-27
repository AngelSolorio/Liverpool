//
//  AffiliationCodes.m
//  CardReader
//
//  Created by Jonathan Esquer on 24/01/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "AffiliationCodes.h"

@implementation AffiliationCodes
@synthesize affiliationNumber, bankName;

- (void)dealloc
{
	[affiliationNumber release];
    [bankName release];
    
	[super dealloc];
}
@end
