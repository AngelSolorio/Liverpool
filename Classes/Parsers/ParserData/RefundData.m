//
//  RefundData.m
//  CardReader
//
//  Created by Jonathan Esquer on 15/01/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "RefundData.h"
#import "Session.h"
#import "Tools.h"
@implementation RefundData
@synthesize saleDate;
@synthesize originalTerminal;
@synthesize originalDocto;
@synthesize originalSeller;
@synthesize originalStore;
@synthesize refundReason;
@synthesize refundCauseNumber;


-(void) dealloc
{
    DLog(@"RefundData Dealloc  ");
    [super dealloc];
    
//    [saleDate release];
//    [originalTerminal release];
//    [originalDocto release];
//    [originalSeller release];
//    [originalStore release];
//    [refundReason release];
//    [refundCauseNumber release];
}

-(void) initData:(NSString*)codebar
{
    //v.setMsj("007979 0021 0011 120510"); //bol term tda fech
    saleDate=[[codebar substringWithRange:NSMakeRange(0,6)] copy];
    DLog(@"saleDate: %@",saleDate);
    
    originalStore=[[codebar substringWithRange:NSMakeRange(6,3)] copy];
    DLog(@"originalStore: %@",originalStore);
//
    originalTerminal=[[codebar substringWithRange:NSMakeRange(9,3)] copy];
    DLog(@"originalTerminal: %@",originalTerminal);
//
    originalDocto=[[codebar substringWithRange:NSMakeRange(12,4)] copy];
    DLog(@"originalDocto: %@",originalDocto);

    originalSeller=[[codebar substringWithRange:NSMakeRange(16,8)] copy];
    DLog(@"originalSeller: %@",originalSeller);

    
    refundCauseNumber=[NSString stringWithFormat:@"%i",[Session getRefundCauseNumber]];
    refundReason=[Tools getRefundReasonPrintText:refundCauseNumber];

    [refundCauseNumber retain];
    [self changeDateFormat];
}
-(void) changeDateFormat
{
    DLog(@"changedateformat %@" , saleDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyy"];
    NSDate *date  = [dateFormatter dateFromString:saleDate];
    
    DLog(@"convertformat %@", date);

    // Convert to new Date Format
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    saleDate= [dateFormatter stringFromDate:date];
    [saleDate retain];
    
    DLog(@"changedateformat %@" , saleDate);
    
    [dateFormatter release];

}
////this method converts the local ennumeration to the ennumeration in the BridgeCore client
-(void) convertRefundReason
{
    DLog(@"convertrefundReason");
 
    switch ([Session getRefundCauseNumber]) {
        case 1://talla o color
            break;
        case 2: //Estilo
            
            break;
        case 3: //defecto
            
            break;
        case 4://no le gusto pendiente de que responda synthesis
            
            break;
        case 5://regalo duplicado
            refundCauseNumber=@"4";

            break;
        case 6:// cambio 
            refundCauseNumber=@"5";

            break;

        default:
            break;
    }
    

//    NSArray *refundChoices=[NSArray arrayWithObjects:@"1- Devolucion por talla o color dif. Pre",
//                            @"2- Devolucion por estilo",
//                            @"3- Devolucion por defecto",
//                            @"4- Devolucion por que no le gusto",
//                            @"5- Devolucion por regalo Duplicado",
//                            @"6- Cambio por mercancia de igual precio",
//                            nil];
}
@end
