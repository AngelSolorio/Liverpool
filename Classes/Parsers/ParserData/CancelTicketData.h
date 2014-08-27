//
//  CancelTicketData.h
//  CardReader
//
//  Created by Jonathan Esquer on 02/10/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelTicketData : NSObject
{
    BOOL isError;
	NSString *originalTerminal;
	NSString *terminal;
    NSString *originalDocto;
	NSString *docto;
	NSString *originalAmount;
    NSString *authorizationCode;
    NSString *bank;
    NSMutableArray *eglobalCards;

    
}

@property (nonatomic)           BOOL isError;
@property (nonatomic,retain)    NSString *originalTerminal;
@property (nonatomic,retain) 	NSString *terminal;
@property (nonatomic,retain)    NSString *originalDocto;
@property (nonatomic,retain) 	NSString *docto;
@property (nonatomic,retain) 	NSString *originalAmount;
@property (nonatomic,assign) 	NSString *authorizationCode;//nill assigment cause errors en dealloc
@property (nonatomic,retain) 	NSString *bank;
@property (nonatomic,retain)    NSMutableArray *eglobalCards;


@end
