//
//  ContactViewController.m
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 20/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "ContactViewController.h"
#import "Contact.h"
#import "Styles.h"
@interface ContactViewController ()
@end

@implementation ContactViewController
@synthesize registerBtn = _registerBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [Styles bgGradientColorPurple:self.view];
    [Styles silverButtonStyle:self.registerBtn];
    UITapGestureRecognizer *dismissKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboardTap];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    NSLog(@"Touch happend at location %f, %f",locationPoint.x,locationPoint.y);
}


- (IBAction)registerContactInfo:(id)sender {
    UIAlertView *error;
    Contact *contact = [[Contact alloc] initWithTelephone:self.telephoneFld.text telephoneConfirmation:self.telephoneConfirmationFld.text birthday:self.birthdayFld.text];
    if ([contact valid]) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSDictionary *contactInfo = [NSDictionary dictionaryWithObjectsAndKeys:contact, @"contact",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:CONTACTINFOFILLEDUP_NOTIFICATION object:nil userInfo:contactInfo];
        }];
    } else{
        error = [[UIAlertView alloc] initWithTitle:@"Error" message:[contact completeErrors] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Aceptar", nil];
        [error show];
    }
}

#pragma mark - Keyboard Notifications Methods

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    // the keyboard is showing so resize the table's height
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y = -100;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    // the keyboard is hiding reset the table's height
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 20;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)dealloc {
    [_telephoneFld release];
    [_telephoneConfirmationFld release];
    [_birthdayFld release];
    [_registerBtn release];
    [super dealloc];
}
@end
