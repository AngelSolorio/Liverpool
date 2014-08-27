//
//  GenericCancelViewController.m
//  CardReader
//
//  Created by Jonathan Esquer on 28/09/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "GenericCancelViewController.h"
#import "Tools.h"
#import "Styles.h"
@implementation GenericCancelViewController
@synthesize  txtLbl1,txtLbl2,txtField1,txtField2,okBtn,delegate,actionType,scanDevice;
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
    txtField1.inputAccessoryView=[Tools inputAccessoryView:txtField1];
    txtField2.inputAccessoryView=[Tools inputAccessoryView:txtField2];

    [Styles bgGradientColorPurple:self.view];
    [Styles silverButtonStyle:okBtn];
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
	[delegate performAction:[txtField1 text] :[txtField2 text] :actionType];
}
-(void) initView:(NSString*) lblTxt1 :(NSString*) lblTxt2 :(CancelType) aType
{
    txtLbl1.text=[lblTxt1 copy];
    txtLbl2.text=[lblTxt2 copy];

    actionType=aType;
    
    if (aType ==refundActionType) {
        //txtField2;
    }
  
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
	txtField1.text=barcode;
    
	NS_DURING {
		
        
	} NS_HANDLER {
		
		DLog(@"%@", [localException name]);
		DLog(@"%@", [localException reason]);
		
	} NS_ENDHANDLER
}

//----------------------------------------
//            TEXTFIEL DELEGATE
//----------------------------------------

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
	CGPoint textFieldCord=textField.center;
	
	CGRect viewCords=self.view.frame;
	
	viewCords.origin.y=viewCords.origin.y-textFieldCord.y+140;
	
	self.view.frame=viewCords;
    [UIView commitAnimations];
    
    if([textField isEqual:txtField2]&&actionType==refundActionType){
        if (!self.numberKeyPad) {
            self.numberKeyPad = [NumberKeypadDecimalPoint keypadForTextField:textField];
        }else {
        //if we go from one field to another - just change the textfield, don't reanimate the decimal point button
        self.numberKeyPad.currentTextField = textField;
        }
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

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	if (numberKeyPad) {
		numberKeyPad.currentTextField = textField;
	}
	return YES;
}



-(void) dealloc
{
    DLog(@"cancelgenericDialog dealloc");
    [delegate release];
    [txtField1 release];
    [txtField2 release];
    [txtLbl1 release];
    [txtLbl2 release];
    [okBtn release];
    [super dealloc];
}

@end
