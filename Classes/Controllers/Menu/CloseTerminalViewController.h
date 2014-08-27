//
//  CloseTerminalViewController.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiverPoolRequest.h"
@class CloseTerminalData;
@interface CloseTerminalViewController : UIViewController <WsCompleteDelegate,UIAlertViewDelegate>
{    
    UILabel *lblComp;
    UILabel *lblRefund;
    UILabel *lblDifference;
    UILabel *lblDelivery;
    UILabel *lblPoints;
    UILabel *lblPaperVoucher;

    UIButton *btnCancel;
    UIButton *btnCloseTerminal;
    
    UILabel *lblStore;
    UILabel *lblTerminal;
    UILabel *lblDate;
    
    BOOL    toPrint;
    
    CloseTerminalData *closeData;
    
    NSTimer *dateTimer;
}

@property (nonatomic,retain) IBOutlet UILabel *lblComp;
@property (nonatomic,retain) IBOutlet UILabel *lblRefund;
@property (nonatomic,retain) IBOutlet UILabel *lblDifference;
@property (nonatomic,retain) IBOutlet UILabel *lblDelivery;
@property (nonatomic,retain) IBOutlet UILabel *lblPoints; 
@property (nonatomic,retain) IBOutlet UILabel *lblPaperVoucher; 

@property (nonatomic,retain) IBOutlet UIButton *btnCancel; 
@property (nonatomic,retain) IBOutlet UIButton *btnCloseTerminal;
@property (nonatomic,retain) IBOutlet UILabel *lblStore;
@property (nonatomic,retain) IBOutlet UILabel *lblTerminal;
@property (nonatomic,retain) IBOutlet UILabel *lblDate;


-(void) startClock;
-(IBAction)closeTerminalRequest:(id)sender;
-(IBAction)cancel:(id)sender;
-(void) performResults:(NSData *)receivedData :(RequestType) requestType;
-(void) startCloseTerminalRequest:(NSString*) cerrarTerm;
-(void) refreshLabelData;
-(void) printCloseTerminalTicket;

@end
