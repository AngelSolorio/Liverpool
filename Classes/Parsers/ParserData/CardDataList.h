//
//  CardDataList.h
//  CardReader
//
//  Created by Jonathan Esquer on 31/12/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface CardDataList : NSObject
{
    NSMutableArray* cardList;
    //NSString *totalAmountWithdrawn;
    
}

@property (nonatomic,retain) 	NSMutableArray* cardList;
//@property (nonatomic,retain) 	NSString *totalAmountWithdrawn;


-(void)addCardToList:(Card*)aCard;
-(NSMutableArray*) getCardList;
-(void)setCardList:(NSMutableArray *)aCardList;
-(NSMutableArray*) getCardList;
@end
