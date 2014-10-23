//
//  ContactViewController.h
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 20/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  CONTACTINFOFILLEDUP_NOTIFICATION @"setCostumerContactInfo"
@interface ContactViewController : UIViewController <UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UITextField *telephoneFld;
@property (retain, nonatomic) IBOutlet UITextField *telephoneConfirmationFld;
@property (retain, nonatomic) IBOutlet UITextField *birthdayFld;
@end
