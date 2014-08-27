//
//  CancelTicketViewController.h
//  CardReader
//
//  Created by Jonathan Esquer on 02/10/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "LiverpoolRequest.h"
#import "CancelTicketData.h"
#import "NumberKeypadDecimalPoint.h"
#import "GenericCardReaderViewController.h"
#import "CardDataList.h"

@interface CancelTicketViewController : UIViewController <UITextFieldDelegate,WsCompleteDelegate,GenericReaderDelegate>
{
    UIButton *btnOk;
    UIButton *btnClose;

    UITextField *txtField1;
    UITextField *txtField2;
    
    UILabel *txtLbl1;
    UILabel *txtLbl2;
    
    CancelTicketData *cancelData;
    NumberKeypadDecimalPoint			*numberKeyPad;
    NSMutableArray *cardsArray;
    CardDataList *cards;
    GenericCardReaderViewController *reader;
}

@property (nonatomic ,retain) IBOutlet     UIButton *btnOk;
@property (nonatomic ,retain) IBOutlet     UIButton *btnClose;
@property (nonatomic ,retain) IBOutlet     UITextField *txtField1;
@property (nonatomic ,retain) IBOutlet     UITextField *txtField2;
@property (nonatomic ,retain) IBOutlet     UILabel *txtLbl1;
@property (nonatomic ,retain) IBOutlet     UILabel *txtLbl2;
@property (nonatomic, retain) NumberKeypadDecimalPoint *numberKeyPad;


-(NSString*) selectCancelType;
-(void) startCancelTransactionRequest;
-(void) cancelRequestParsing:(NSData*) data;
-(IBAction)printCancelTicket;
-(IBAction)close:(id)sender;
-(BOOL) validateData;

@end
