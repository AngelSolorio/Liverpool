//
//  MonederoCardViewController.m
//  CardReader
//

#import "MonederoCardViewController.h"
#import "Session.h"
#import "Tools.h"
#import "BalanceParser.h"
#import "Balance.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
@implementation MonederoCardViewController
@synthesize txtMonederoNumber;
@synthesize btnOk;
@synthesize btnCancel;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//cardreader SDK
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
	txtMonederoNumber.inputAccessoryView=[Tools inputAccessoryView:txtMonederoNumber];
	[Styles bgGradientColorPurple:self.view];
	[Styles silverButtonStyle:btnOk];
	[Styles silverButtonStyle:btnCancel];

    [super viewDidLoad];
}

-(void) viewWillDisappear:(BOOL)animated
{
	[scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;
	[super viewWillDisappear:animated];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
//-(IBAction) validateMonederoCard
//{
//	if ([[txtMonederoNumber text] length]==0) {
//		[Tools displayAlert:@"Aviso" message:@"Favor de introducir un monedero"];
//	}else
//		[self startRequestBalanceMonedero:[txtMonederoNumber text]];
//}

-(IBAction) validateMonederoCard
{
	if ([[txtMonederoNumber text] length]==0) {
		[Tools displayAlert:@"Aviso" message:@"Favor de introducir un monedero"];
	}else
        [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) startRequestBalanceMonedero:(NSString*) barCode
{
	
	BalanceRequest *balanceRequest=[[BalanceRequest alloc] init];
	balanceRequest.delegate=self;
	NSString* segmentTextType=@"TSCCTE09";
	NSArray* pars=[NSArray arrayWithObjects:@"",barCode,nil];
	[balanceRequest sendRequest:segmentTextType forParameters:pars forRequestType:bRequest]; //cambiar a localized string
	[balanceRequest release];
	[Tools startActivityIndicator:self.view];
	
}

-(void) balanceRequestParsing:(NSData*) data
{
	
	BalanceParser* balanceParser=[[BalanceParser alloc] init];
	DLog(@"antes de empezar");
	[balanceParser startParser:data];
	DLog(@"termino");
	DLog(@"balance %@ ",[[[balanceParser balanceModel] error] description]);
	if([[balanceParser balanceModel] isError]){
		DLog(@"IsError");
	}else  if (([balanceParser balanceModel].sa)!=nil) {
		
		[Session setMonederoAmount:([balanceParser balanceModel].sa)];

	}else {
		[Tools displayAlert:@"Aviso" message:@"No se ha podido establecer comunicación con el servidor"];
	}
	[balanceParser release];
	
	[Tools stopActivityIndicator];
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	
		[self balanceRequestParsing:receivedData];

}
-(IBAction) exitMonedero
{
    [Session setMonederoNumber:@""];
  
	//[self dismissModalViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //patch 1.4.5 you cant continue if you cancel the monedero reading.
    //canceling the reading take you back to the scanview 
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeScreensToSaleView];

}

//----------------------------------------
//            BARCODE ANALYSIS
//----------------------------------------
#pragma mark -
#pragma mark BARCODE ANALYSIS

-(void)barcodeData:(NSString *)barcode 
			  type:(int)type 
{		
	NS_DURING {
	} NS_HANDLER {
		
		DLog(@"%@", [localException name]);
		DLog(@"%@", [localException reason]);
		
	} NS_ENDHANDLER

	[Session setMonederoNumber:barcode];
	txtMonederoNumber.text=barcode;

}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
}
- (void)dealloc {
	[btnOk release];
	[btnCancel release];
	scanDevice = nil;
	[txtMonederoNumber release]; txtMonederoNumber=nil;
    [super dealloc];
}


@end
