//
//  WithdrawScreenViewController.h
//  CardReader
//
//  Created by Jonathan Esquer on 20/09/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiverpoolRequest.h"
#import "NumberKeypadDecimalPoint.h"
#import "Session.h"
#import "Tools.h"
#import "TicketGeneratorViewController.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
#import "WithdrawDataList.h"
#import "Seller.h"
#import "PaymentParser.h"
#import "QuartzCore/QuartzCore.h"

@interface WithdrawScreenViewController : UIViewController <UITextFieldDelegate,WsCompleteDelegate,
                                                            UIPickerViewDelegate,UIPickerViewDataSource
                                                            ,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NumberKeypadDecimalPoint			*numberKeyPad;
    WithdrawDataList *drawList;
    NSArray *amountList;
    NSArray *quantityList;
    NSString *strQuantity;
    NSString *strAmount;
}

@property (assign, nonatomic) IBOutlet UITextField *txtAmount;
@property (assign, nonatomic) IBOutlet UITextField *txtQuantity;
@property (assign, nonatomic) IBOutlet UIButton *btnWithdraw;
@property (assign, nonatomic) IBOutlet UIButton *btnAddAmount;
@property (nonatomic, retain) NumberKeypadDecimalPoint *numberKeyPad;
@property (assign, nonatomic) IBOutlet UIButton *btnExit;
@property (assign, nonatomic) IBOutlet UIPickerView *pckDraws;
@property (assign, nonatomic) IBOutlet UILabel *lblWithdrawAlert;
@property (assign, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic) IBOutlet UITableView *aTableView;
@property (assign, nonatomic) IBOutlet UIButton *btnTableExit;
@property (assign, nonatomic) IBOutlet UIButton *btnViewTable;
@property (assign, nonatomic) IBOutlet UIButton *btnViewTableBack;

-(NSString*) selectWithdrawType;
-(void) withdrawRequestParsing:(NSData*) data;
-(void) startWithdrawTransactionRequest:(BOOL) cancelFlag;
-(void) showWithdrawAlert;

- (IBAction)viewDrawList:(id)sender;
- (IBAction) printTicket;
- (IBAction)addWithdrawToList:(id)sender;
- (IBAction)startRequest:(id)sender;
- (IBAction)exitAction:(id)sender;

@end
