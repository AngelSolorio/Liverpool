//
//  GenericDialogViewController.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 29/06/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "NumberKeypadDecimalPoint.h"

typedef enum {
	somsSaleType,
    foodSaleType,
    itemOptionsQuantity,
    itemOptionsModifier,
    refundType,
    monederoRead
} ActionType;

@protocol GenericActionDelegate <NSObject> 
-(void) performAction:(NSString*) txtData : (ActionType) actionType;
-(void) performExitAction;

@end


@interface GenericDialogViewController : UIViewController <LineaDelegate,UITextFieldDelegate>
{
    UIButton *okBtn;
    UIButton *exitBtn;
    UITextField *txtField;
    UILabel *txtLbl;
    id <GenericActionDelegate> delegate;
	ActionType actionType;
	Linea   *scanDevice;
    NumberKeypadDecimalPoint			*numberKeyPad;

}

@property (nonatomic ,retain) IBOutlet     UIButton *okBtn;
@property (nonatomic ,retain) IBOutlet     UIButton *exitBtn;
@property (nonatomic ,retain) IBOutlet     UITextField *txtField;
@property (nonatomic ,retain) IBOutlet     UILabel *txtLbl;
@property (nonatomic ,retain) IBOutlet     Linea   *scanDevice;

@property (nonatomic)                       ActionType actionType;
@property (nonatomic,retain)	id <GenericActionDelegate> delegate;
@property (nonatomic, retain)               NumberKeypadDecimalPoint *numberKeyPad;


-(IBAction) okAction:(id)sender;
-(void) initView:(NSString*) lblTxt :(ActionType) aType :(BOOL)turnOnReader;
-(void) initViewWithDecimal:(NSString*) lblTxt :(ActionType) aType :(BOOL) turnOnDecimal;

@end
