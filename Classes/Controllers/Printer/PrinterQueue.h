//
//  PrinterQueue.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/05/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol PrintCompleteDelegate <NSObject> 
-(void) printerResults:(BOOL) printingComplete;
@end


NSMutableArray* printQueue;
id <PrintCompleteDelegate> delegate;
BOOL timerIsOn;
BOOL statusOK;
NSTimer *cancelTimer;
NSString *errorMessage;
NSString *errorHeader;

@interface PrinterQueue : NSObject


+(void) addPrintToQueue:(NSString *) text;
+(void) startPrinting;
+(id)firstObject;
+(BOOL)WriteToPrinter:(NSString*) stringToPrint;
+(int) calculatePrintingTime:(NSString*) stringToPrint;
+(void) printerStatusFailed;
+(void) printerStatusSuccess;
+(void) setDelegate:(id) del;
+(void) removeDelegate;
//+(void) startCancelTimer;
+(void) performResults;
//+(void) restartCancelTimer;
+(BOOL) getPrintingStatus;
//+(NSString*) getImageBitMapData;

@end
