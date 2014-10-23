//
//  ContactViewController.m
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 20/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "ContactViewController.h"
#import "Contact.h"
@interface ContactViewController ()
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *dismissKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboardTap];
    for(UIView *view in self.view.subviews){
        NSLog(@"View of kind %@",[view class]);
    }
    NSLog(@"X %f Y %f W %f H %f",self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
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
        NSDictionary *contactInfo = [NSDictionary dictionaryWithObjectsAndKeys:contact, @"contact",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:CONTACTINFOFILLEDUP_NOTIFICATION object:nil userInfo:contactInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
        error = [[UIAlertView alloc] initWithTitle:@"Error" message:[contact completeErrors] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Aceptar", nil];
        [error show];
    }
}

- (void)dealloc {
    [_telephoneFld release];
    [_telephoneConfirmationFld release];
    [_birthdayFld release];
    [super dealloc];
}
@end
