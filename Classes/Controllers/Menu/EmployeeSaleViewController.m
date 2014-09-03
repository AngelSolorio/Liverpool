//
//  EmployeeSaleViewController.m
//  CardReader
//


#import "EmployeeSaleViewController.h"
#import "Styles.h"
#import "Tools.h"
#import "Rules.h"
#import "CardReaderAppDelegate.h"
#import "Session.h"


@implementation EmployeeSaleViewController
@synthesize txtCardNumber,btnOk;
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
	txtCardNumber.inputAccessoryView=[Tools inputAccessoryView:txtCardNumber];
	[Styles bgGradientColorPurple:self.view];
	[Styles silverButtonStyle:btnOk];
	//[Styles scanReaderViewStyle:self.view];
	
	/*scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];*/
	
    [super viewDidLoad];
}
-(void)viewWillDisappear:(BOOL)animated
{
	DLog(@"viewwilldisappear employeesale");
	
	[scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;
	[super viewWillDisappear:animated];
}
-(void) viewWillAppear:(BOOL)animated{

	[super viewWillAppear:animated];
	//cardreader SDK
	DLog(@"viewWillAppear employeesale");
	
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
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
//}

//----------------------------------------
//            MAGNETIC CARD DATA
//----------------------------------------
#pragma mark -
#pragma mark MAGNETIC CARD DATA

-(void)magneticCardData:(NSString *)track1 
				 track2:(NSString *)track2 
				 track3:(NSString *)track3
{	
	
	int sound[] = {2730,150,0,30,2730,150};
	[scanDevice playSound:100 
				 beepData:sound 
				   length:sizeof(sound)
                    error:nil];
	
	
	if(track2 != nil) {
		int i=[Tools string:track2 indexOf:@"="];
        int l=1;
        int len=   i-l;
        NSString* noTarjeta;
        if (i!=-1) {
			noTarjeta=[track2 substringWithRange:(NSMakeRange(l, len))];
        }else{
            noTarjeta=track2;
        }
		
		track2 = [track2 substringToIndex:[track2 length] - 1];
		track2 = [track2 substringFromIndex:1];
		if ([Rules isEmployeeCard:noTarjeta]) 
		{	
			[Session setEmployeeAccount:noTarjeta];
			DLog(@"tarjeta adasdasd: %@",noTarjeta);
			[self showScanItemView];
		}
		else 
			[Tools displayAlert:@"Error" message:@"El numero de cuenta introducido no es de empleado"];
	}
	
}
-(void) showScanItemView
{
	//[self dismissModalViewControllerAnimated:YES];
	//[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) mainScreen];
    
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [Session setIsEmployeeSale:YES];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) saleOptionScreen];
	    
    
}
-(IBAction) exitEmployeeSale{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) validateManualCardNumber
{
	if ([Rules isEmployeeCard:txtCardNumber.text]) 
	{	[self showScanItemView];
		[Session setEmployeeAccount:txtCardNumber.text];
	}
	else 
		[Tools displayAlert:@"Error" message:@"El numero de cuenta introducido no es de empleado"];
	
	
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

- (void)dealloc {
	DLog(@"dealloc employesale");
	[txtCardNumber release];txtCardNumber=nil;
	[btnOk release], btnOk = nil;
    [super dealloc];
}


@end
