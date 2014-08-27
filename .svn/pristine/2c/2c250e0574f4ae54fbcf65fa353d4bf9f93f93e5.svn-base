//
//  Store.m
//  TableSearch
//
//  Created by Martha Patricia Sagahon Azua on 03/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Store.h"


@implementation Store
@synthesize number, name, description;
+ (id)productWithType:(NSString *)number name:(NSString *)name description:(NSString*)description
{
	Store *newStore = [[[self alloc] init] autorelease];

	[newStore setNumber:number];
	[newStore setName:name];
	[newStore setDescription:description];

	return newStore;
}


- (void)dealloc
{
	[number release], number=nil;
	[name release], name=nil;
	[description release], name=nil;
	[super dealloc];
}
@end
