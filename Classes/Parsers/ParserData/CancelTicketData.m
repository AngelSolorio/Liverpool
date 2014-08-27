//
//  CancelTicketData.m
//  CardReader
//
//  Created by Jonathan Esquer on 02/10/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "CancelTicketData.h"

@implementation CancelTicketData

@synthesize originalTerminal;
@synthesize terminal;
@synthesize originalDocto;
@synthesize docto;
@synthesize originalAmount;
@synthesize isError;
@synthesize authorizationCode;
@synthesize bank;
@synthesize eglobalCards;

-(void) dealloc
{
    DLog(@"cancelticketData dealloc");
    DLog(@"bank %@",bank);
    //DLog(@"eglobalCards %@",eglobalCards);
    //DLog(@"authorizationCode %@",authorizationCode);
    DLog(@"originalTerminal %@",originalTerminal);
    DLog(@"terminal %@",terminal);
    DLog(@"originalDocto %@",originalDocto);
    DLog(@"docto %@",docto);
    DLog(@"originalAmount %@",originalAmount);


    [super dealloc];
    [bank release];
    //[eglobalCards release];
    //[authorizationCode release];
    [originalTerminal release];
    [terminal release];
    [originalDocto release];
    [docto release];
    [originalAmount release];
}
@end


// authocode causa crash cuando authcode viene nil