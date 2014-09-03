//
//  ConfigurationAuthorization.m
//  CardReader


#import "ConfigurationAuthorization.h"
#import "Tools.h"
#import "Settings.h"
#import "Styles.h"
#import "LoginParser.h"

@implementation ConfigurationAuthorization

@synthesize txtStoreID,txtPassword,btnOk;
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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
	txtStoreID.inputAccessoryView=[Tools inputAccessoryView:txtStoreID];
	txtPassword.inputAccessoryView=[Tools inputAccessoryView:txtPassword];
	self.title=@"Configuracion de impresoras";
	
	[Styles bgGradientColorPurple:self.view];
	[Styles silverButtonStyle:btnOk];
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) viewWillAppear:(BOOL)animated
{
	[txtStoreID setText:@""];
	[txtPassword setText:@""];
	[super viewWillAppear:YES];
}
-(void) viewWillDisappear:(BOOL)animated
{
	[txtStoreID setText:@""];
	[txtPassword setText:@""];
	[super viewWillDisappear:YES];
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
	NSString *admin=txtStoreID.text;
	NSString *password=txtPassword.text;
	NSMutableArray *pars=[NSMutableArray arrayWithObjects:admin,password,nil];
	[liverPoolRequest sendRequest:@"adminLogin" forParameters:pars forRequestType:adminLoginRequest]; 
	[liverPoolRequest release];
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	if (requestType==adminLoginRequest) 
		[self loginRequestParsing:receivedData];
	
}

-(void) loginRequestParsing:(NSData*) data
{
	LoginParser *loginParser=[[LoginParser alloc] init];
	DLog(@"antes de empezar");
	[loginParser startParser:data];
	DLog(@"termino");
	if([loginParser isLoginSuccesful])
	{	
        Settings *sets=[[Settings alloc] init];
		//[self presentModalViewController:sets animated:YES];
        [self presentViewController:sets animated:YES completion:nil];

		[sets release];
	}
	else 
	{	[Tools displayAlert:@"Error" message:[loginParser returnErrorMessage]];
        //[Tools displayAlert:@"Error" message:@"Tienda/Contraseña incorrectos favor de verificar"];

    }
	[loginParser release];
    [Tools stopActivityIndicator];

	
}

-(IBAction) validatePassword
{
	if ([[txtStoreID text]length]==0 ||[[txtPassword text]length]==0 ) 
        [Tools displayAlert:@"Error" message:@"favor de llenar los campos"];
    
    else
        [self startRequest];
    
    /*
    if ([txtStoreID.text isEqual:@"103"]&&[txtPassword.text isEqualToString:@"liverpool"]) {
		Settings *sets=[[Settings alloc] init];
		[self presentModalViewController:sets animated:YES];
		[sets release];
	}
	else 
		[Tools displayAlert:@"Error" message:@"Tienda/Contraseña incorrectos favor de verificar"];
*/
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

- (void)dealloc {
	[txtPassword release]; txtPassword=nil;
	[txtStoreID release];txtStoreID=nil;
	[btnOk release], btnOk = nil;
	
    [super dealloc];
}


@end
