//
//  PrinterQueue.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/05/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "PrinterQueue.h"
#import "StarIO/SMPort.h"
#import "Tools.h"
#import "CardReaderAppDelegate.h"
#import "Session.h"
#import "StarBitmap.h"
#define C_AutoCutterFullCut "\x1b\x64\x30"
#define C_LineFeedx6 "\x0a\x0a\x0a\x0a\x0a\x0a"
#define C_LineFeedx6_Size 3
#define C_AutoCutterFullCut_Size 2

@implementation PrinterQueue

-(id)init
{
    if (self = [super init])
    {
        // Initialization code here
        printQueue=[[NSMutableArray alloc]init];
    }
    return self;
}


+(void) addPrintToQueue:(NSString *) text
{
    if (printQueue==nil)
        printQueue=[[NSMutableArray alloc]init];
    
    [printQueue addObject:text];
}
+(void) removePrintQueue
{
    if ([printQueue count]>=1) {
        [printQueue removeObjectAtIndex:0];
    }
    else
        DLog(@">-----WARNING-----< : intentando remover del queue vacio");
    
}
+(void) startPrinting
{
    //[self startCancelTimer];
    
    if ([self firstObject]==nil)
    {
        DLog(@"la lista es 0");
        [self performResults];
        
    }
    else
    {
        DLog(@"existen impresiones revisando status #%i",[printQueue count]);
        NSString *text=[self firstObject];
        if ([self WriteToPrinter:text]) {
            DLog(@"se puede imprimir, intentando imprimir");
            statusOK=YES;
            DLog(@"Se imprimio correctamente index primera posicion");
            //[PrinterQueue removePrintQueue];
            //[self restartCancelTimer];
        }
        else {
            DLog(@"ocurrio un error volviendo a intentar");
            statusOK=NO;
            //entra a un loop por que no pudo leer
            
        }
    }
    
    DLog(@"termino la lista de impresion");
    
    
}
+(void) setDelegate:(id) del
{
    self.delegate=del;
}
+(void) removeDelegate
{
    self.delegate=nil;
}
//+(void) startCancelTimer
//{
//    DLog(@"iniciando cancelTimer");
//    if (!timerIsOn) {
//        timerIsOn=YES;
//        cancelTimer=[NSTimer scheduledTimerWithTimeInterval:15.0
//                                                     target:self
//                                                   selector:@selector(printerStatusFailed)
//                                                   userInfo:nil
//                                                    repeats:NO];
//    }
//}
//+(void) restartCancelTimer
//{
//    DLog(@"renovando cancelTimer");
//
//    [cancelTimer invalidate];
//    cancelTimer=nil;
//    timerIsOn=YES;
//    cancelTimer=[NSTimer scheduledTimerWithTimeInterval:15.0
//                                                 target:self
//                                               selector:@selector(printerStatusFailed)
//                                               userInfo:nil
//                                                repeats:NO];
//}

+(void) performResults
{
    if (statusOK) {
        [cancelTimer invalidate];
        cancelTimer=nil;
        [Session setStatus:CLOSE_SESSION];
        [Session setMonederoAmount:@""];
		[Session setMonederoPercent:@""];
		[Session setMonederoNumber:@""];
        NSLog(@"Before going to login");
        [Session verifyWarrantyPresence:nil];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];
        timerIsOn=NO;
        DLog(@"PERFORM RESULT OK");
        
        
    }
    else {
        // [Tools displayAlert:@"Error" message:@"Tiempo de respuesta de impresora agotado,sugerencias: \n -Favor de revisar la conectividad e intentar de nuevo"];
        [Tools displayAlert:errorHeader message:errorMessage];
    }
    [Tools stopActivityIndicator];
    
}
+(void) printerStatusFailed
{
    //[delegate printerResults:NO];
    DLog(@"printerStatusFailed removing all queue");
    [printQueue removeAllObjects];
    timerIsOn=NO;
    statusOK=NO;
    [self performResults];
    
}
+(void) printerStatusSuccess
{
    //[delegate printerResults:YES];
}

+ (id)firstObject
{
    if ([printQueue count] > 0)
    {
        return [printQueue objectAtIndex:0];
    }
    return nil;
}

// Printer Commands
/**
 * This function is used to print a uiimage directly to a portable printer.
 * portName - Port name to use for communication. This should be "TCP:<IP Address>" or "BT:PRNT Star".
 * portSettings - Should be mini, the port settings mini is used for portable printers
 * source - the uiimage to convert to star printer data for portable printers
 * maxWidth - the maximum with the image to print.  This is usually the page with of the printer.  If the image exceeds the maximum width then the image is scaled down.  The ratio is maintained.
 */
/*
 width = 384;
 width = 576;
 width = 832;
 */
+(NSString*) getImageBitMapData
{
    int maxWidth=576;
    StarBitmap *starbitmap = [[StarBitmap alloc] initWithUIImage:[UIImage imageNamed:@"wireless.png"] :maxWidth :false];
    NSData *commands = [starbitmap getImageMiniDataForPrinting:NO pageModeEnable:NO];
    DLog(@"commandS:--------> %@",commands);
    
    //[self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:30000];
    //320x77   72px
    //NSString *commandString = [[NSString alloc]  initWithBytes:[commands bytes]
    //                                            length:[commands length] encoding: NSUTF8StringEncoding];
    // NSString* commandString=[self stringWithContentsOfBinaryData:commands];
    NSString* commandString=[commands description];
    
    DLog(@"commandSTring:--------> %@",commandString);
    //[commandString autorelease];
    [commands release];
    [starbitmap release];
    
    return commandString;
    
}

+(BOOL)WriteToPrinter:(NSString*) stringToPrint
{
    BOOL printSuccessful=NO;
	if (![Tools validatePrinterConfig])
		return NO;
    
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	NSData* myEncodedObject = [defaults objectForKey:@"programIPAddres"];
	NSString* portName = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	DLog(@"ipAddressArchived: %@", portName);
	
	myEncodedObject = [defaults objectForKey:@"programPortSettings"];
	NSString* portSettings = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
	DLog(@"portSettings: %@", portSettings);
    
    NSString* tempCommands=[stringToPrint stringByAppendingString:@"\n\n\n\n\n"];
    NSData* commands = [tempCommands dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char *commandsToSendToPrinter = (unsigned char*)malloc(commands.length);
    [commands getBytes:commandsToSendToPrinter];
    int commandSize = [commands length];
    
    SMPort *starPort = nil;
    
    @try
    {
        starPort = [SMPort getPort:portName :portSettings :8000];
        if (starPort == nil)
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port"
            //                                                            message:@""
            //                                                           delegate:nil
            //                                                  cancelButtonTitle:@"OK"
            //                                                  otherButtonTitles:nil];
            //            [alert show];
            //            [alert release];
            errorHeader=@"Impresora apagada o fuera de alcance";
            errorMessage=@"Comprobar que la impresora esta encendida";
            
            [self printerStatusFailed];
            return printSuccessful;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 60;
        
        StarPrinterStatus_2 status;
        [starPort beginCheckedBlock:&status :2];
        
        if (status.offline == SM_TRUE)
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
            //                                                            message:@"Printer is offline"
            //                                                           delegate:nil
            //                                                  cancelButtonTitle:@"OK"
            //                                                  otherButtonTitles:nil];
            //            [alert show];
            //            [alert release];
            errorHeader=@"Impresora apagada o fuera de alcance";
            errorMessage=@"Comprobar que la impresora esta encendida";
            
            [self printerStatusFailed];
            return printSuccessful;
        }
        
        int totalAmountWritten = 0;
        while (totalAmountWritten < commandSize)
        {
            int remaining = commandSize - totalAmountWritten;
            
            int amountWritten = [starPort writePort:commandsToSendToPrinter :totalAmountWritten :remaining];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec)
            {
                break;
            }
            //printSuccessful =YES;
            
        }
        
        //SM-T300(Wi-Fi): To use endCheckedBlock method, require F/W 2.4 or later.
        [starPort endCheckedBlock:&status :2];
        if (status.offline == SM_TRUE)
        {
            
            DLog(@"status.offline == SM_TRUE");
            //offline/coveropen/outofpaper
            if (status.coverOpen) {
                errorHeader=@"Aviso Tapa Abierta";
                errorMessage=@"Comprobar la tapa de la impresora e intentar de nuevo";
                
            }else if (status.receiptPaperEmpty)
            {
                errorHeader=@"Aviso Papel Impresion ";
                errorMessage=@"Comprobar el papel de la impresora e intentar de nuevo";
            }
            [self printerStatusFailed];
            printSuccessful=NO;
            return printSuccessful;
        }
        
        if (totalAmountWritten < commandSize)
        {
            DLog(@"totalAmountWritten < commandSize");
            
            
            
            errorHeader=@"Error de impresion";
            [self printerStatusFailed];
            printSuccessful=NO;
            return printSuccessful;
        }
        if (totalAmountWritten==commandSize) {
            DLog(@"totalAmountWritten==commandSize");
            printSuccessful=YES;
            //TESTED-non functional
            //            if (status.receiptPaperNearEmptyInner) {
            //                errorHeader=@"Aviso papel por terminarse";
            //                errorMessage=@"Comprobar el papel";
            //                DLog(@"papel por terminarse");
            //
            //
            //            }
            //            if (status.receiptPaperNearEmptyOuter) {
            //                errorHeader=@"Aviso papel por terminarse";
            //                errorMessage=@"Comprobar el papel";
            //                DLog(@"papel por terminarse");
            //
            //
            //            }
            
            DLog(@"seteando el tiempo para la siguiente impresion..........");
            int time=[self calculatePrintingTime:stringToPrint];
            [NSTimer scheduledTimerWithTimeInterval:time
                                             target:self
                                           selector:@selector(startPrinting)
                                           userInfo:nil repeats:NO];
            //printer succesful print the data setting the timer for the next part.
            [PrinterQueue removePrintQueue];
            //[self restartCancelTimer];
            //-------
            return printSuccessful;
        }
    }
    //printer off call this exception
    @catch (PortException *exception)
    {
        errorHeader=@"Error de impresion, favor de volver a intentar";
        [self printerStatusFailed];
        DLog(@"catchException");
        printSuccessful=NO;
        return printSuccessful;
        
    }
    @finally
    {
        free(commandsToSendToPrinter);
        [SMPort releasePort:starPort];
        return printSuccessful;
    }
}


+(int) calculatePrintingTime:(NSString*) stringToPrint
{
    float length=[stringToPrint length];
    length=(length/200)+0.6f;
    //length=(length/150)+0.5f;
    int total= [[NSNumber numberWithFloat:length] intValue];
    DLog(@"Tiempo para imprimir :%i segs",total);
    return  total;
}

+(BOOL) getPrintingStatus{
    return statusOK;
}


-(void) dealloc
{
    [printQueue release];
    [super dealloc];
}
@end
