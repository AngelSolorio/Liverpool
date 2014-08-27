//
//  CardDataList.m
//  CardReader
//
//  Created by Jonathan Esquer on 31/12/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "CardDataList.h"
@implementation CardDataList
@synthesize cardList;
//@synthesize totalAmountWithdrawn;

- (id) init
{
	self = [super init];
	if (self != nil) {
		cardList=[[NSMutableArray alloc] init];
	}
	return self;
}

-(void)addCardToList:(Card*) aCard
{
    [cardList addObject:aCard];
    [aCard release];
  
    DLog(@"Data added");
}

-(NSMutableArray*) getCardList
{
    return cardList;
}
-(void)setCardList:(NSMutableArray *)aCardList{
    cardList=aCardList;
}

-(void) dealloc{
    [super dealloc];
    [cardList release];
}

@end


//falta setear el array
