//
//  GenericDialogViewController.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 29/06/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "GenericDialogViewController.h"
#import "Tools.h"
#import "Styles.h"
@implementation GenericDialogViewController
@synthesize  txtLbl,txtField,okBtn,delegate,actionType,scanDevice,exitBtn;
@synthesize numberKeyPad;

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
    // Do any additional setup after loading the view from its nib.
    txtField.inputAccessoryView=[Tools inputAccessoryView:txtField];
    [Styles bgGradientColorPurple:self.view];
    [Styles silverButtonStyle:okBtn];
    [Styles silverButtonStyle:exitBtn];

}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
-(void) viewWillDisappear:(BOOL)animated
{
        [scanDevice removeDelegate:self];
        [scanDevice disconnect];
        scanDevice = nil;
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction) okAction:(id)sender
{
	[delegate performAction:[txtField text] :actionType];
}
-(IBAction) exitAction:(id)sender
{
	[delegate performExitAction];
}
-(void) initView:(NSString*) lblTxt :(ActionType) aType :(BOOL) turnOnReader
{
    txtLbl.text=[lblTxt copy];
    actionType=aType;
    
    if (turnOnReader) {
            scanDevice = [Linea sharedDevice];
            [scanDevice setDelegate:self];
            [scanDevice connect];
        
    }
    
}
-(void) initViewWithDecimal:(NSString*) lblTxt :(ActionType) aType :(BOOL) turnOnDecimal
{
    txtLbl.text=[lblTxt copy];
    actionType=aType;
    
    
}

//----------------------------------------
//            BARCODE ANALYSIS
//----------------------------------------
#pragma mark -
#pragma mark BARCODE ANALYSIS

-(void)barcodeData:(NSString *)barcode
			  type:(int)type
{
    
	DLog(@"%@", barcode);
	txtField.text=barcode;
    
	NS_DURING {
		
        
	} NS_HANDLER {
		
		DLog(@"%@", [localException name]);
		DLog(@"%@", [localException reason]);
		
	} NS_ENDHANDLER
}

//----------------------------------------
//            TEXTFIEL DELEGATE
//----------------------------------------
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	if (numberKeyPad) {
		numberKeyPad.currentTextField = textField;
	}
	return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; 
	
	CGPoint textFieldCord=textField.center;
	
	CGRect viewCords=self.view.frame;
	
	viewCords.origin.y=viewCords.origin.y-textFieldCord.y+140;
	
	self.view.frame=viewCords;
    [UIView commitAnimations];
    
    		/*
		 Show the numberKeyPad
		 */
		if (!self.numberKeyPad) {
			self.numberKeyPad = [NumberKeypadDecimalPoint keypadForTextField:textField];
		}else {
			//if we go from one field to another - just change the textfield, don't reanimate the decimal point button
			self.numberKeyPad.currentTextField = textField;
		}
	
	
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; 
	
	CGPoint textFieldCord=textField.center;
	
	CGRect viewCords=self.view.frame;
	
	viewCords.origin.y=viewCords.origin.y+textFieldCord.y-140;
	
	self.view.frame=viewCords;
    [UIView commitAnimations];
    
    [self.numberKeyPad removeButtonFromKeyboard];
    self.numberKeyPad = nil;

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	
}

-(void) dealloc
{
    DLog(@"genericDialog dealloc");
    [exitBtn release];
    [delegate release];
    [txtField release];
    [txtLbl release];
    [okBtn release];
    [super dealloc];
}
@end
