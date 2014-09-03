//
//  LoginViewController.m
//  CardReader


#import "LoginViewController.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
#import "Tools.h"
#import "LoginParser.h"
#import "Session.h"
#import "Seller.h"
#import "LogoutParser.h"
#import "QuartzCore/QuartzCore.h"



@implementation LoginViewController
@synthesize vistaInterior,txtUser,txtPassword,darkView,configView,btnSynch,lblStore,lblTerminal,lblDate;
@synthesize terminalViewController,btnStart,btnUnlock,btnGuest;
@synthesize lblConfig;
@synthesize lblTerminalTxt;
@synthesize lblBranch;
@synthesize btnBranch;
@synthesize btnSave;
@synthesize lblServer;

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
	terminalViewController.delegate=self;
	[self styleApply];
	
	[Styles purpleButtonStyle:btnStart];
	[Styles purpleButtonStyle:btnUnlock];
	[Styles purpleButtonStyle:btnSynch];
	[Styles purpleButtonStyle:btnGuest];
	[Styles silverButtonStyle:btnBranch];
	[Styles silverButtonStyle:btnSave];
	
	[Styles purpleLabelText:lblConfig];
	[Styles purpleLabelText:lblTerminalTxt];
	[Styles purpleLabelText:lblBranch];
    [Styles purpleLabelText:lblServer];

	
	[btnGuest setTitle:@"F5" forState:UIControlStateNormal];
	//[btnGuest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	btnGuest.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	//btnGuest.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);	
	
	/*
	UIColor *color = UIColorFromRGBWithAlpha(0XE0068D,1);
	[btnStart setTitleColor:color forState:UIControlStateNormal];
	[btnUnlock setTitleColor:color forState:UIControlStateNormal];
	 */
	[Tools loadStore];
    
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
-(void) viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    DLog(@"viewillappear login");
    txtUser.text=@"";
	txtPassword.text=@"";
	
	
}
-(void) viewDidAppear:(BOOL)animated
{
    //reload info
    [super viewDidAppear:animated];
	DLog(@"viewdidappear login");
    
    //Tenemos que deslogear
	if ([Session getStatus]==VALID_SESSION) {
		DLog(@"Voy a deslogear");
		[self logout];
	}
    [self evaluationActivePOS];
    [self startClock];
    
    //cardreader SDK
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];

}
-(void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	DLog(@"Viewwilldisappear login");
    
    //cardreader SDK
    [scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;
    [self stopClock];

}
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
- (void)dealloc {
    
    [scanDevice removeDelegate:self];
	[lblServer release]; lblServer=nil;
    [vistaInterior release],vistaInterior=nil;
	[txtUser release]; txtUser=nil;
	[txtPassword release]; txtPassword=nil;
	[vistaInterior release],vistaInterior=nil;
	[darkView release], darkView=nil;
	[configView release],configView=nil;
	
	[btnSynch release],btnSynch=nil;
	terminalViewController=nil;
	[lblStore release],lblStore=nil;
	[lblTerminal release],lblTerminal=nil;
	[lblDate release], lblDate=nil;
	[btnStart release], btnStart = nil;
	[btnUnlock release], btnUnlock = nil;
	[btnGuest release], btnGuest = nil;
	
	[lblConfig release], lblConfig = nil;
	[lblTerminalTxt release], lblTerminalTxt = nil;
	[lblBranch release], lblBranch = nil;
	[btnBranch release], btnBranch = nil;
	[btnSave release], btnSave = nil;
	
    [super dealloc];
	
}
-(void) logout{
	[Tools startActivityIndicator:self.view];
	
	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
	liverpoolRequest.delegate=self;
	
	Seller *seller=[[Seller alloc] init];
//	seller.password=@"";
//	seller.userName=@"";
    seller.password=[Session getPassword];
	seller.userName=[Session getUserName];
	
//    NSString *tipoDeVenta=[Tools getTypeOfSaleBCString];

	NSArray *pars;
	
	pars=[NSArray arrayWithObjects:seller,nil];
	
	[seller release];
	
	[liverpoolRequest sendRequest:@"logoutVendedor" forParameters:pars forRequestType:logoutRequest];
	[liverpoolRequest release];
	[Session setStatus:CLOSE_SESSION];
}
//----------------------------------------
//            ACTIONS 
//----------------------------------------
-(IBAction) sellerSignOn:(id)sender{
	//TODO conexion y validaciones
	//[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) transactionMenuScreen];
	
	if ([self isValidFields]) 
		[self startRequest];
}
/*-(IBAction) guestSignOn:(id)sender{
 //TODO conexion y validaciones
 [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) transactionMenuScreen];
 
 }*/


-(IBAction) f5SignOn:(id)sender{
	//TODO especificar que unicamente podra realizar funciones de invitado
	//[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) mainScreen];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) transactionF5MenuScreen];
}

-(void) synchronized:(id)sender{
	[self isShowConfigView];
	
}

-(void) loadMenuView
{
	[Session setUserName:txtUser.text];
	[Session setPassword:txtPassword.text];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) transactionMenuScreen];
	
}


-(void) onTimer:(NSTimer *)timer;
{
	NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[timeFormatter setDateFormat:@"d/MMM/yyyy HH:mm:ss"];
	NSDate *stringTime = [NSDate date];
	NSString *formattedDateStringTime = [timeFormatter stringFromDate:stringTime];
	lblDate.text = formattedDateStringTime;
	
	/* NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	 [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	 [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	 NSDate *stringDate = [NSDate date];
	 NSString *formattedDateStringDate = [dateFormatter stringFromDate:stringDate];
	 lblDate.text = formattedDateStringDate;*/
}

-(void) startClock
{
	clockTimer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
	
}
-(void) stopClock
{
    if (clockTimer!=nil) {
      	[clockTimer invalidate];
        clockTimer=nil;
    }
}


//----------------------------------------
//            STYLES 
//----------------------------------------
-(void)styleApply{
	[Styles cornerView:vistaInterior];
	[Styles cornerView:configView];
	[Styles bgGradientColorPurple:self.view];
}
//----------------------------------------
//            VALIDATION 
//----------------------------------------

-(BOOL) isValidFields
{
	if ([txtUser.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""]) {
		[Tools displayAlert:@"Error" message:@"Favor de llenar los campos"];
		return NO;
	}else
		return YES;
}
-(void) evaluationActivePOS{
    DLog(@"evaluationActivePOS");
	if (([[Session getTerminal]length]==0)||([[Session getIdStore] length]==0)||([[Session getStore] length]==0)||([[Session getTerminal] isEqualToString:@""])) {
		btnSynch.hidden=FALSE;
	}else {
		btnSynch.hidden=TRUE;
	}
    [self refreshLabelData];

}
-(void) showViewsForStoreData{
	btnSynch.hidden=TRUE;
	[self refreshLabelData];
	
}
-(void) refreshLabelData{
    DLog(@"refreshLabelData");
    if ([[Session getStore]length]>0&&[[Session getTerminal]length]>0) {
        [lblStore setText:[Session getStore]];
        [lblTerminal setText:[@"T #: "stringByAppendingString:[Session getTerminal]]];
    }
    else {
        [lblStore setText:@"Sucursal"];
        [lblTerminal setText:@"Terminal"];

    }
    [lblTerminal setNeedsDisplay];
    [lblStore setNeedsDisplay];
    DLog(@"refreshLabelData end");
    
}
//----------------------------------------
//            TEXTFIELD DELEGATE
//----------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	textField.inputAccessoryView=[Tools inputAccessoryView:textField];
}
//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS
-(void) startRequest
{
	//*** find item request code ***/
	[Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
	NSString *user=txtUser.text;
	NSString *password=txtPassword.text;
	NSString *terminal=[Session getTerminal];
	NSMutableArray *pars=[NSMutableArray arrayWithObjects:user,password,terminal,nil];
	[liverPoolRequest sendRequest:@"loginVendedor" forParameters:pars forRequestType:loginRequest]; //cambiar a localized string
	[liverPoolRequest release];
}

-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	if (requestType==loginRequest) 
		[self loginRequestParsing:receivedData];
	if (requestType==logoutRequest) 
		[self logoutRequestParsing:receivedData];
  
	
}
-(void) logoutRequestParsing:(NSData*) data
{
	LogoutParser *logoutParser=[[LogoutParser alloc] init];
	DLog(@"antes de empezar");
	[logoutParser startParser:data];
	DLog(@"termino");
	if ([Session getStatus]!=CLOSE_SESSION) {
		[logoutParser isLogoutSuccesful];
	}
	[logoutParser release];
	[Tools stopActivityIndicator];
}

-(void) loginRequestParsing:(NSData*) data
{
	[Tools stopActivityIndicator];
	LoginParser *loginParser=[[LoginParser alloc] init];
	DLog(@"antes de empezar");
	[loginParser startParser:data];
	DLog(@"termino");
	if([loginParser isLoginSuccesful])
	{	
		//if the login is succesfull, the pass ann user is saved in session, then the session is closed
		[Session setStatus:VALID_SESSION];
		[Session setPassword:txtPassword.text];
		[Session setUserName:txtUser.text];
		[Session setUName:[loginParser returnName]];
		[self updateStoreList:loginParser.storeList];
		[self loadMenuView];
		
	}
	else 
		[Tools displayAlert:@"Error" message:[loginParser returnErrorMessage]];
	[loginParser release];
	
}

-(void) updateStoreList:(NSMutableArray*) storeList
{
    if ([storeList count]>0) {
        [Tools saveStoreToPlist:storeList];
    }
    
}
////////////////////////////// LOGOUT ////////////////////////////////////
-(IBAction) logoutRequest
{
	if ([[txtUser text]length] ==0||[[txtPassword text]length]==0) {
		[Tools displayAlert:@"Aviso" message:@"Introduzca los datos usuario y contraseña para desbloquear la cuenta"];
		return;
	}
	[Tools startActivityIndicator:self.view];
	
	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
	liverpoolRequest.delegate=self;
	
	Seller *seller=[[Seller alloc] init];
	seller.password=[txtPassword text];
	seller.userName=[txtUser text];
 
    NSString *tipoDeVenta=[Tools getTypeOfSaleBCString];

	NSArray *pars;
	
	pars=[NSArray arrayWithObjects:seller,tipoDeVenta,nil];
	
	[seller release];
	
	[liverpoolRequest sendRequest:@"logoutVendedor" forParameters:pars forRequestType:logoutRequest];
	[liverpoolRequest release];
}

//---------------------------------------
// TERMINAL DELEGATE
//---------------------------------------
-(void) isShowConfigView{
	darkView.hidden=darkView.hidden==TRUE?FALSE:TRUE;
	configView.hidden=configView.hidden==TRUE?FALSE:TRUE;
    
}	
-(void) showModal:(UIViewController*) aViewController{
	
	//[self presentModalViewController:aViewController animated:YES];
    
	[self presentViewController:aViewController animated:YES completion:nil];

}
//----------------------------------------
//            BARCODE ANALYSIS
//----------------------------------------
#pragma mark -
#pragma mark BARCODE ANALYSIS

-(void)barcodeData:(NSString *)barcode 
			  type:(int)type 
{	
	
	txtUser.text=barcode;
	
	NS_DURING {
		
		//[self updateBattery];
		
	} NS_HANDLER {
		
		DLog(@"%@", [localException name]);
		DLog(@"%@", [localException reason]);
		
	} NS_ENDHANDLER
}
@end
