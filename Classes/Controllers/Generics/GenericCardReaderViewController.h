//
//  GenericCardReaderViewController.h
//  CardReader
//
//  Created by Jonathan Esquer on 24/12/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "Card.h"
#import "Tools.h"
#import "Session.h"

@protocol GenericReaderDelegate <NSObject>
-(void) performAction:(NSMutableArray*) cardArray;
-(void) performExitAction;

@end
@interface GenericCardReaderViewController : UIViewController <LineaDelegate>
{
	CGFloat animatedDistance;
	IBOutlet UILabel                   *lblTitle;
	IBOutlet UILabel                   *lblCard;
	IBOutlet UILabel                   *lblCardNumber;
	IBOutlet UILabel                   *lblUser;
	IBOutlet UILabel                   *lblUserText;
	IBOutlet UILabel                   *lblDate;
	IBOutlet UILabel                   *lblDateText;
	IBOutlet UILabel                   *lblSubtitle;
	IBOutlet UILabel                   *lblOperation;
	IBOutlet UILabel                   *lblBalance;
    IBOutlet UILabel                   *lblDigits;

	IBOutlet UIButton				   *btnPay;
	IBOutlet UITextField			   *txtAuthCode;
	IBOutlet UITextField			   *txtAmount;
    
	Linea                              *scanDevice;
	NSMutableString						*status;
	
	Card								*cardData;
	NSMutableArray						*cardsArray;
    NSMutableArray                      *cardsBin;
    int                                 cardType;
    int                                 cardCount;
    BOOL                                firstPaymentDone;
    
    id <GenericReaderDelegate> delegate;

}

@property (retain, nonatomic) IBOutlet UILabel                   *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel                   *lblCard;
@property (retain, nonatomic) IBOutlet UILabel                   *lblCardNumber;
@property (retain, nonatomic) IBOutlet UILabel                   *lblUser;
@property (retain, nonatomic) IBOutlet UILabel                   *lblUserText;
@property (retain, nonatomic) IBOutlet UILabel                   *lblDate;
@property (retain, nonatomic) IBOutlet UILabel                   *lblDateText;
@property (retain, nonatomic) IBOutlet UILabel                   *lblSubtitle;
@property (retain, nonatomic) IBOutlet UILabel                   *lblOperation;
@property (retain, nonatomic) IBOutlet UILabel                   *lblBalance;
@property (retain, nonatomic) IBOutlet UILabel                   *lblDigits;

@property (retain, nonatomic) IBOutlet UITextField			     *txtAuthCode;
@property (retain, nonatomic) IBOutlet UITextField			     *txtAmount;
@property (retain, nonatomic) IBOutlet UIButton					 *btnPay;
@property (retain, nonatomic)		   NSMutableArray			 *cardsArray;
@property (retain, nonatomic)		   NSMutableArray			 *cardsBin;


@property (assign, nonatomic) IBOutlet UIButton *btnCashPay;
@property (assign, nonatomic) IBOutlet UIButton *btnCardPay;
@property (assign, nonatomic) IBOutlet UIButton *btnMonederoPay;
@property (assign, nonatomic) IBOutlet UIButton *btnAmountBack;
@property (assign, nonatomic) IBOutlet UIButton *btnAmountOk;
@property (assign, nonatomic) IBOutlet UIButton *btnCardBack;
@property (assign, nonatomic) IBOutlet UIButton *btnCardOk;
@property (nonatomic)          int        cardCount;
@property (nonatomic,retain)	id <GenericReaderDelegate> delegate;


//-(BOOL) validatePaymentData;
//-(BOOL) isValidAmountValue;
-(void) addCardToCardArray;
//-(void) resetLabels;
//-(void) keyboardSlideDown: (UITextField *) textField;
//-(void) keyboardSlideUp: (UITextField *) textField;
//-(NSString*) selectTypeOfSale;
//-(void) setLayout;
//
//- (IBAction)selectedPayment:(id)sender;
//- (IBAction)okAmountBtn:(id)sender;
//- (IBAction)removeAllSubviews:(id)sender;
- (IBAction)okCardReadAction:(id)sender;
//-(void) showCardReadview;
//-(void) showAmountView;
-(void) identifyBINCard;
//-(void) readingCards;
-(BOOL) IsValidEglobalCard;
-(void) resetLabels;

@end
