//
//  BalanceViewController.m
//  CardReader
//


#import "BalanceViewController.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
#import "BalanceRequest.h"
#import "BalanceParser.h"
#import "Balance.h"
#import "Tools.h"
#import "Card.h"
#import "Session.h"
NSString * const CREDIT_REQUESTKEY =@"TSCCRE03" ;
NSString * const MONEY_REQUESTKEY =@"TSCCTE09";
@implementation BalanceViewController
@synthesize txtAccountNumber, btnBalance,lblBalance,segmentType,segmentTextType,ticket;
@synthesize lastBalance,dueBalance,cycleExpire,minPayment,woRefinanciamientPayment,NonInterestPayment,date;
@synthesize lblsTexto1,lblsTexto2,lblsTexto3,lblsTexto4,lblsTexto5,lblsTexto6,lblsTexto7;
@synthesize btnMonedero,btnDilisa,btnLPC;

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
	[Styles bgGradientColorPurple:self.view];
	[Styles silverButtonStyle:btnBalance];
	[Styles silverButtonStyle:btnMonedero];
	[Styles silverButtonStyle:btnDilisa];
	[Styles silverButtonStyle:btnLPC];
	
	segmentTextType=MONEY_REQUESTKEY;
	txtAccountNumber.inputAccessoryView=[Tools inputAccessoryView:txtAccountNumber];
	ticket=YES;
	balanceType=0;
}
-(void) viewDidAppear:(BOOL)animated{
	DLog(@"viewDidAppear balance");

	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
	[super viewDidAppear:animated];
	
}

-(void) viewWillDisappear:(BOOL)animated
{	DLog(@"viewWillDisappear balance");

	[scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;
	[super viewWillDisappear:animated];
	
}
-(IBAction) exitBalanceConsult
{
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeTransactionMenuScreen];
	
}
-(IBAction) balanceQuery
{		
	if ([txtAccountNumber.text length]==0) {
		[Tools displayAlert:@"Aviso" message:@"Favor de deslizar la tarjeta"];
		return;
	}
	[self startRequest:txtAccountNumber.text];
	//[self startRequest:cardNumber];
	[cardNumber release];

}/*
-(IBAction) selectedSegmentType
{
	if (segmentTextType) {
		[segmentTextType release];
	}
	
	NSLog(@"Valor %d ",segmentType.selectedSegmentIndex);
	switch (segmentType.selectedSegmentIndex) {
		case 0:
		{
			segmentTextType= MONEY_REQUESTKEY;
			[self clearFields];
			[self hiddenFields:TRUE];
		}
			break;
		case 1:
		case 2:
		{	
			segmentTextType= CREDIT_REQUESTKEY;
			[self clearFields];
			[self hiddenFields:FALSE];
		}
			break;
		default:
		{
			
		}
			break;
	}
	
}*/
-(IBAction) selectedSegmentTypeMonedero
{
	segmentTextType= MONEY_REQUESTKEY;
	[self clearFields];
	balanceType=0;
	
	[btnMonedero setSelected:YES];
	[btnDilisa setSelected:NO];
	[btnLPC setSelected:NO];


}
-(IBAction) selectedSegmentTypeDilisa
{
	segmentTextType= CREDIT_REQUESTKEY;
	[self clearFields];
	balanceType=1;
	
	[btnMonedero setSelected:NO];
	[btnDilisa setSelected:YES];
	[btnLPC setSelected:NO];

}
/*-(IBAction) selectedSegmentTypeLPC
{
	segmentTextType= CREDIT_REQUESTKEY;
	[self clearFields];
	balanceType=2;

	[btnMonedero setSelected:NO];
	[btnDilisa setSelected:NO];
	[btnLPC setSelected:YES];
}
*/
-(void) clearFields{
	lblBalance.text=@"";
	lastBalance.text=@"";
	dueBalance.text=@"";
	
	cycleExpire.text=@"";
	minPayment.text=@"";
	woRefinanciamientPayment.text=@"";
	NonInterestPayment.text=@"";
	date.text=@"";
	txtAccountNumber.text=@"";
}
-(void) hiddenFields:(BOOL)type{
	lastBalance.hidden=type;
	dueBalance.hidden=type;
	
	cycleExpire.hidden=type;
	minPayment.hidden=type;
	woRefinanciamientPayment.hidden=type;
	NonInterestPayment.hidden=type;
	date.hidden=type;
	lblsTexto1.hidden=type;
	lblsTexto2.hidden=type;
	lblsTexto3.hidden=type;
	lblsTexto4.hidden=type;
	lblsTexto5.hidden=type;
	lblsTexto6.hidden=type;
	lblsTexto7.hidden=type;
	
}
//----------------------------------------
//            SCAN DEVICE HANDLER
//----------------------------------------
#pragma mark -
#pragma mark SCAN DEVICE HANDLER

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
				
			} NS_HANDLER {
				
				DLog(@"%@", [localException name]);
				DLog(@"%@", [localException reason]);
				
			} NS_ENDHANDLER
			
			break;
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
	//cardNumber=[barcode copy];
	//txtAccountNumber.text=[Tools maskMonederoNumber:barcode];
	[txtAccountNumber setText:barcode];
	[self startRequest:[txtAccountNumber text]];

	NS_DURING {
		
		//[self updateBattery];
		
	} NS_HANDLER {
		
		DLog(@"%@", [localException name]);
		DLog(@"%@", [localException reason]);
		
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
	[self clearFields];
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
        //cardNumber=[noTarjeta copy];
		[txtAccountNumber setText:noTarjeta];
		//[txtAccountNumber setText:[Tools maskCreditCardNumber:noTarjeta]];
		
	}
	
	int sound[] = {2730,150,0,30,2730,150};
	[scanDevice playSound:100
				 beepData:sound 
				   length:sizeof(sound)
     error:nil];
	
    [self startRequest:[txtAccountNumber text]];

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


- (void)dealloc {
    [super dealloc];
	[txtAccountNumber release], txtAccountNumber=nil;
	[btnBalance release], btnBalance=nil;
	[lblBalance release],lblBalance=nil;
	[segmentType release],segmentType=nil;
	[segmentTextType release],segmentTextType=nil;
	[lastBalance release],lastBalance=nil;
	[dueBalance release],dueBalance=nil;
	[cycleExpire release],cycleExpire=nil;
	[minPayment release],minPayment=nil;
	[woRefinanciamientPayment release],woRefinanciamientPayment=nil;
	[NonInterestPayment release],NonInterestPayment=nil;
	[date release],date=nil;
	
	[btnMonedero release];
	[btnDilisa release];
	[btnLPC release];
	
	[lblsTexto1 release],lblsTexto1=nil;
	[lblsTexto2 release],lblsTexto2=nil;
	[lblsTexto3 release],lblsTexto3=nil;
	[lblsTexto4 release],lblsTexto4=nil;
	[lblsTexto5 release],lblsTexto5=nil;
	[lblsTexto6 release],lblsTexto6=nil;
	[lblsTexto7 release],lblsTexto7=nil;
	
}

//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS
-(void) startRequest:(NSString*) barCode
{
	
	if (segmentTextType!=nil) {
		// find item request code 
		BalanceRequest *balanceRequest=[[BalanceRequest alloc] init];
		balanceRequest.delegate=self;
		
		NSArray *pars=nil;
		if ([segmentTextType isEqualToString:MONEY_REQUESTKEY]) {
			pars=[NSArray arrayWithObjects:@"",barCode,nil];
		}else if ([segmentTextType isEqualToString:CREDIT_REQUESTKEY]) {
			pars=[NSArray arrayWithObjects:@"",barCode,@"",@"1",nil];
		}
		[balanceRequest sendRequest:segmentTextType forParameters:pars forRequestType:bRequest]; //cambiar a localized string
		[balanceRequest release];
		[Tools startActivityIndicator:self.view];
	}
}
-(void) startRequestBalanceMonedero:(NSString*) barCode
{
	
	BalanceRequest *balanceRequest=[[BalanceRequest alloc] init];
	balanceRequest.delegate=self;
	segmentTextType=MONEY_REQUESTKEY;
	NSArray* pars=[NSArray arrayWithObjects:@"",barCode,nil];
	[balanceRequest sendRequest:segmentTextType forParameters:pars forRequestType:bRequest]; //cambiar a localized string
	[balanceRequest release];
	[Tools startActivityIndicator:self.view];
	
}
-(void) performResults:(NSData *)receivedData :(RequestType)requestType
{
	[self balanceRequestParsing:receivedData];
}
-(void) balanceRequestParsing:(NSData*) data
{
	//Development 	Only
	//	NSMutableString* info=[[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> "];
	//	[info appendString:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"];
	//	[info appendString:@"<SOAP-ENV:Body>"];
	//	[info appendString:@"<liv:TSCCRE03Response xmlns:liv=\"http://liverpool.com.mx/schemas/wbi\">"];
	//	[info appendString:@"<liv:respuestaXML><![CDATA[<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><Error xmlns=\"urn:schemas-liverpool-com-mx:xml\" Número=\"5\" Descripción=\"Estimado cliente: El NIP que ingresó no corresponde con el que está registrado en nuestro sistema por favor intente nuevamente. Recuerde que su NIP es el mismo que utiliza en nuestro servicio por Internet. Si no lo recuerda llame al Centro de Atención Telefónica (CAT) al 01-800-713-5555 o en el D.F. al 5262-9999\"/>]]></liv:respuestaXML>"];
	//	 //@"<Error xmlns=\"urn:schemas-liverpool-com-mx:xml\" Número=\"5\" Descripción=\"Estimado cliente: El NIP que ingresó no corresponde con el que está registrado en nuestro sistema por favor intente nuevamente. Recuerde que su NIP es el mismo que utiliza en nuestro servicio por Internet. Si no lo recuerda llame al Centro de Atención Telefónica (CAT) al 01-800-713-5555 o en el D.F. al 5262-9999\"><Error/>"];
	////	 @"<liv:respuestaXML><![CDATA[<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><Error xmlns=\"urn:schemas-liverpool-com-mx:xml\" Número=\"5\" Descripción=\"Estimado cliente: El NIP que ingresó no corresponde con el que está registrado en nuestro sistema por favor intente nuevamente. Recuerde que su NIP es el mismo que utiliza en nuestro servicio por Internet. Si no lo recuerda llame al Centro de Atención Telefónica (CAT) al 01-800-713-5555 o en el D.F. al 5262-9999\"/>]]></liv:respuestaXML>"];
	//	[info appendString:@"</liv:TSCCRE03Response>"];
	//	[info appendString:@"</SOAP-ENV:Body>"];
	//	[info appendString:@"</SOAP-ENV:Envelope>"];
	
	//	NSMutableString* info=[[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
	//	[info appendString:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"];
	//	[info appendString:@"<SOAP-ENV:Body>"];
	//	[info appendString:@"<liv:TSCCTE09Response xmlns:liv=\"http://liverpool.com.mx/schemas/wbi\">"];
	//	[info appendString:@"<liv:respuestaXML><![CDATA[<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SaldoMonedero xmlns=\"urn:schemas-liverpool-com-mx:xml\" nc=\"3300000000482102\" sa=\"0.00\"/>]]></liv:respuestaXML>"];
	//	[info appendString:@"</liv:TSCCTE09Response>"];
	//	[info appendString:@"</SOAP-ENV:Body>"];
	//	[info appendString:@"</SOAP-ENV:Envelope>"];
	
	
	//	data = [NSData dataWithBytes:[info UTF8String] length:[info length]];
	
	
	
	BalanceParser* balanceParser=[[BalanceParser alloc] init];
	DLog(@"antes de empezar");
	[balanceParser startParser:data];
	DLog(@"termino");
	DLog(@"balance %@ ",[[[balanceParser balanceModel] error] description]);
	lblBalance.text=@"sin conexión...";
	if([[balanceParser balanceModel] isError]){
		        //Monedero doesnt exist
        if (balanceType==0) {
            [lblBalance setText:@"-1.0"];
            [self printTicketBalance];

        }else{
            NSLog(@"IsError");
            lblBalance.text=[balanceParser balanceModel].error.description;
            [Tools displayAlert:@"Aviso" message:[balanceParser balanceModel].error.description];

        }
        
	}else  if (([balanceParser balanceModel].sa)!=nil) {
		lblBalance.text=([balanceParser balanceModel].sa);
		lblBalance.text=[Tools amountCurrencyFormat:lblBalance.text];
		lastBalance.text=([balanceParser balanceModel].suc);
		dueBalance.text=([balanceParser balanceModel].sv);
		
		cycleExpire.text=([balanceParser balanceModel].svc);
		minPayment.text=([balanceParser balanceModel].pm);
		woRefinanciamientPayment.text=([balanceParser balanceModel].pm_sinrefin);
		NonInterestPayment.text=([balanceParser balanceModel].pmni);;
		date.text=([balanceParser balanceModel].flp);
		
		[Session setMonederoAmount:[[lblBalance text]copy]];
		if (ticket) 
			[self printTicketBalance];
		
	}else {
		[Tools displayAlert:@"Aviso" message:@"No se ha podido establecer comunicación con el servidor"];
	}
	
	
	[balanceParser release];
	
	[Tools stopActivityIndicator];
}

-(void) printTicketBalance
{
    //
    //[Tools startActivityIndicator:self.view];
	TicketGeneratorViewController *tk=[[TicketGeneratorViewController alloc]init];
	
	//card
	Card *cardData=[[Card alloc] init];
	[cardData setCardNumber:[txtAccountNumber.text copy]];
	[cardData setCardType:[self typeOfBalance]];
	NSString* balance=[lblBalance text];
	[tk	setCard:cardData];
//	[self presentModalViewController:tk animated:YES];
    [tk setPaymentType:[self setPaymentType:balanceType]];
	[tk printTicketBalance:balance];
	[tk release];
	[cardData release];
	
}
-(paymentType) setPaymentType:(int) type
{
    paymentType pType;
	switch (type) {
		case 2:
			pType=LPCType;
			break;
		case 1:
			pType=dilisaType;
			break;
		case 0:
			pType=monederoType;
			break;
		default:
			break;
	}
    return pType;
}
-(NSString*) typeOfBalance
{
	//int type=[segmentTextType intValue];

	switch (balanceType) {
		case 0: //monedero
			NSLog(@"Monedero");
			return @"Monedero";
			break;
		case 1: //dilisa
			NSLog(@"Dilisa/LPC");
			return @"Dilisa/LPC";
			break;
		case 2: //lcp
			NSLog(@"Premium Card");
			return @"Premium Card";
			break;
		default:
			return @"";
			break;
	} 
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

@end
