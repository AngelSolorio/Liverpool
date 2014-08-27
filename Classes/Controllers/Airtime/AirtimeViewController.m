//
//  AirtimeViewController.m
//  CardReader
//


#import "AirtimeViewController.h"
#import "CardReaderAppDelegate.h"
#import "Styles.h"
#import "Tools.h"
#import "AirtimeParser.h"
#import "Seller.h"
#import "Card.h"
#import "Session.h"
#import "FindItemParser.h"
#import "TicketGeneratorViewController.h"
@implementation AirtimeViewController
@synthesize lblProduct,txtPhoneNumber,txtConfirmsPhoneNumber,txtBarCode,btnBuyCredits,viewPhoneData,amountViewController,viewBarCodeScan,btnShowWiewBarCodeScan;
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
    [super viewDidLoad];
	[Styles bgGradientColorPurple:self.view];
	viewBarCodeScan.hidden=(viewBarCodeScan.hidden==TRUE)?FALSE:TRUE;
	[Styles scanReaderViewStyle:viewBarCodeScan];

	//cardreader SDK
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
	txtPhoneNumber.inputAccessoryView=[Tools inputAccessoryView:txtPhoneNumber];
	txtConfirmsPhoneNumber.inputAccessoryView=[Tools inputAccessoryView:txtConfirmsPhoneNumber];
	txtBarCode.inputAccessoryView=[Tools inputAccessoryView:txtBarCode];

}
-(void) viewDidAppear:(BOOL)animated
{	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];

	[super viewDidAppear:animated];

}

-(void) viewWillDisappear:(BOOL)animated
{
	[scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;
	
	[super viewWillDisappear:animated];
}
-(void) viewWillAppear:(BOOL)animated
{
	[self checkPrinterStatus];
	[super viewWillAppear:animated];
}

-(void) checkPrinterStatus
{
	//checks if the printer is online and warns the user if is not on.
	[Tools showViewAnimation:self.view];
	TicketGeneratorViewController *tk=[[TicketGeneratorViewController alloc] init];
	if (![tk checkPrinterStatus]) {
		//[btnPay setEnabled:NO];
	}
	[tk release];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//	
//}

-(IBAction) buyCreditsAction:(id)sender{
	
	if (![Tools confirmPhoneValidation:txtPhoneNumber :txtConfirmsPhoneNumber])
		[Tools displayAlert:@"Error" message:@"los numeros telefonicos no coinciden"];
	
	else if ([Tools isTextFieldEmpty:txtBarCode]||[Tools isTextFieldEmpty:txtPhoneNumber]||[Tools isTextFieldEmpty:txtConfirmsPhoneNumber] ) 
		[Tools displayAlert:@"Error" message:@"verificar los campos vacios"];
	else {
		//start Request
		DLog(@"Salio");
		//[self startRequest:txtBarCode.text];
		[self showCardDataReaderView];
	}
	
}
-(IBAction) exitCreditsAction:(id)sender{
	
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeAirTimeScreen];
	
}
-(IBAction) closeViewBarCodeScan:(id)sender{
	//cardreader SDK
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
	
	//viewBarCodeScan.hidden=(viewBarCodeScan.hidden==TRUE)?FALSE:TRUE;
	txtBarCode.text=@"";
	[self.view endEditing:YES];
	[Tools showViewAnimation:viewBarCodeScan];
}
-(IBAction) barcodeAccepted:(id)sender
{
	if ([txtBarCode.text length]==0) {
		[Tools displayAlert:@"Aviso" message:@"Favor de introducir el codigo"];
		return;
	}
	
	//viewBarCodeScan.hidden=(viewBarCodeScan.hidden==TRUE)?FALSE:TRUE;
	[self.view endEditing:YES];
	[self startRequest:txtBarCode.text];

}


-(void) showCardDataReaderView
{	
	
	cardDataView=[[CardDataViewController alloc]initWithNibName:@"CardDataViewController" bundle:nil];
	//[self presentModalViewController:cardDataView animated:YES];
    [self presentViewController:cardDataView animated:YES completion:nil];

	[cardDataView setDelegate:self];
	//[cardDataView.view setHidden:YES];
	
	//cardDataView.lblPaymentAmount.text=[amountViewController getAmountSelected];
	cardDataView.lblPaymentAmount.text=[itemModel price];

	//[cardDataView showCardDataView];
	
}
-(void) hideCardDataReaderView
{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
	//[cardDataView hideCardDataView];
}
//----------------------------------------
//           DELEGATE
//----------------------------------------
-(void) performCardDataTransaction:(Card *)cardData
{
	[self startRequestAirtime];


}
//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS

 -(void) startRequestAirtime
 {
 [Tools startActivityIndicator:self.view];
 
 // find item request code 
 LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
 liverPoolRequest.delegate=self;
 
 NSString* phoneNumber=txtPhoneNumber.text;
 
 //seller
 Seller *seller=[[Seller alloc] init];
 seller.password=[Session getPassword];
 seller.userName=[Session getUserName];
 
	 //card
 cardData=[cardDataView.cardData copy];

 NSArray *pars=[NSArray arrayWithObjects:phoneNumber,itemModel,cardData,seller,nil];
 
 //load request
 [liverPoolRequest sendRequest:@"ventaTiempoAire" forParameters:pars forRequestType:airtimeRequest]; //TODO: cambiar a localized string
 
 [liverPoolRequest release];
 [seller release];
 [cardData release];
 
 }

 -(void) buyCreditsActionRequestParsing:(NSData*) data
 {
 //TODO: parsear
 AirtimeParser *airParser=[[AirtimeParser alloc] init];
 DLog(@"antes de empezar");
 [airParser startParser:data];
 DLog(@"termino");
	 if([airParser getStateOfMessage])
	 {	
		 [Session setDocTo:airParser.payment.docto];
		 [Tools displayAlert:@"Aviso" message:@"Compra Exitosa"];
		 [Session setDocTo:airParser.payment.docto];
		 [self printTicketAirTime:txtPhoneNumber.text];
		 [itemModel release];
	 }
	 else 
	 {	[Tools displayAlert:@"Error" message:[airParser getMessageResponse]];
		 [self printTicketAirTime:txtPhoneNumber.text]; //remove after
		 [self logoutRequest];
	 }	
	[airParser release];
	[Tools stopActivityIndicator];
	 
	 [self hideCardDataReaderView];

}
 

//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS
-(void) startRequest:(NSString*) barCode
{
	//*** find item request code ***/
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
	NSArray *pars=[NSArray arrayWithObjects:barCode,nil];
	[liverPoolRequest sendRequest:@"buscaProducto" forParameters:pars forRequestType:findRequest]; //cambiar a localized string
	[liverPoolRequest release];
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	if (requestType==findRequest) 
		[self findItemRequestParsing:receivedData];
	else 
		[self buyCreditsActionRequestParsing:receivedData];

	
}

-(void) findItemRequestParsing:(NSData*) data
{
	FindItemParser *findParser=[[FindItemParser alloc] init];
	DLog(@"antes de empezar");
	[findParser startParser:data];
	DLog(@"termino");
	itemModel=findParser.findItemModel;
	[itemModel retain];
	if (![findParser itemFounded]) {
		[Tools displayAlert:@"Error" message:@"No se Encontro el producto"];
		return;
	}
	else {
		lblProduct.text=itemModel.description;
		[scanDevice removeDelegate:self];
		[scanDevice disconnect];
		scanDevice = nil;		
		[Tools hideViewAnimation:viewBarCodeScan];
	}

	[findParser release];
}


////////////////////////////// LOGOUT ////////////////////////////////////
-(void) logoutRequest
{
	
	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
	
	Seller *seller=[[Seller alloc] init];
	seller.password=[Session getPassword];
	seller.userName=[Session getUserName];
	
	
	NSArray *pars;
	
	pars=[NSArray arrayWithObjects:seller,nil];
	
	[seller release];
	
	[liverpoolRequest sendRequest:@"logoutVendedor" forParameters:pars forRequestType:logoutRequest];
	[liverpoolRequest release];
}
////////////////////////////// PRINT TICKET ////////////////////////////////////

-(void) printTicketAirTime:(NSString*) phoneNumber
{
	
	TicketGeneratorViewController *tk=[[TicketGeneratorViewController alloc]init];
	tk.view.frame=CGRectMake(0, 0, 320, 460);
	//products
	NSArray *productList=[NSArray arrayWithObjects:itemModel,nil];
	
	//card
	//Card *cardData=cardDataView.cardData; // cambio Ruben 18/Enero/2012
	DLog(@" cardData ticketairtime:%@",[[cardDataView cardData] cardNumber]);
	[tk setProductList:productList];
	[tk setPaymentType:[cardDataView.ctrlPaymentType selectedSegmentIndex]];
	[tk	setCard:cardDataView.cardData]; // cambio Ruben 18/Enero/2012
	//[self presentModalViewController:tk animated:YES];
    [self presentViewController:tk animated:YES completion:nil];

    
	//[self.view addSubview:tk.view];
	//[tk printTicketAirtime:phoneNumber];
	//[tk generateTicket:productList];
	[tk release];
	
}
//----------------------------------------
//            BARCODE ANALYSIS
//----------------------------------------
#pragma mark -
#pragma mark BARCODE ANALYSIS

-(void)barcodeData:(NSString *)barcode 
			  type:(int)type 
{	
	if (viewBarCodeScan.hidden==FALSE) {
		if (txtBarCode!=nil) {
			txtBarCode.text=barcode;
		}
	}
	
	
	
	NS_DURING {
		
		//[self updateBattery];
		
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
	
	viewCords.origin.y=viewCords.origin.y-textFieldCord.y;
	
	self.view.frame=viewCords;
    [UIView commitAnimations];
	
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; 
	
	CGPoint textFieldCord=textField.center;
	
	CGRect viewCords=self.view.frame;
	
	viewCords.origin.y=viewCords.origin.y+textFieldCord.y;
	
	self.view.frame=viewCords;
    [UIView commitAnimations];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	[viewBarCodeScan endEditing:YES];
	
}

- (void)dealloc {
	
	[txtPhoneNumber release],txtPhoneNumber=nil;
	[txtConfirmsPhoneNumber release],txtConfirmsPhoneNumber=nil;
	[btnBuyCredits release],btnBuyCredits=nil;
	[viewPhoneData release],viewPhoneData=nil;
	[amountViewController release], amountViewController=nil;
	[viewBarCodeScan release],viewBarCodeScan=nil;
	[btnShowWiewBarCodeScan release], btnShowWiewBarCodeScan=nil;
	[txtBarCode release],txtBarCode=nil;
	[btnShowWiewBarCodeScan release],btnShowWiewBarCodeScan= nil;
	[cardDataView release];
	[lblProduct release], lblProduct=nil;
    [super dealloc];
}

@end
