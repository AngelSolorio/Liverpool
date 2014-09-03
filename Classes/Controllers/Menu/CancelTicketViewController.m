//
//  CancelTicketViewController.m
//  CardReader

#import "CancelTicketViewController.h"
#import "Session.h"
#import "Seller.h"
#import "Tools.h"
#import "TicketGeneratorViewController.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
#import "CancelParser.h"
 @implementation CancelTicketViewController
@synthesize  txtLbl1,txtLbl2,txtField1,txtField2,btnOk,btnClose;
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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    [Styles bgGradientColorPurple:self.view];
    [Styles silverButtonStyle:btnOk];
	[Styles silverButtonStyle:btnClose];
    txtField1.inputAccessoryView=[Tools inputAccessoryView:txtField1];
    txtField2.inputAccessoryView=[Tools inputAccessoryView:txtField2];


    // Do any additional setup after loading the view from its nib.
}

//- (void)viewDidUnload
//{
//
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark REQUEST HANDLERS


-(void) startCancelTransactionRequest
{
	[Tools startActivityIndicator:self.view];

	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
    liverpoolRequest.delegate=self;
    
	//seller object
    Seller *seller=[[Seller alloc] init];
    seller.password=[Session getPassword];
    seller.userName=[Session getUserName];
    
	//original Amount
    NSString *originalAmount=[txtField2 text];
    
    //original Transaction Number
    NSString *originalDocto=[txtField1 text];

    NSArray *pars;
    
    //Type of Sale
    NSString *cancelType=[self selectCancelType];


    SaleType sType=[Session getSaleType];
    DLog(@"cardnumber :%@",[[cardsArray lastObject] cardNumber]);


    if (sType==CANCEL_TYPE)
    {    //Message Content
        pars=[NSArray arrayWithObjects:originalDocto,originalAmount,seller,cards,nil];
        [liverpoolRequest sendRequest:cancelType forParameters:pars forRequestType:cancelRequest];
    }
       
    [liverpoolRequest release];
    [seller release];
    //falta agregar el pago
}
-(NSString*) selectCancelType
{
    SaleType sType=[Session getSaleType];
    NSString *type=@"";
    if (sType==CANCEL_TYPE)
        type=@"cancelarTicket";
    return type;
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	if (requestType==buyRequest||requestType==cancelRequest)
		[self cancelRequestParsing:receivedData];
	
}
-(void) cancelRequestParsing:(NSData*) data
{
    [Tools stopActivityIndicator];

	CancelParser *payParser=[[CancelParser alloc] init];
	[payParser startParser:data];
	DLog(@"RESULTADO DE LA COMPRA 1 tarjeta: %@", [payParser getMessageResponse]);
	
	//if the transaction was succesful.
	if ([payParser getStateOfMessage]) {
		
        [Session setDocTo:payParser.payment.docto];
        [Session setMonthyInterest:payParser.payment.monthlyInterest];
        [Session setBank:payParser.payment.bank];
        
        [Tools increaseVoucherNumber];
        
        cancelData=[[CancelTicketData alloc]init];
        [cancelData setDocto:[[Session getDocTo] copy]];
        [cancelData setOriginalDocto:[[txtField1 text] copy]];
        [cancelData setOriginalAmount:[[txtField2 text] copy]];
        [cancelData setOriginalTerminal:[[Session getTerminal]copy] ];
        [cancelData setTerminal:[[Session getTerminal] copy]];
        [cancelData setAuthorizationCode:payParser.payment.authorizationCode];
        [cancelData setBank:[payParser.payment.bank copy]];
        [cancelData setEglobalCards:[payParser paymentCardList]];
        

        //when the close is done but the printer is not ready, the button print ticket will become active
        [btnOk removeTarget:nil
                                action:NULL
                      forControlEvents:UIControlEventAllEvents];
        
        [btnOk addTarget:self
                             action:@selector(printCancelTicket)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [btnOk setTitle:@"Imprimir" forState:UIControlStateNormal];
        
        [self printCancelTicket];
	}
    
    //state=NO & if has eglobalcards
    else if(![payParser getStateOfMessage]&&[[payParser payment]hasEglobalCards])
    {
        DLog(@"Eglobal cards: %@ ,size:%i",[payParser eGlobalsCard],[[payParser eGlobalsCard]count]);
        DLog(@"Hay que leer las tarjetas para enviarse de nuevo");
        reader=[[GenericCardReaderViewController alloc]initWithNibName:@"GenericCardReaderViewController" bundle:nil];
        [reader setCardsBin:[payParser eGlobalsCard]];
        [self presentViewController:reader animated:NO completion:nil];
        [reader setDelegate:self];
        [reader release];
        //falta una prueba completa del proceso
        
    }
    //Cancel Error
	else
	{
        //TEMPORAL PATCH - U17 ver 1.4.5 rev6
//        if([[payParser getMessageResponse] isEqualToString:@"Ha ocurrido un error desconocido"]){
//            [Tools displayAlert:@"Error" message:@"U17 No se puede cancelar retiro, personal no autorizado"];
//
//        }else{
            [Tools displayAlert:@"Error" message:[payParser getMessageResponse]];
//        }
	}
	[payParser release];
}

-(IBAction)printCancelTicket
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [Tools startActivityIndicator:self.view];
    [btnClose setHidden:YES];

    DLog(@"apunto de imprimir");
    TicketGeneratorViewController *tk=[[TicketGeneratorViewController alloc]init];
    //[tk setCardArray:[cards getCardList]];
    [tk setCardArray:[cancelData eglobalCards]];
    [tk printCancelDataTicket:cancelData];

    for (Card *card in [cards getCardList]) {
        DLog(@"carddatas  %@",[card cardNumber]);

    }
    DLog(@"antes de cancelar Data");
    [tk release];
    
}

-(IBAction)close:(id)sender
{
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeCancelTicketScreen];

}
-(BOOL) validateData
{
    DLog(@"validate Data");
    NSString *docto=[txtField1 text];
    NSString *amount=[txtField2 text];
    if ([docto length]>0&&[amount length]>0) {
        return YES;
    }
    else
    {
        [Tools displayAlert:@"Error" message:@"Favor de introducir los datos solicitados"];
        return NO;
    }
}

-(IBAction) okAction:(id)sender
{
    DLog(@"ok delegatee action");
    if (![self validateData]) 
        return;
    

    if ([Session getSaleType]==CANCEL_TYPE) {
        // cancel a transaction
        DLog(@"startRequest");
        [self startCancelTransactionRequest];
    }
}
//----------------------------------------
//            GENERIC READER DELEGATE
//----------------------------------------
-(void) performAction:(NSMutableArray*) cardArray{
    cardsArray=[[NSMutableArray alloc]initWithArray:cardArray];//leak?
    
     cards=[[CardDataList alloc]init];
    [cards setCardList:cardsArray];
    
    DLog(@"iniciando eglobal cancel");
    [self startCancelTransactionRequest];

    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void) performExitAction{
    [self dismissViewControllerAnimated:NO completion:nil];
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
    
    
    if (![textField isEqual:txtField1]) {
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
    
    //************************
	if (textField == numberKeyPad.currentTextField) {
		/*
		 Hide the number keypad
         */
		[self.numberKeyPad removeButtonFromKeyboard];
		self.numberKeyPad = nil;
	}
	
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	
}

-(void)dealloc
{
    
    //1.4.5 rev 6 leak in on of these objects
    DLog(@"cancelTicket dealloc");
    [cards release];
    [cancelData release];
    [btnOk release];
    [btnClose release];
    [txtField1 release];
    [txtField2 release];
    [txtLbl1 release];
    [txtLbl2 release];
    [super dealloc];

}
@end
