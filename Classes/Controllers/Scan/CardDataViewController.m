//
//  CardDataViewController.m
//  CardReader

#import "CardDataViewController.h"
#import "Styles.h"
#import "Tools.h"
#import "Card.h"

@implementation CardDataViewController

@synthesize lblCardNumber;
@synthesize lblUserName;
@synthesize lblExpirationDate;
@synthesize lblPaymentAmount;
@synthesize cardData;
@synthesize delegate;
@synthesize txtAuthCode;
@synthesize ctrlPaymentType;
@synthesize btnHideAuthCode;

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
	[Styles scanReaderViewStyle:self.view];
	cardType=0;
	
	
	//cardreader SDK
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
	txtAuthCode.inputAccessoryView=[Tools inputAccessoryView:txtAuthCode];

	[super viewDidLoad];
}

-(void) viewWillDisappear:(BOOL)animated
{
	[scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;
	[super viewWillDisappear:animated];
}
-(void) viewDidAppear:(BOOL)animated
{
	//cardreader SDK
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
	
	[super viewDidAppear:animated];
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
//	[scanDevice removeDelegate:self];
//	[scanDevice disconnect];
//	scanDevice = nil;
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

//----------------------------------------
//            SCAN DEVICE HANDLER
//----------------------------------------
#pragma mark -
#pragma mark SCAN DEVICE HANDLER

-(void)buttonPressed:(int)whichButton
{
	
}

-(void)buttonReleased:(int)which
{
	
	
}

-(void)connectionState:(int)state
{
	switch (state) {
			
		case CONN_DISCONNECTED:
			
		case CONN_CONNECTING:
			
			
			break;
			
		case CONN_CONNECTED:
			
			
			
			NS_DURING {
				
				[scanDevice msEnable:nil];
				//[scanDevice setBarcodeTypeMode:BARCODE_TYPE_EXTENDED];
				//[self enableCharging];
				
				
				
			} NS_HANDLER {
				
				DLog(@"%@", [localException name]);
				DLog(@"%@", [localException reason]);
				
			} NS_ENDHANDLER
			
			//[self updateBattery];
			break;
	}
}
-(void)enableCharging
{
	NS_DURING {
		
		[scanDevice setCharging:YES error:nil];
		
	} NS_HANDLER {
		
	} NS_ENDHANDLER
}

//----------------------------------------
//            MAGNETIC CARD DATA
//----------------------------------------
#pragma mark -
#pragma mark MAGNETIC CARD DATA

-(void)magneticCardData:(NSString *)track1 
				 track2:(NSString *)track2 
				 track3:(NSString *)track3
{	
	if (cardData) {
		[cardData release];
	}
	
	cardData=[[Card alloc]init];
	[cardData.cardType release];
	cardData.cardType=[[NSString stringWithFormat:@"%i",cardType] copy];
	
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
		[cardData setTrack2:[track2 copy]];
		[cardData setCardNumber:[noTarjeta copy]];
		noTarjeta=[Tools maskCreditCardNumber:noTarjeta];
		[lblCardNumber setText:noTarjeta];
		
	}
	
	if(track1 != nil) {
        NSString* nombreUsuario;
        if(track1.length>=19)
            nombreUsuario=[track1 substringFromIndex:19];
        else
            nombreUsuario=track1;
		
		[lblUserName setText:[Tools trimUsernameFromCreditCardTrack:track1]];
		track1 = [track1 substringToIndex:[track1 length] - 1];
		track1 = [track1 substringFromIndex:1];
		[cardData setTrack1:track1];
		[cardData setUserName:[[lblUserName text]copy]];

	}
	
	if(track3 == nil) {
		
		[lblExpirationDate setText:[Tools trimExpireDateCreditCardTrack:track1]];
		[cardData setExpireDate:[Tools trimExpireDateCard:track1]];
		
		[cardData setTrack3:track3];
		
	}
	
	
	int sound[] = {2730,150,0,30,2730,150};
	[scanDevice playSound:100 
				 beepData:sound 
				   length:sizeof(sound)
                    error:nil];
	
	[cardData.cardType release];
	cardData.cardType=[[NSString stringWithFormat:@"%i",cardType] copy];
	DLog(@"DAtos de la tarjeta track1:%@ track2:%@ track3:%@ cardtype:%@",cardData.track1,cardData.track2,cardData.track3,cardData.cardType);
	
}

//----------------------------------------
//            ACTIONS
//----------------------------------------


-(void) showCardDataView
{
	//[Tools showViewAnimation:self.view];

}

-(void) hideCardDataView
{
	[Tools hideViewAnimation:self.view];

	/*[scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;*/
}
-(IBAction) continueTransaction
{
	cardData.authCode=txtAuthCode.text;
	if ([self validatePaymentData]) 
		[delegate performCardDataTransaction:cardData];
	
	
}

-(BOOL) validatePaymentData
{
	if ([txtAuthCode.text length]==0&&![txtAuthCode isHidden]) {
		[Tools displayAlert:@"Error" message:@"Introduzca un codigo de autorizacion valido"];
		return NO;
	}
	else if	([cardData.track1 length]==0 || [cardData.track2 length]==0)
	{	
		[Tools displayAlert:@"Error" message:@"Favor de deslizar la tarjeta nuevamente"];
		return NO;
	}	
	else 
		return YES;
}
-(IBAction) selectedPaymentType
{

	switch (ctrlPaymentType.selectedSegmentIndex) {
		case 2:
		{
			//[txtAuthCode setHidden:YES];
			[btnHideAuthCode setHidden:NO];
			[txtAuthCode setHidden:NO];
			//typeOfTransaction=@"ventaConTarjetaDilisa";
			//typeOfTransaction=@"ventaClienteConTarjeta";
			
		}
			break;
		case 3:
		{	
			[btnHideAuthCode setHidden:YES];
			[txtAuthCode setHidden:YES];
			//typeOfTransaction=@"ventaClienteConTarjeta";
		}
			break;
		default:
		{
			[btnHideAuthCode setHidden:YES];
			[txtAuthCode setHidden:NO];
			//typeOfTransaction=@"ventaClienteConTarjeta";
		}
			break;
	}
	cardType=ctrlPaymentType.selectedSegmentIndex;
	[cardData.cardType release];
	cardData.cardType=[[NSString stringWithFormat:@"%i",cardType] copy];

}

-(IBAction) hideAuthCodeForNewDilisa
{
	txtAuthCode.hidden=(txtAuthCode.hidden==TRUE)?FALSE:TRUE;
	txtAuthCode.text=@"";
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
	
	viewCords.origin.y=(viewCords.origin.y-textFieldCord.y)+80;
	DLog(@"cords:%@ ",NSStringFromCGPoint(viewCords.origin));
	self.view.frame=viewCords;
    [UIView commitAnimations];
	
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; 
	
	CGPoint textFieldCord=textField.center;
	
	CGRect viewCords=self.view.frame;
	
	viewCords.origin.y=(viewCords.origin.y+textFieldCord.y)-80;
	DLog(@" cords:%@ ",NSStringFromCGPoint(viewCords.origin));

	self.view.frame=viewCords;
    [UIView commitAnimations];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	
}
- (void)dealloc {
	[lblCardNumber release]; lblCardNumber=nil;
	[lblUserName release];lblUserName=nil;
    [lblExpirationDate release];lblExpirationDate=nil;
	[lblPaymentAmount release]; lblPaymentAmount=nil;
	[txtAuthCode release]; txtAuthCode=nil;
	[cardData release];
	[ctrlPaymentType release], ctrlPaymentType=nil;
	[btnHideAuthCode release], btnHideAuthCode=nil;
	[super dealloc];
}


@end
