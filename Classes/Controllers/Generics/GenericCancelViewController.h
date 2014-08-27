//
//  GenericCancelViewController.h
//  CardReader
//
//  Created by Jonathan Esquer on 28/09/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "NumberKeypadDecimalPoint.h"


typedef enum {
	cancelActionType,
    refundActionType
} CancelType;
@protocol CancelActionDelegate <NSObject>
-(void) performAction:(NSString*) txtData1 :(NSString*) txtData2 : (CancelType) actionType;
@end

@interface GenericCancelViewController : UIViewController <LineaDelegate,UITextFieldDelegate>

{
    UIButton *okBtn;
    UITextField *txtField1;
    UITextField *txtField2;

    UILabel *txtLbl1;
    UILabel *txtLbl2;

    id <CancelActionDelegate> delegate;
	CancelType actionType;
	Linea   *scanDevice;
    NumberKeypadDecimalPoint			*numberKeyPad;

    
}

@property (nonatomic ,retain) IBOutlet     UIButton *okBtn;
@property (nonatomic ,retain) IBOutlet     UITextField *txtField1;
@property (nonatomic ,retain) IBOutlet     UITextField *txtField2;
@property (nonatomic ,retain) IBOutlet     UILabel *txtLbl1;
@property (nonatomic ,retain) IBOutlet     UILabel *txtLbl2;
@property (nonatomic ,retain) IBOutlet     Linea   *scanDevice;

@property (nonatomic)                       CancelType actionType;
@property (nonatomic,retain)	id <CancelActionDelegate> delegate;
@property (nonatomic, retain) NumberKeypadDecimalPoint *numberKeyPad;


-(IBAction) okAction:(id)sender;
-(void) initView:(NSString*) lblTxt1 :(NSString*) lblTxt2 :(CancelType) aType;
@end
