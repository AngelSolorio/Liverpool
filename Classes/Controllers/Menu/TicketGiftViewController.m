//
//  TicketGiftViewController.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 14/05/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "TicketGiftViewController.h"
#import "Styles.h"
#import "Session.h"
#import "CardReaderAppDelegate.h"
@implementation TicketGiftViewController
@synthesize btnGiftY,btnGiftN;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Styles bgGradientColorPurple:self.view];
    [Styles silverButtonStyle:btnGiftY];
    [Styles silverButtonStyle:btnGiftN];


	//[Styles silverButtonStyle:btnOk];
    // Do any additional setup after loading the view from its nib.
}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) setTicketGiftFlag:(id) sender
{
    UIButton *btn=(UIButton*) sender;

    if (btn ==btnGiftY) {
        // ticket is for gift
        [Session setIsTicketGift:YES];
    }
    if (btn==btnGiftN) {
        //ticket is not for gift
        [Session setIsTicketGift:NO];
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) mainScreen];

}
-(void) dealloc
{
    [btnGiftY release];
    [btnGiftN release];
    [super dealloc];
    
}
@end
