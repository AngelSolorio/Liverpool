//
//  SaleOptionsViewController.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 03/07/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericDialogViewController.h"
#import "GenericOptionsViewController.h"

@interface SaleOptionsViewController : UIViewController <GenericActionDelegate,GenericOptionDelegate>
{
    UIButton *btnNormal;
    UIButton *btnMesaRegalo;
    UIButton *btnSOMS;
    UIButton *btnRestaurant;
    UIButton *btnDulceria;
    BOOL isRefound;
    BOOL dismissNavBar;
}
@property (nonatomic,retain) IBOutlet UIButton *btnNormal;
@property (nonatomic,retain) IBOutlet UIButton *btnMesaRegalo;
@property (nonatomic,retain) IBOutlet UIButton *btnSOMS;
@property (nonatomic,retain) IBOutlet UIButton *btnRestaurant;
@property (nonatomic,retain) IBOutlet UIButton *btnDulceria;

@property (nonatomic) BOOL isRefound;


-(IBAction) saleNormal;
-(IBAction) saleMesaRegalo;
-(IBAction) saleSOMS;
-(IBAction) saleRestaurant;
-(IBAction) saleDulceria;

-(void) performAction:(NSString*) txtData : (ActionType) actionType;
-(void) setLayout;

-(void) performOptionAction:(int) index :(NSString*) value ;
-(void) displayRefundReasonView;
@end
