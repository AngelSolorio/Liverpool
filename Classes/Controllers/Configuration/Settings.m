//
//  Settings.m
//  IOPhoneTest
//
//  Created by sdtpig on 8/12/09.
//  Copyright 2009 Star Micronics Co., Ltd.. All rights reserved.
//

#import "Settings.h"
#import "Styles.h"
#import "Tools.h"
#import "Session.h"
#import "LoginParser.h"
#import "CardReaderAppDelegate.h"
@class LoginViewController;
@implementation Settings
@synthesize ctrlPrinterType;
@synthesize lblIpAdress;
@synthesize txtIPAddress;
@synthesize btnOk,btnDeSynch;

-(IBAction)Ok
{
	NSString* obj = @"";
	NSString* obj2 = @"mini";
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([ctrlPrinterType selectedSegmentIndex]==0){//bluetooth mode {
        DLog(@"BT mode");
        obj=@"BT:";
    }
    else{ // WiFi Mode
        obj=[NSString stringWithFormat:@"TCP:%@",[txtIPAddress text]];
        DLog(@"TCP:%@",[txtIPAddress text]);
    }

    DLog(@"Printer mode : %@",obj);
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
	NSData *myEncodedObject2 = [NSKeyedArchiver archivedDataWithRootObject:obj2];
	[defaults setObject:myEncodedObject forKey:@"programIPAddres"];
	[defaults setObject:myEncodedObject2 forKey:@"programPortSettings"];
	[defaults synchronize];
	[txtIPAddress resignFirstResponder];
	[textField_portSettings resignFirstResponder];
	//[self dismissModalViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];

	
	[Tools displayAlert:@"Aviso" message:@"Impresora Configurada"];
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(IBAction)selectPrinterType:(id)sender
{
    switch ([ctrlPrinterType selectedSegmentIndex]) {
        case 0: //BT
            [txtIPAddress setHidden:YES];
            [lblIpAdress setHidden:YES];
            break;
        case 1: //WiFi
            [txtIPAddress setHidden:NO];
            [lblIpAdress setHidden:NO];
            break;
        default:
            break;
    }
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:@"programIPAddres"];
    NSString* obj = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	txtIPAddress.text = obj;
	
	myEncodedObject = [defaults objectForKey:@"programPortSettings"];
    NSString *obj2 = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	textField_portSettings.text = obj2;
	
	[Styles bgGradientColorPurple:self.view];
	[Styles silverButtonStyle:btnOk];
	self.title=@"Impresoras";
    
    [Styles silverButtonStyle:btnDeSynch];
    

}

-(IBAction)desynchronize:(id) sender
{
    NSString *terminal=[Session getTerminal];
    if ([terminal length]==0) 
		[Tools displayAlert:@"Error" message:@"Esta terminal no esta registrada"];
    else 
        [self startDesynchronizeRequest];  
}

-(void) startDesynchronizeRequest
{
	//*** find item request code ***/x
	[Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
	NSString *terminal=[Session getTerminal];
	NSMutableArray *pars=[NSMutableArray arrayWithObjects:terminal,nil];
	[liverPoolRequest sendRequest:@"unregisterTerminal" forParameters:pars forRequestType:unregisterRequest]; 
	[liverPoolRequest release];
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{

    if (requestType==unregisterRequest) 
		[self unregisterRequestParsing:receivedData];
}
-(void) unregisterRequestParsing:(NSData*) data
{
	[Tools stopActivityIndicator];
	LoginParser *loginParser=[[LoginParser alloc] init];
	DLog(@"antes de empezar");
	[loginParser startParser:data];
	DLog(@"termino");
	if([loginParser isLoginSuccesful])
	{
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];
//        [Tools resetStore];
//        [[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginViewController] viewDidAppear:YES];
//        
        DLog(@"tools reset");
        LoginViewController *loginView=[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginViewController];
        [loginView logout];
        [Session setTerminal:@""];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];
        [self dismissViewControllerAnimated:NO completion:nil];
        [Tools resetStore];
        //[[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginViewController] viewDidAppear:YES];
        
	}
	else
		[Tools displayAlert:@"Error" message:[loginParser returnName]];
	[loginParser release];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	textField.inputAccessoryView=[Tools inputAccessoryView:textField];

}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
}

- (void)dealloc {
    DLog(@"settings DEALLOC");
    [btnDeSynch release],btnDeSynch=nil;

	[btnOk release], btnOk = nil;
    [super dealloc];
}


@end
