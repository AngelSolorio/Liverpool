//
//  PaymentViewController.m
//  CardReader

#import "PaymentViewController.h"
#import "ProjectConstants.h"
#import "Tools.h"
#import "LiverPoolRequest.h"
#import "PaymentParser.h"
#import "SignPrintView.h"
#import "PrinterResponseParser.h"
#import "Session.h"
#import "Styles.h"
#import "Seller.h"
#import "TicketGeneratorViewController.h"
#import "BalanceRequest.h"
#import "BalanceParser.h"
#import "Balance.h"
#import "Rules.h"
#import "CardReaderAppDelegate.h"
#import "PromotionGroup.h"
#import "MonederoCardViewController.h"
#import "MesaDeRegalo.h"
#import "RefundData.h"
#import "LogoutParser.h"
#import "VFDevice.h"

@implementation PaymentViewController

@synthesize lblTitle;
@synthesize lblCard;
@synthesize lblCardNumber;
@synthesize lblUser;
@synthesize lblUserText;
@synthesize lblDate;
@synthesize lblDateText;
@synthesize lblSubtitle;
@synthesize lblOperation;
@synthesize btnPay;
@synthesize barBtnCancel;
@synthesize barBtnSMS;
@synthesize barBtnEmail;
@synthesize barBtnDone;
@synthesize productList;
@synthesize productListWithPromos;
@synthesize txtAuthCode;
@synthesize btnHideAuthCode;
@synthesize txtAmount;
@synthesize cardsArray;
@synthesize filteredPlanGroup;
@synthesize promotionGroup;
@synthesize originalPromotionGroup;
@synthesize numberKeyPad;
@synthesize cardReaderView;
@synthesize amountReaderView;
@synthesize btnCashPay;
@synthesize btnCardPay;
@synthesize btnMonederoPay;
@synthesize btnAmountBack;
@synthesize btnAmountOk;
@synthesize btnCardBack;
@synthesize btnCardOk;
@synthesize barBtnBack;

@synthesize lblBalance;

static const CGFloat KEYBOARD_ANIMATION_DURATION=0.3;
static const CGFloat MINIMUN_SCROLL_FRACTION =0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION =0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT =216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT =162;

//----------------------------------------
//            MEMORY MANAGEMENT
//----------------------------------------
#pragma mark -
#pragma mark MEMORY MANAGEMENT

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//----------------------------------------
//            VIEW LIFECYCLE
//----------------------------------------
#pragma mark -
#pragma mark VIEW LIFECYCLE

-(void)viewDidLoad
{
    [super viewDidLoad];
     [[VFDevice pinPad] setDelegate:self];
     [[VFDevice barcode] setDelegate:self];
     [[VFDevice control] setDelegate:self];
     if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
	lblCard.textColor = [UIColor lightGrayColor];
	lblUser.textColor = [UIColor lightGrayColor];
	lblDate.textColor = [UIColor lightGrayColor];
	[Styles silverButtonStyle:btnPromo];
	[Styles purpleButtonStyle:btnPay];
	
	txtAuthCode.inputAccessoryView=[Tools inputAccessoryView:txtAuthCode];
	if (txtAmount != nil) {
		txtAmount.inputAccessoryView=[Tools inputAccessoryView:txtAmount];
	}
	
	
	
	[self resetLabels]; //fix 1.4.4
#ifdef TARGET_IPHONE_SIMULATOR //|| WITHOUT_CARDREAD
	
	[btnPay setTitle:NSLocalizedString(@"Autorizar", @"Slide Credit Card") 
			forState:UIControlStateNormal];
	[btnPay setEnabled:YES];
	
#else
	
	[btnPay setTitle:NSLocalizedString(@"Deslizar Tarjeta", @"Slide Credit Card") 
			forState:UIControlStateNormal];
	[btnPay setEnabled:NO];
	
#endif
	
     //scanDevice = [Linea sharedDevice];
     //[scanDevice setDelegate:self];
     //[scanDevice connect];
     [scanDevice barcodeEnableBarcode:BAR_ALL enabled:YES error:nil];
     [Styles bgGradientColorPurple:self.view];
     [Styles bgGradientColorPurple:amountReaderView];
     [Styles bgGradientColorPurple:cardReaderView];
     [Styles silverButtonStyle:btnCardOk];
     [Styles silverButtonStyle:btnCardBack];
     [Styles silverButtonStyle:btnAmountBack];
     [Styles silverButtonStyle:btnAmountOk];

	
	firstPaymentDone=NO;
	cardsArray=[[NSMutableArray alloc] init];
	
	lblTitle.text=[Tools calculateAmountToPayWithPromo:productList :promotionGroup]; //ver 1.3.2
     total=[[lblTitle text]floatValue];
     DLog(@"loadview total %f",total);
     lblTitle.text=[Tools amountCurrencyFormat:[lblTitle text]];
     
     [self setLayout];

}
-(void) setLayout
{
     SaleType sType=[Session getSaleType];
     //if ([Session getIsEmployeeSale]) {
     //Employee payment cannot be payed with monedero therefore the option must be blocked.
     if (sType==NORMAL_EMPLOYEE_TYPE || sType==SOMS_EMPLOYEE_TYPE) {
          [btnMonederoPay setEnabled:NO];
     }
     if (sType==REFUND_NORMAL_TYPE||sType==REFUND_NORMAL_EMPLOYEE_TYPE) {
          [txtAmount setHidden:YES];
     }
}
-(void) resetLabels
{
     
	[barBtnDone setEnabled:NO];
	[barBtnEmail setEnabled:NO];
	[barBtnSMS setEnabled:NO];
	[lblSubtitle setHidden:YES];
	[lblOperation setHidden:YES];
	
	[lblCardNumber setText:@"XXXX-XXXX-XXXX-XXXX"];
	[lblUserText setText:@"XXXXX XXXXX"];
	[lblDateText setText:@"XX/XX"];
	
	[lblCard setText:NSLocalizedString(@"Tarjeta: ", @"Card number")];
	[lblUser setText:NSLocalizedString(@"Usuario: ", @"User name")];
	[lblDate setText:NSLocalizedString(@"Vencimiento: ", @"Expiration Date")];
     
     txtAuthCode.text=@"";
     [txtAuthCode setHidden:NO];
     [btnPromo setHidden:NO];
     
     [btnCardPay setEnabled:YES];
     [btnCashPay setEnabled:YES];
  
     [btnMonederoPay setEnabled:![Session getIsEmployeeSale]];

}
-(void) viewWillAppear:(BOOL)animated
{
	DLog(@"viewWillAppearƒ payment");
    DLog(@"payment productList %@",productList);
    DLog(@"payment promotiongroup %@",promotionGroup);

	[self.navigationController setNavigationBarHidden:YES animated:animated];

    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) hideTabBar];
    
    DLog(@"scanDEvice payment");
	[super viewWillAppear:animated];	
}
- (void) viewDidAppear:(BOOL)animated 
{
	DLog(@"viewdidappear payment");
     //scanDevice = [Linea sharedDevice];
     //[scanDevice setDelegate:self];
     //[scanDevice connect];
     
     //[self connectionState:scanDevice.connstate];
     
	[super viewDidAppear:animated];
     if ([VFDevice pinPad].initialized) [[VFDevice pinPad] setDelegate:self];
     if ([VFDevice control].initialized) [[VFDevice control] setDelegate:self];
     if ([VFDevice barcode].initialized) [[VFDevice barcode] setDelegate:self];
     if ([VFDevice barcode].initialized) [[VFDevice barcode] startScan];
     if ([VFDevice pinPad].initialized) [[VFDevice pinPad] enableMSRDualTrack];
}

-(void)viewWillDisappear:(BOOL)animated
{
     NSLog(@"View will disappear options");
     [[VFDevice barcode] abortScan];
     [[VFDevice pinPad] disableMSR];
	DLog(@"viewwilldisappear payment");
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) hideTabBar];

	[scanDevice removeDelegate:self];
	scanDevice = nil;
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}
//
//-(void)viewDidUnload
//{
//	[scanDevice removeDelegate:self];
//	scanDevice = nil;
//    [super viewDidUnload];
//}

//----------------------------------------
//            INTERACE ORIENTATION
//----------------------------------------
#pragma mark -
#pragma mark INTERACE ORIENTATION

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsPortrait(interfaceOrientation));
}

//----------------------------------------
//            MAIL DELEGATE
//----------------------------------------
#pragma mark -
#pragma mark MAIL DELEGATE

-(void)mailComposeController:(MFMailComposeViewController*)controller 
		 didFinishWithResult:(MFMailComposeResult)result 
					   error:(NSError*)error 
{

     [self printTicket];
		

	if (result == MFMailComposeResultCancelled) {
		
	} else if (result == MFMailComposeResultSaved) {
		
	} else if (result == MFMailComposeResultSent) {
		DLog(@"☯☯☯☯☯☯☯ MAIL ENVIADO ☯☯☯☯☯☯☯☯☯☯☯☯☯☯☯☯");
	} else if (result == MFMailComposeResultFailed) {
		DLog(@"☯☯☯☯☯☯☯ MAIL FAIL! ☯☯☯☯☯☯☯☯☯☯☯☯☯☯☯☯☯☯");
		
	} else {
		
	}
	[self becomeFirstResponder];
	//[self dismissModalViewControllerAnimated:YES];
     [self dismissViewControllerAnimated:YES completion:nil];

	
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
				
				//[scanDevice msStartScan];
				//[scanDevice setBarcodeTypeMode:BARCODE_TYPE_EXTENDED];
				
			} NS_HANDLER {
				
				DLog(@"%@", [localException name]);
				DLog(@"%@", [localException reason]);
				
			} NS_ENDHANDLER
			
			break;
	}
    DLog(@" payment end of connection state");

}



//----------------------------------------
//            BARCODE ANALYSIS
//----------------------------------------
#pragma mark -
#pragma mark BARCODE ANALYSIS
-(void)cashCodeData
{
     if (cardData) {
          [cardData release];
          cardData=nil;
          DLog(@"libero carddata");
          
     }
     
     cardData=[[Card alloc]init];
     [cardData setTrack2:@"track2"];
     [cardData setCardNumber:@""];

     [lblUserText setText:@"Efectivo"];
     
     [cardData setUserName:[[lblUserText text]copy]];
     [cardData setTrack1:@"Efectivo"];
     [cardData setTrack3:@"track3"];
     
     [btnPay setTitle:NSLocalizedString(@"Registro", @"Authorize Payment")
             forState:UIControlStateNormal];
     [btnPay setEnabled:YES];
     
     DLog(@"DAtos de la tarjeta track1:%@ track2:%@ track3:%@ authCode:%@ ,expirationdate:%@",cardData.track1,cardData.track2,cardData.track3,cardData.authCode,cardData.expireDate);
      DLog(@"DAtos de la tarjeta planid:%@ installmentplan:%@ plandescription:%@",[cardData planId],[cardData planInstallment],[cardData planDescription]);
     DLog(@"DAtos de la session planid:%@ installmentplan:%@ plandescription:%@",[Session getPlanId],[Session getPlanInstallment],[Session getPlanDescription]);
     
     NS_DURING {
     } NS_HANDLER {
          
          DLog(@"%@", [localException name]);
          DLog(@"%@", [localException reason]);
          
     } NS_ENDHANDLER
     
     [self addCardToCardArray];
     DLog(@"Se agrego card to cardarray %@",cardData.cardNumber);

}
-(void)barcodeData:(NSString *)barcode
			  type:(int)type 
{	
	if (cardData) {
		[cardData release];
		cardData=nil;
		DLog(@"libero carddata");

	}

	cardData=[[Card alloc]init];
	
	[status setString:@""];
	[status appendFormat:@"Type: %d\n",type];
	[status appendFormat:@"Type text: %@\n",[scanDevice barcodeType2Text:type]];
	[status appendFormat:@"Barcode: %@",barcode];
	DLog(@"%@", status);
		
	[cardData setTrack2:@"track2"];
	[cardData setCardNumber:[barcode copy]];
	NSString* noTarjeta=[Tools maskMonederoNumber:barcode];
	[lblCardNumber setText:noTarjeta];
	
	[lblUserText setText:@"Monedero"];
	
	[cardData setUserName:[[lblUserText text]copy]];
	[cardData setTrack1:@"Monedero"];
	[cardData setTrack3:@"track3"];
	
	[btnPay setTitle:NSLocalizedString(@"Registro", @"Authorize Payment") 
			forState:UIControlStateNormal];
	[btnPay setEnabled:YES];
	
	DLog(@"DAtos de la tarjeta track1:%@ track2:%@ track3:%@ authCode:%@ ,expirationdate:%@",cardData.track1,cardData.track2,cardData.track3,cardData.authCode,cardData.expireDate);
	//patch 1.4.5 - reprecated, monedero balance is now requested by BC
	//[self startRequestBalanceMonedero:cardData.cardNumber];
	
	
	NS_DURING {
	} NS_HANDLER {
		
		DLog(@"%@", [localException name]);
		DLog(@"%@", [localException reason]);
		
	} NS_ENDHANDLER
	
	[self addCardToCardArray];
	DLog(@"Se agrego card to cardarray %@",cardData.cardNumber);
     [self identifyBINCard];

}

-(void)barcodeScanData:(NSData *)data barcodeType:(int)thetype
{
     NSString* barcode = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
     
     if (cardData) {
          [cardData release];
          cardData=nil;
          DLog(@"libero carddata");
          
     }
     
     cardData=[[Card alloc]init];
     
     [status setString:@""];
     [status appendFormat:@"Type: %d\n",thetype];
     [status appendFormat:@"Type text: %@\n",[scanDevice barcodeType2Text:thetype]];
     [status appendFormat:@"Barcode: %@",barcode];
     DLog(@"%@", status);
     
     [cardData setTrack2:@"track2"];
     [cardData setCardNumber:[barcode copy]];
     NSString* noTarjeta=[Tools maskMonederoNumber:barcode];
     [lblCardNumber setText:noTarjeta];
     
     [lblUserText setText:@"Monedero"];
     
     [cardData setUserName:[[lblUserText text]copy]];
     [cardData setTrack1:@"Monedero"];
     [cardData setTrack3:@"track3"];
     
     [btnPay setTitle:NSLocalizedString(@"Registro", @"Authorize Payment")
             forState:UIControlStateNormal];
     [btnPay setEnabled:YES];
     
     DLog(@"DAtos de la tarjeta track1:%@ track2:%@ track3:%@ authCode:%@ ,expirationdate:%@",cardData.track1,cardData.track2,cardData.track3,cardData.authCode,cardData.expireDate);
     //patch 1.4.5 - reprecated, monedero balance is now requested by BC
     //[self startRequestBalanceMonedero:cardData.cardNumber];
     
     
     NS_DURING {
     } NS_HANDLER {
          
          DLog(@"%@", [localException name]);
          DLog(@"%@", [localException reason]);
          
     } NS_ENDHANDLER
     
     [self addCardToCardArray];
     DLog(@"Se agrego card to cardarray %@",cardData.cardNumber);
     [self identifyBINCard];

     
     [[VFDevice barcode] beepOnParsedScan:YES];
}

-(void)barcodeInitialized:(BOOL)isInitialized
{
     if (isInitialized) [VFDevice setBarcodeInitialization];
}

-(void) addCardToCardArray
{
	Card *ca=[cardData copy];
	if (!firstPaymentDone) {
		if ([cardsArray count]==1) {
			[cardsArray replaceObjectAtIndex:0 withObject:ca];
			[ca release];
			DLog(@"se reemplazo card1");
		}
		else {
			[cardsArray addObject:ca];
			[ca release];
			DLog(@"se agrego card1");

		}
	}
	else {
		if ([cardsArray count]==2) {
			[cardsArray replaceObjectAtIndex:1 withObject:ca];
			[ca release];
			DLog(@"se reemplazo card2");

		}
		else {
			[cardsArray addObject:ca];
			[ca release];
			DLog(@"se agrego card2");

		}
	}
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
		cardData=nil;
		DLog(@"libero carddata");
	}
     DLog(@"alloc carddata");
	cardData=[[Card alloc]init];
	
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
		
		[lblUserText setText:[Tools trimUsernameFromCreditCardTrack:track1]];
		track1 = [track1 substringToIndex:[track1 length] - 1];
		track1 = [track1 substringFromIndex:1];
		[cardData setUserName:[[lblUserText text]copy]];
		[cardData setTrack1:track1];
	}
	
	if(track3 == nil) {
		
		[lblDateText setText:[Tools trimExpireDateCreditCardTrack:track1]];
		[cardData setExpireDate:[Tools trimExpireDateCard:track1]];
		
		[cardData setTrack3:track3];
		
	}
     NSLog(@"LBL date %@",[Tools trimExpireDateCreditCardTrack:track1]);
     NSLog(@"TRack 3: %@",track3);
     NSLog(@"Expire date %@",[Tools trimExpireDateCard:track1]);


	
	cardData.monederoNumber=[[Session getMonederoNumber]copy];
	DLog(@"monedero: %@",[Session getMonederoNumber]);
	int sound[] = {2730,150,0,30,2730,150};

     [scanDevice playSound:100
                  beepData:sound
                    length:sizeof(sound)
                     error:nil];
	
	[btnPay setTitle:NSLocalizedString(@"Registro", @"Authorize Payment") 
			forState:UIControlStateNormal];
	[btnPay setEnabled:YES];
	
	DLog(@"DAtos de la tarjeta track1:%@ track2:%@ track3:%@ authCode:%@ ,expirationdate:%@",cardData.track1,cardData.track2,cardData.track3,cardData.authCode,cardData.expireDate);
	
	[self addCardToCardArray];
	DLog(@"Se agrego card to cardarray %@",cardData.cardNumber);
     [self identifyBINCard];

}

-(void)pinpadMSRData:(NSString*)pan expMonth:(NSString*)month expYear:(NSString*)year track1Data:(NSString*)track1 track2Data:(NSString*)track2{
     NSLog(@"S16 COMMAND PAN: %@\nExp: %@/%@\nTrack1: %@\nTrack2: %@",pan,month,year,track1,track2);
     
     if (cardData) {
          [cardData release];
          cardData=nil;
          DLog(@"libero carddata");
     }
     DLog(@"alloc carddata");
     cardData=[[Card alloc]init];
     
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
          
          [lblUserText setText:[Tools trimUsernameFromCreditCardTrack:track1]];
          track1 = [track1 substringToIndex:[track1 length] - 1];
          track1 = [track1 substringFromIndex:1];
          [cardData setUserName:[[lblUserText text]copy]];
          [cardData setTrack1:track1];
     }
     
     if(month && year) {
          [lblDateText setText:[NSString stringWithFormat:@"%@/%@",month,year]];
          [cardData setTrack3:nil];
     }
     
     cardData.monederoNumber=[[Session getMonederoNumber] copy];
     DLog(@"monedero: %@",[Session getMonederoNumber]);
     int sound[] = {2730,150,0,30,2730,150};
     
     [scanDevice playSound:100
                  beepData:sound
                    length:sizeof(sound)
                     error:nil];
     
     [btnPay setTitle:NSLocalizedString(@"Registro", @"Authorize Payment")
             forState:UIControlStateNormal];
     [btnPay setEnabled:YES];
     
     DLog(@"DAtos de la tarjeta track1:%@ track2:%@ track3:%@ authCode:%@ ,expirationdate:%@",cardData.track1,cardData.track2,cardData.track3,cardData.authCode,cardData.expireDate);
     
     [self addCardToCardArray];
     DLog(@"Se agrego card to cardarray %@",cardData.cardNumber);
     [self identifyBINCard];
     
     
}

-(void)pinPadInitialized:(BOOL)isInitialized
{
     if (isInitialized) [VFDevice setPinPadInitialization];
}

//----------------------------------------
//            ANIMATION SELECTOR
//----------------------------------------
#pragma mark -
#pragma mark ANIMATION SELECTOR

-(void)animationDidEnd:(NSString*) message forResult:(BOOL) paymentDone
{
	DLog(@"Animation did end");
	//[loading stopAnimating];
	//	[loading setHidden:YES];
	[btnPay setHidden:YES];
	
	if (paymentDone) {
		[lblSubtitle setHidden:NO];
		[lblSubtitle setText:NSLocalizedString(@"Transacción realizada", @"Subtitle text")];
		//int i = arc4random_uniform(999999);; //produce error
//		int i = arc4random() % 999999;  //reemplazo revisar
//		if (i < 0) {
//			
//			i *= -1;
//			
//		}
//		
//		NSString *aStr = [NSString stringWithFormat:NSLocalizedString(@"Operación Número: %i", @"Operation number"), i];
//		[lblOperation setText:aStr];
//		[lblOperation setHidden:NO];
		[barBtnEmail setEnabled:YES];
		//[barBtnCancel setEnabled:NO];
		
		//remove product list when transaction is completed
		//productList=nil;
		
	
		//------
	}
	else
	{
		[lblSubtitle setHidden:NO];
		[lblSubtitle setText:NSLocalizedString(message, @"Subtitle text")];
	}
	[barBtnDone setEnabled:YES];
	[barBtnEmail setEnabled:YES]; //delete 
	
}

//----------------------------------------
//            ACTIONS
//----------------------------------------
#pragma mark -
#pragma mark ACTIONS
//return button

-(IBAction)dismissSelf:(id)sender
{
     [scanDevice removeDelegate:self];
     scanDevice = nil;
     //[self dismissModalViewControllerAnimated:YES];
     if (!firstPaymentDone) {
          [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeScreensToSaleView];
          [Session setMonederoNumber:@""];
     }

}
//anular button

-(IBAction)dismissSelfToLogin
{
     //[self dismissModalViewControllerAnimated:YES];
     [self cancelPaymentRequest];
     [Session setMonederoNumber:@""];
	
}

-(IBAction)authorization:(id)sender
{
     [self promotionValidForTransaction];
         
     Card *ca=[cardsArray lastObject];
     ca.authCode=[txtAuthCode.text copy];
     DLog(@"ca.authcode %@",ca.authCode);
    
}
//-------------------------END GENERIC VIEW DELEGATE--------

-(void) identifyBINCard
{
     DLog(@"switching cardType:%i",cardType);
     Card *aCard=[cardsArray lastObject];
     int isOldDilisa=0;
     
     if ([Rules isLPCBINCard:[aCard cardNumber]]) {
          cardType=1; //LPC
          [txtAuthCode setHidden:NO];

     }else if ([Rules isDilisaBINCard:[aCard cardNumber]:&isOldDilisa])
     {
          cardType=2;//DILISA
          if (isOldDilisa==1) {
               [txtAuthCode setHidden:YES];
          }
          else
               [txtAuthCode setHidden:NO];
     }
     else if([Rules isMonederoBINCard:[aCard cardNumber]]) //is monedero
     {
          cardType=3;
          [txtAuthCode setHidden:YES];

     }
     else
     {    cardType=0; //external
          [txtAuthCode setHidden:NO];
     }


     DLog(@"result cardtype :%i flag:%i",cardType,isOldDilisa);
}


-(void) promotionValidForTransaction
{
     DLog(@"switching cardType:%i",cardType);
     Card *aCard=[cardsArray lastObject];
	switch (cardType) {
		case 0:// externas
			
              //disabled until encryption hardware
              filteredPlanGroup=[Rules filterPromotionCreditCar:originalPromotionGroup:aCard.cardNumber];
			DLog(@"promotionGroup:%@",promotionGroup);
			DLog(@"filteredPlanGroup:%@",filteredPlanGroup);
			promotionGroup=[Tools removePaymentPlanBenefitFromList:originalPromotionGroup];
			DLog(@"promotionGroup:%@",promotionGroup);
              
//              [Tools displayAlert:@"Aviso" message:@"Tipo de tarjeta temporalmente deshabilitado hasta nuevo aviso"];
//              [self resetLabels];
//              return;
			break;
		case 1:// LPC
			//return [Rules isValidTransactionLPCDILISA:productList :cardData.cardNumber];
			//return YES;
			filteredPlanGroup=[Rules filterPromotionLPCDilisa:originalPromotionGroup:aCard.cardNumber];
			DLog(@"promotionGroup:%@",promotionGroup);
			DLog(@"filteredPlanGroup:%@",filteredPlanGroup);
			promotionGroup=[Tools removePaymentPlanBenefitFromList:originalPromotionGroup];
			DLog(@"promotionGroup:%@",promotionGroup);
			break;
		case 2:// DILISA
			//return [Rules isValidTransactionLPCDILISA:productList :cardData.cardNumber];
			//return YES;
			filteredPlanGroup=[Rules filterPromotionLPCDilisa:originalPromotionGroup:aCard.cardNumber];
			DLog(@"promotionGroup:%@",promotionGroup);
			DLog(@"filteredPlanGroup:%@",filteredPlanGroup);
			promotionGroup=[Tools removePaymentPlanBenefitFromList:originalPromotionGroup];
			DLog(@"promotionGroup:%@",promotionGroup);
			
			break;
		case 3:// MONEDERO
			[Session setMonederoNumber:aCard.cardNumber];
			filteredPlanGroup=[Rules filterPromotionMonedero:originalPromotionGroup:aCard.cardNumber];
			DLog(@"promotionGroup:%@",promotionGroup);
			DLog(@"filteredPlanGroup:%@",filteredPlanGroup);
			promotionGroup=[Tools removePaymentPlanBenefitFromList:originalPromotionGroup];
			DLog(@"promotionGroup:%@",promotionGroup);
			break;
         case 4:// CASH
              //[Session setMonederoNumber:cardData.cardNumber];
              filteredPlanGroup=[Rules filterPromotionMonedero:originalPromotionGroup:aCard.cardNumber];
              DLog(@"promotionGroup:%@",promotionGroup);
              DLog(@"filteredPlanGroup:%@",filteredPlanGroup);
              promotionGroup=[Tools removePaymentPlanBenefitFromList:originalPromotionGroup];
              DLog(@"promotionGroup:%@",promotionGroup);
              break;
		default:
			break;
	}
     
     //monedero doesnt have promotions.
     if (cardType==3) {
          [self startRequest];
     }
     else //cash, cards may or may not have promotions/monedero
          [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) paymentPlanScreen:promotionGroup :filteredPlanGroup :self];

}

-(void)sendMail:(NSString*) urlPDF
{
	
	if ([urlPDF length]==0) 
	{	
        return;
	}
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Recibo Electronico Liverpool"];
	
	// Set up recipients
	/*NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
	 NSArray *ccRecipients = [NSArray arrayWithObjects:@"", @"", nil]; 
	 NSArray *bccRecipients = [NSArray arrayWithObject:@""]; 
	 
	 [picker setToRecipients:toRecipients];
	 [picker setCcRecipients:ccRecipients];	
	 [picker setBccRecipients:bccRecipients];*/
	
	// Attach an image to the email
	
	urlPDF=[urlPDF stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlPDF]];
	//DLog(@"url : %@", urlPDF);
	DLog(@"pdfdata : %@", pdfData);
	[picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"recibo.pdf"];
	
	
	// Fill out the email body text
	/*NSMutableString *aStr = [[NSMutableString alloc] initWithString:[lblTitle text]];
	 [aStr appendFormat:@"\n%@%@", [lblCard text], [lblCardNumber text]];
	 [aStr appendFormat:@"\n%@%@", [lblUser text], [lblUserText text]];
	 [aStr appendFormat:@"\n%@%@", [lblDate text], [lblDateText text]];
	 [aStr appendFormat:@"\n%@", [lblOperation text]];*/
	
	
	
	NSMutableString *aStr = [[NSMutableString alloc] init];
	[aStr appendString:@"Apreciable cliente: Liverpool agradece su preferencia, y lo invita a seguir disfrutando la mejor experiencia de compra en México, en cualquiera de nuestras tiendas o en www.liverpool.com.mx .\n\n"];
	[aStr appendString:@"Le recordamos que Liverpool es parte de MI vida...\n\n"];
	if (cardType==3)
		[aStr appendFormat:@"Forma de Pago: %@ \n",[lblUserText text]];
	else 
		[aStr appendFormat:@"Cliente: %@ \n",[lblUserText text]];
	
	[aStr appendFormat:@"Cuenta: %@ \n",[lblCardNumber text]];
	
	[aStr appendString:@"\n Atentamente: \n\n"];
	//	[aStr appendString:@"\n\n\n Saludos y quedo en espera de tus comentarios."];
	
	[picker setMessageBody:aStr isHTML:NO];
	
	//[self presentModalViewController:picker animated:YES];
     [self presentViewController:picker animated:YES completion:nil];

    [picker release];
	[pdfData release];
	[aStr release];			
	
}

-(BOOL) validatePaymentData
{
     DLog(@"validatepaymentdata cardsarray %i",[cardsArray count]);
     if (firstPaymentDone) {
          if ([cardsArray count]==1){
               	[Tools displayAlert:@"Error" message:@"Favor de deslizar la tarjeta nuevamente"];
               return NO;
          }
     }
     
     Card *aCard=[[self cardsArray]lastObject];
     //cash payment type
     if (cardType==4) {
          return YES;
     }
     else if(cardType==-1){ //fix 1.4.4
          [Tools displayAlert:@"Error" message:@"Introduzca un modo de pago valido"];
          return NO;
     }
//     else if ([txtAuthCode.text length]==0&&![txtAuthCode isHidden]) {
//		[Tools displayAlert:@"Error" message:@"Introduzca un codigo de autorizacion valido"];
//		return NO;
//	}
	else if	([aCard.track1 length]==0 || [aCard.track2 length]==0)
	{	[Tools displayAlert:@"Error" message:@"Favor de deslizar la tarjeta nuevamente"];
		return NO;
	}	
	else 
		return YES;
}
- (IBAction)selectedPayment:(id)sender{

     switch ([sender tag]) {
          //Efectivo
          case 1:
               cardType=4;
               [self cashCodeData];
               [txtAuthCode setHidden:YES];
               [self showAmountView];
               [txtAmount setUserInteractionEnabled:YES];
               break;
          
          //tarjeta
          case 2:
               cardType=2;
               [txtAmount setUserInteractionEnabled:!firstPaymentDone];
               [self showAmountView];

               break;
               
          //monedero
          case 3:
               cardType=3;
               [txtAuthCode setHidden:YES];
               [self showCardReadview];
               break;
               
          //case 4: CASH
          default:
               cardType=-1;
               break;
     }
}
- (IBAction)removeAllSubviews:(id)sender {
     [amountReaderView removeFromSuperview];
     [cardReaderView removeFromSuperview];
}

- (IBAction)okCardReadAction:(id)sender {
     
     if ([self validatePaymentData])
     {
          [self authorization:nil];
          [self removeAllSubviews:nil];
     }

}
- (IBAction)okAmountBtn:(id)sender {
//     if (![self isValidAmountValue]&&cardType!=50) {
//          [Tools displayAlert:@"Error" message:@"Monto invalido"];
//          return;
//     }
     [amountReaderView removeFromSuperview];
     //if cash
     if (cardType==4) {
          //start the payment with Cash and monedo abono
          [self authorization:nil];
     }
     else{ //dilisa, externa, monedero
          //show the cardread
          [self showCardReadview];
     }

}
-(void) showAmountView
{
     [[self view] addSubview:amountReaderView];
     [amountReaderView setFrame:CGRectMake(0, 37, amountReaderView.frame.size.width, amountReaderView.frame.size.height)];
}
-(void) showCardReadview
{
     [[self view] addSubview:cardReaderView];
     [cardReaderView setFrame:CGRectMake(0, 37, cardReaderView.frame.size.width, cardReaderView.frame.size.height)];

}

-(BOOL) canPrint
{	TicketGeneratorViewController *tk=[[[TicketGeneratorViewController alloc] init]autorelease];

	return [tk checkPrinterStatus];

}
//-(void) blockPaymentOptionsAfterFirstPayment
//{
//     //bloquea botones
//     
//     [btnCardPay setEnabled:NO];
//     [btnCashPay setEnabled:NO];
//     [btnMonederoPay setEnabled:NO];
//}
//----------------------------------------
//            MISC METHODS
//----------------------------------------
#pragma mark -
#pragma mark MISC METHODS
/*-(void)changeTotalValue:(int)amount
{
	if (amount !=  0) {
		
		total = amount;
		
	}
	NSString *totalS=[Tools calculateAmountToPayWithPromo:productList];
	NSString *aString = [[NSString alloc] initWithFormat:
						 NSLocalizedString(@"Total a Pagar: %@", @"Total to pay in Payment View"), totalS];
	[lblTitle setText:aString];
	[aString release];
}
*/
//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS

//////////////// SALE///////////////////

-(void) startRequest
{
	[Tools startActivityIndicator:self.view];
     [scanDevice disconnect];


	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
	 liverpoolRequest.delegate=self;
	 DLog(@"LA TARJETA A LA QUE SE HARA EL CARGO %@",lblCardNumber.text);
	 
	//seller object
	 Seller *seller=[[Seller alloc] init];
	 seller.password=[Session getPassword];
	 seller.userName=[Session getUserName];
	 
	
	//card object
	 Card *ca=[cardsArray lastObject];
     ca.cardType=[[NSString stringWithFormat:@"%i",cardType] copy];

     DLog(@"AUTHCODE: %@",ca.authCode);
     DLog(@"TRACK 1: %@",ca.track1);
     DLog(@"TRACK 2: %@",ca.track2);
     DLog(@"TRACK 3: %@",ca.track3);
     
     
     ca.planId=[[Session getPlanId] copy];
	ca.planInstallment=[[Session getPlanInstallment] copy];
     ca.planDescription=[[Session getPlanDescription] copy];
     
     //reset temp vars after copy
     [Session setPlanId:@""];
     [Session setPlanInstallment:@""];
     [Session setPlanDescription:@""];

	//ca.monederoNumber=[[Session getMonederoNumber] copy];
     //viewBarCodeScan.hidden=(viewBarCodeScan.hidden==TRUE)?FALSE:TRUE;
     ca.monederoNumber=(cardType==3)?[ca.cardNumber copy]:[[Session getMonederoNumber] copy];
      if(cardType==3)
           [Session setMonederoNumber:[ca cardNumber]];
     
     DLog(@"MONEDERO: %@",ca.monederoNumber);

     if ([[txtAmount text] length]==0) {
          if (firstPaymentDone) {//<<<<< 1.4.5 rev6 fix for cash
               DLog(@"total en payment %@",balanceToPay);
               ca.amountToPay=[balanceToPay copy];
          }else{
               DLog(@"total en payment %f",total);
               ca.amountToPay=[[NSString stringWithFormat:@"%.2f",total]copy] ; //<<<<< 1.4.4 fix
          }
     }else{
          ca.amountToPay=[txtAmount.text copy]; //<<<<<<<<<<<<<<<<<<<<<<<
     }
	 NSArray *pars;
	 
	//Account employee
	NSString *accountEmployee=[Session getEmployeeAccount];
	
	//Promotion Object
	PromotionGroup *promoGroup=[[PromotionGroup alloc]init];
	[promoGroup setSection:[Session getIndexPromoGroup]];
	[promoGroup setPromotionGroupArray:[promotionGroup copy]];
	
    //Type of Sale
    NSString *saleType=[self selectTypeOfSale];
    DLog(@"SALETYPE %@", saleType);

	DLog(@"promotion group section: %i, array:%@", promoGroup.section,promoGroup.promotionGroupArray);
	DLog(@"accountemployee %@",accountEmployee);
    
    SaleType sType=[Session getSaleType];

    if (sType==NORMAL_EMPLOYEE_TYPE||sType==NORMAL_CLIENT_TYPE)
    {    //Message Content
        pars=[NSArray arrayWithObjects:productList,promoGroup,ca,seller,accountEmployee,@"true",nil];
        [liverpoolRequest sendRequest:saleType forParameters:pars forRequestType:buyRequest2];
    }
    else if (sType==DULCERIA_CLIENT_TYPE)
    {
         pars=[NSArray arrayWithObjects:productList,promoGroup,ca,seller,accountEmployee,@"false",nil];
         [liverpoolRequest sendRequest:saleType forParameters:pars forRequestType:buyRequest2];
    }
    else if (sType==SOMS_EMPLOYEE_TYPE||sType==SOMS_CLIENT_TYPE)
    {
        DLog(@"ORDER SOMS %@", [Session getSomsOrder]);

        MesaDeRegalo *regalo=[[MesaDeRegalo alloc]init];
        NSString *somsOrder=[Session getSomsOrder];
        //Message Content for SOMS SALE
        pars=[NSArray arrayWithObjects:productList,promoGroup,ca,seller,accountEmployee,regalo,somsOrder,nil];
        [liverpoolRequest sendRequest:saleType forParameters:pars forRequestType:SOMSRequest];
        
        [regalo release];
    }
    //Restaurant parameters Card,Seller,Comanda,Propina,addTip;
    else if (sType==FOOD_CLIENT_TYPE)
    {
        NSString *comanda=[Session getComandaOrder];
        
        //Message Content for FOOD SALE
        pars=[NSArray arrayWithObjects:ca,seller,comanda,productList,nil];
        [liverpoolRequest sendRequest:saleType forParameters:pars forRequestType:restaurantRequest];
        
    }
     //Refund parameters 
    else if (sType==REFUND_NORMAL_TYPE||sType==REFUND_NORMAL_EMPLOYEE_TYPE)
    {
     
         DLog(@"CODEBAR: %@",[Session getRefundCodeBar]);
         RefundData *refund=[[RefundData alloc] init];
         [refund initData:[Session getRefundCodeBar]];
         
         DLog(@"salio de refund class");
         //Message Content for REFUND SALE
        // pars=[NSArray arrayWithObjects:productList,promoGroup,ca,seller,refundData,accountEmployee,nil];
//         NSMutableArray *promo=[[NSMutableArray alloc]init];
//         [promo addObject:@"test"];
         pars=[NSArray arrayWithObjects:productList,promoGroup,ca,seller,refund,accountEmployee,nil]; //promo vacias ERROR

         [liverpoolRequest sendRequest:saleType forParameters:pars forRequestType:refundRequest];
         
         [refund release];
         
    }
    [liverpoolRequest release];
    [promoGroup release];
    [seller release];

    //falta agregar el pago
}
-(NSString*) selectTypeOfSale
{
    SaleType sType=[Session getSaleType];
    NSString *type=@"";
    if (sType==NORMAL_EMPLOYEE_TYPE||sType==NORMAL_CLIENT_TYPE||sType==DULCERIA_CLIENT_TYPE)
        type=@"ventaNormal";
        //type=@"ventaClienteConTarjeta2";

    if (sType==SOMS_EMPLOYEE_TYPE||sType==SOMS_CLIENT_TYPE)
        type=@"ventaSOMS";
    if (sType==FOOD_CLIENT_TYPE)
        type=@"ventaAlimentos";
     if (sType==REFUND_NORMAL_TYPE||sType==REFUND_NORMAL_EMPLOYEE_TYPE) {
          type=@"devolucionNormal";
     }
    return type;
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	if (requestType==buyRequest||requestType==buyRequest2)
		[self paymentRequestParsing:receivedData];
	if (requestType==printingRequest) 
		[self printingRequestParsing:receivedData];
	if (requestType==bRequest) {
		[self balanceRequestParsing:receivedData];
	}
    if (requestType==restaurantRequest) {
		[self restaurantPaymentsDone:receivedData];
	}
    if (requestType==SOMSRequest) {
		[self somsPaymentsDone:receivedData];
	}
     if (requestType==refundRequest) {
          [self refundPaymentParsing:receivedData];
     }
     if (requestType==logoutRequest) {
          [self cancelPaymentRequestParsing:receivedData];
     }
	
}
-(void) paymentRequestParsing:(NSData*) data
{
     PaymentParser *payParser=[[PaymentParser alloc] init];
     [payParser startParser:data];
     DLog(@"RESULTADO DE LA COMPRA Restaurant tarjetas: %@", [payParser getMessageResponse]);
     DLog(@"Balance Restaurant tarjetas: %@", payParser.payment.balanceToPay);
     
     [self animationDidEnd:[payParser getMessageResponse] forResult:[payParser getStateOfMessage]];
     
     [Session setMonederoAmount:[[payParser payment] monederoBalance]];
     
     //if the transaction was succesful.
     if ([payParser getStateOfMessage]) {
          
          float balance=[payParser.payment.balanceToPay floatValue];
          if ( balance<=0) { // si el saldo fue suficiente para pagar el cobro
               
               [barBtnCancel setEnabled:NO]; //<<<
               [barBtnBack setEnabled:NO];
               [btnCardPay setEnabled:NO];
               [btnCashPay setEnabled:NO];
               [btnMonederoPay setEnabled:NO];
               [barBtnSMS setEnabled:YES];
               [btnPromo setHidden:YES];
               

               [Session setDocTo:payParser.payment.docto];
               [lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];
               
               [productListWithPromos release];
               productListWithPromos=[NSMutableArray arrayWithArray:[payParser returnSaleProductList]];
               [productListWithPromos retain];
               
               Card *card=[cardsArray lastObject];
               [card setAuthNumber:[payParser.payment.authorizationCode copy]];
               [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
               [card setBank:[payParser.payment.bank copy]];
               [card setBalance:[payParser.payment.monederoBalance copy]];
               [card setAmountToPay:[[payParser payment] amountPayed]];

               DLog(@"2do pago Installmentamount: %@",card.installmentsAmount);
               DLog(@"2do pago AUTHNUMBER: %@",card.authNumber);
               DLog(@"2do pago BANK: %@",card.bank);
               DLog(@"2do pago cardBalance: %@",card.balance);

               [Session setEmployeeAccount:@""];
               
               RFCCode=[payParser.payment.RFCCode copy];
               
               float cashReturned=[[[payParser payment] cashReturned] floatValue];
               if (cashReturned>0) {
                    NSString *cambio=@"TRANSACCION REALIZADA \n";
                    cambio=[cambio stringByAppendingFormat:@"CAMBIO: %@",[Tools amountCurrencyFormatFloat:cashReturned]];
                    [lblSubtitle setText:cambio];
                    DLog(@"cambiando titulo por camib %@",cambio);
                    balance=0;
                    [card setCashChange:[payParser.payment.cashReturned copy]];
                    DLog(@"Copiando cashChange %@",[card cashChange]);
               }
               [lblTitle setText:[[payParser payment] totalToPay]];
               
               //[Tools stopActivityIndicator];
               //[self printTicket];
               
       

          }
          else { //si el saldo fue insuficiente espera el segundo pago
               [barBtnCancel setEnabled:YES]; //<<<

               [Tools displayAlert:@"Aviso" message:@"favor de deslizar la siguiente tarjeta para terminar el pago"];
               [txtAmount setUserInteractionEnabled:NO];
               firstPaymentDone=YES;
               [btnPay setHidden:YES];
               [btnPromo setHidden:YES];
               [lblSubtitle setHidden:NO];
               [btnPay setAlpha:1];
               [self resetLabels];
               
               [Session setDocTo:payParser.payment.docto];
              // [Session setMonthyInterest:payParser.payment.monthlyInterest];
               //[Session setBank:payParser.payment.bank];
               [lblTitle setText:[[payParser payment] totalToPay]];
               balanceToPay=[payParser.payment.balanceToPay copy];
               //[self blockPaymentOptionsAfterFirstPayment];
               [lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];
               
               Card *card=[cardsArray lastObject];
               [card setAuthNumber:[payParser.payment.authorizationCode copy]];
               [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
               [card setBank:[payParser.payment.bank copy]];
               [card setBalance:[payParser.payment.monederoBalance copy]];
               [card setAmountToPay:[[payParser payment] amountPayed]];
               //if the payment is monedero we cant get the amount payed because it use all the balance available
               //to pay, to get the amount we have to calculate substracting the total from the balanceToPay
               if ([[card cardType]isEqualToString:@"3"]) {
                    NSString *strTotal=[NSString stringWithFormat:@"%.2f",total];
                    NSString *calculatedBalance=[Tools calculateRestValueAmount:strTotal:balanceToPay];
                    card.amountToPay=[calculatedBalance copy];
                    DLog(@"replace mondero amount to pay:%@",calculatedBalance);

               }

               DLog(@"1er pago Installmentamount: %@",card.installmentsAmount);
               DLog(@"1er pago AUTHNUMBER: %@",card.authNumber);
               DLog(@"1er pago balance: %@",balanceToPay);
               DLog(@"1er pago BANK: %@",card.bank);

               //if the transaction was sucessful but its waiting for the next payment connect the cardReader
               [scanDevice connect];
               
               firstPaymentDone=YES;
               //assign the amount left to the next payment
               txtAmount.text=[payParser.payment.balanceToPay copy];
               
               [Session setPlanInstallment:@""];
               //[Session setMonederoNumber:@""];
               [Session setPlanDescription:@""];

               //reset the info and payment mehtod to start the second pay
               //[Tools stopActivityIndicator];
               [self resetLabels]; //<<<

          }
          
     }
     else
     {
          //depending if is the first payment or the second it must remove the card array
          [Tools displayAlert:@"Error" message:[payParser getMessageResponse]];
          [barBtnCancel setEnabled:YES];
          [barBtnEmail setEnabled:NO];/////*
          [barBtnDone setEnabled:NO];
          [barBtnSMS setEnabled:NO];////*
          [Session setMonederoNumber:@""];
    
          //remove the temporal card object
          [cardData release];
          cardData =nil;
          [cardsArray removeLastObject];
          //if the transaction was unsucessful connect the cardReader
          [scanDevice connect];
          [self resetLabels];
          
     }
     [Tools stopActivityIndicator];
     [payParser release];
}
-(void) refundPaymentParsing:(NSData*) data
{
     PaymentParser *payParser=[[PaymentParser alloc] init];
     [payParser startParser:data];
     DLog(@"RESULTADO DE LA DEVOLUCION Restaurant tarjetas: %@", [payParser getMessageResponse]);
     DLog(@"Balance Restaurant tarjetas: %@", payParser.payment.balanceToPay);
     
     [self animationDidEnd:[payParser getMessageResponse] forResult:[payParser getStateOfMessage]];
     
     //if the transaction was succesful.
     if ([payParser getStateOfMessage]) {
          
          [barBtnCancel setEnabled:NO];
          [barBtnBack setEnabled:NO];
          
          float balance=[payParser.payment.balanceToPay floatValue];
          if ( balance<=0) { // si el saldo fue suficiente para pagar el cobro
               [btnCardPay setEnabled:NO];
               [btnCashPay setEnabled:NO];
               [btnMonederoPay setEnabled:NO];
               [barBtnSMS setEnabled:YES];
               
               [Session setDocTo:payParser.payment.docto];
               // [Session setMonthyInterest:payParser.payment.monthlyInterest];
               //[Session setBank:payParser.payment.bank];
               [btnPromo setHidden:YES];
               [lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];
               
               [productListWithPromos release];
               productListWithPromos=[NSMutableArray arrayWithArray:[payParser returnSaleProductList]];
               [productListWithPromos retain];
               
               Card *card=[cardsArray lastObject];
               [card setAuthNumber:[payParser.payment.authorizationCode copy]];
               [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
               [card setBank:[payParser.payment.bank copy]];
               [card setBalance:[payParser.payment.monederoBalance copy]];
               
               refundData=[[RefundData alloc]init];
               refundData.saleDate=[[payParser.refundD saleDate] copy];
               refundData.originalStore=[[payParser.refundD originalStore] copy];
               refundData.originalTerminal=[[payParser.refundD originalTerminal] copy];
               refundData.originalDocto=[[payParser.refundD originalDocto] copy];
               refundData.refundCauseNumber=[[payParser.refundD refundCauseNumber] copy];
               refundData.refundReason=[[payParser.refundD refundReason] copy];
               refundData.originalSeller=[[payParser.refundD originalSeller] copy];

               

               
               DLog(@"2do pago Installmentamount: %@",card.installmentsAmount);
               DLog(@"2do pago AUTHNUMBER: %@",card.authNumber);
               DLog(@"2do pago BANK: %@",card.bank);
               DLog(@"2do pago cardBalance: %@",card.balance);
               
               [Session setEmployeeAccount:@""];
               
               RFCCode=[payParser.payment.RFCCode copy];
               
          }
          else { //si el saldo fue insuficiente espera el segundo pago
               [Tools displayAlert:@"Aviso" message:@"favor de deslizar la siguiente tarjeta para terminar el pago"];
               [txtAmount setUserInteractionEnabled:NO];
               [txtAmount setHidden:YES];
               firstPaymentDone=YES;
               [btnPay setHidden:YES];
               [btnPromo setHidden:YES];
               [lblSubtitle setHidden:NO];
               [btnPay setAlpha:1];
               [self resetLabels];
               
               [Session setDocTo:payParser.payment.docto];
               // [Session setMonthyInterest:payParser.payment.monthlyInterest];
               //[Session setBank:payParser.payment.bank];
               
               
               balanceToPay=[payParser.payment.balanceToPay copy];
               //[self blockPaymentOptionsAfterFirstPayment];
               [lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];
               
               Card *card=[cardsArray lastObject];
               [card setAuthNumber:[payParser.payment.authorizationCode copy]];
               [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
               [card setBank:[payParser.payment.bank copy]];
               [card setBalance:[payParser.payment.monederoBalance copy]];
               
               //if the payment is monedero we cant get the amount payed because it use all the balance available
               //to pay, to get the amount we have to calculate substracting the total from the balanceToPay
               if ([[card cardType]isEqualToString:@"3"]) {
                    NSString *strTotal=[NSString stringWithFormat:@"%.2f",total];
                    NSString *calculatedBalance=[Tools calculateRestValueAmount:strTotal:balanceToPay];
                    card.amountToPay=[calculatedBalance copy];
                    DLog(@"replace mondero amount to pay:%@",calculatedBalance);
                    
               }
               
               DLog(@"1er pago Installmentamount: %@",card.installmentsAmount);
               DLog(@"1er pago AUTHNUMBER: %@",card.authNumber);
               DLog(@"1er pago balance: %@",balanceToPay);
               DLog(@"1er pago BANK: %@",card.bank);
               
               //if the transaction was sucessful but its waiting for the next payment connect the cardReader
               [scanDevice connect];
               
               firstPaymentDone=YES;
               //assign the amount left to the next payment
               txtAmount.text=[payParser.payment.balanceToPay copy];
               
               [Session setPlanInstallment:@""];
               //[Session setMonederoNumber:@""];
               [Session setPlanDescription:@""];
               
               
          }
          
     }
     else
     {
          [Tools displayAlert:@"Error" message:[payParser getMessageResponse]];
          [barBtnCancel setEnabled:YES];
          [barBtnEmail setEnabled:NO];/////*
          [barBtnDone setEnabled:NO];
          [barBtnSMS setEnabled:NO];////*
          [cardsArray removeAllObjects];
          [Session setMonederoNumber:@""];
          
          //if the transaction was unsucessful connect the cardReader
          [scanDevice connect];
          
     }
     [Tools stopActivityIndicator];
     [payParser release];
}



-(void) restaurantPaymentsDone:(NSData*) data
{
	PaymentParser *payParser=[[PaymentParser alloc] init];
	[payParser startParser:data];
	DLog(@"RESULTADO DE LA COMPRA Restaurant tarjetas: %@", [payParser getMessageResponse]);
    DLog(@"Balance Restaurant tarjetas: %@", payParser.payment.balanceToPay);

	[self animationDidEnd:[payParser getMessageResponse] forResult:[payParser getStateOfMessage]];
	
	//if the transaction was succesful.
	if ([payParser getStateOfMessage]) {
		
		[barBtnCancel setEnabled:NO];
         [barBtnBack setEnabled:NO];
         
		float balance=[payParser.payment.balanceToPay floatValue];
		if ( balance<=0) { // si el saldo del monedero fue suficiente para pagar el cobro
             [barBtnCancel setEnabled:NO]; //<<<
             [barBtnBack setEnabled:NO];
             [btnCardPay setEnabled:NO];
             [btnCashPay setEnabled:NO];
             [btnMonederoPay setEnabled:NO];
             [barBtnSMS setEnabled:YES];
             [btnPromo setHidden:YES];
			
			[Session setDocTo:payParser.payment.docto];
			//[Session setMonthyInterest:payParser.payment.monthlyInterest];
			//[Session setBank:payParser.payment.bank];
			[btnPromo setHidden:YES];
			[lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];

			[productListWithPromos release];
			productListWithPromos=[NSMutableArray arrayWithArray:[payParser returnSaleProductList]];
			[productListWithPromos retain];
			
             Card *card=[cardsArray lastObject];
             [card setAuthNumber:[payParser.payment.authorizationCode copy]];
             [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
             [card setBank:[payParser.payment.bank copy]];
             [card setBalance:[payParser.payment.monederoBalance copy]];
             [card setAmountToPay:[[payParser payment] amountPayed]];

             DLog(@"2do pago AUTHNUMBER: %@",card.authNumber);
             DLog(@"2do pago BANK: %@",card.bank);
             DLog(@"2do pago cardBalance: %@",card.balance);

             [Session setEmployeeAccount:@""];

             RFCCode=[payParser.payment.RFCCode copy];
             
             float cashReturned=[[[payParser payment] cashReturned] floatValue];
             if (cashReturned>0) {
                  NSString *cambio=@"TRANSACCION REALIZADA \n";
                  cambio=[cambio stringByAppendingFormat:@"CAMBIO: %@",[Tools amountCurrencyFormatFloat:cashReturned]];
                  [lblSubtitle setText:cambio];
                  DLog(@"cambiando titulo por camib %@",cambio);
                  balance=0;
                  [card setCashChange:[payParser.payment.cashReturned copy]];
                  DLog(@"Copiando cashChange %@",[card cashChange]);
             }
             [lblTitle setText:[[payParser payment] totalToPay]];
		}
		else { //si el saldo fue insuficiente espera el segundo pago
             [barBtnCancel setEnabled:YES]; //<<<
             
             [Tools displayAlert:@"Aviso" message:@"favor de deslizar la siguiente tarjeta para terminar el pago"];
             [txtAmount setUserInteractionEnabled:NO];
             firstPaymentDone=YES;
             [btnPay setHidden:YES];
             [btnPromo setHidden:YES];
             [lblSubtitle setHidden:NO];
             [btnPay setAlpha:1];
             [self resetLabels];
			
             [Session setDocTo:payParser.payment.docto];
             // [Session setMonthyInterest:payParser.payment.monthlyInterest];
             //[Session setBank:payParser.payment.bank];
             [lblTitle setText:[[payParser payment] totalToPay]];
             balanceToPay=[payParser.payment.balanceToPay copy];
             //[self blockPaymentOptionsAfterFirstPayment];
             [lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];
             
             Card *card=[cardsArray lastObject];
             [card setAuthNumber:[payParser.payment.authorizationCode copy]];
             [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
             [card setBank:[payParser.payment.bank copy]];
             [card setBalance:[payParser.payment.monederoBalance copy]];
             [card setAmountToPay:[[payParser payment] amountPayed]];
             //if the payment is monedero we cant get the amount payed because it use all the balance available
             //to pay, to get the amount we have to calculate substracting the total from the balanceToPay
             if ([[card cardType]isEqualToString:@"3"]) {
                  NSString *strTotal=[NSString stringWithFormat:@"%.2f",total];
                  NSString *calculatedBalance=[Tools calculateRestValueAmount:strTotal:balanceToPay];
                  card.amountToPay=[calculatedBalance copy];
                  DLog(@"replace mondero amount to pay:%@",calculatedBalance);
                  
             }
             DLog(@"1er pago BANK: %@",card.bank);
			DLog(@"1er pago AUTHNUMBER: %@",card.authNumber);
             DLog(@"1er pago balance: %@",balanceToPay);
             DLog(@"1er pago cardBalance: %@",card.balance);
             firstPaymentDone=YES;
             
             //the transaction was succesful but waiting for the next payment connect the cardReader
             [scanDevice connect];
             
             //assign the amount left to the next payment
             txtAmount.text=[payParser.payment.balanceToPay copy];
             
             [Session setPlanInstallment:@""];
             //[Session setMonederoNumber:@""];
             [Session setPlanDescription:@""];
             
             //reset the info and payment mehtod to start the second pay
             [self resetLabels]; //<<<
            
		}
        
	}
	else
	{
         //depending if is the first payment or the second it must remove the card array
         [Tools displayAlert:@"Error" message:[payParser getMessageResponse]];
         [barBtnCancel setEnabled:YES];
         [barBtnEmail setEnabled:NO];/////*
         [barBtnDone setEnabled:NO];
         [barBtnSMS setEnabled:NO];////*
         [Session setMonederoNumber:@""];
         
         //remove the temporal card object
         [cardData release];
         cardData =nil;
         [cardsArray removeLastObject];
         //if the transaction was unsucessful connect the cardReader
         [scanDevice connect];
         [self resetLabels];
         
	}
	[Tools stopActivityIndicator];
	[payParser release];
}
-(void) somsPaymentsDone:(NSData*) data
{
	PaymentParser *payParser=[[PaymentParser alloc] init];
	[payParser startParser:data];
	DLog(@"RESULTADO DE LA COMPRA Restaurant tarjetas: %@", [payParser getMessageResponse]);
    DLog(@"Balance Restaurant tarjetas: %@", payParser.payment.balanceToPay);
    
	[self animationDidEnd:[payParser getMessageResponse] forResult:[payParser getStateOfMessage]];
	
	//if the transaction was succesful.
	if ([payParser getStateOfMessage]) {
		
		[barBtnCancel setEnabled:NO];
         [barBtnBack setEnabled:NO];
		
		float balance=[payParser.payment.balanceToPay floatValue];
		if ( balance==0) { // si el saldo del monedero fue suficiente para pagar el cobro
             [btnCardPay setEnabled:NO];
             [btnCashPay setEnabled:NO];
             [btnMonederoPay setEnabled:NO];
             [txtAuthCode setHidden:YES];
			[barBtnSMS setEnabled:YES];
			
			[Session setDocTo:payParser.payment.docto];
			//[Session setMonthyInterest:payParser.payment.monthlyInterest];
			//[Session setBank:payParser.payment.bank];
			[btnPromo setHidden:YES];
			[lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];
			
			[productListWithPromos release];
			productListWithPromos=[NSMutableArray arrayWithArray:[payParser returnSaleProductList]];
			[productListWithPromos retain];
			
			Card *card=[cardsArray lastObject];
			[card setAuthNumber:[payParser.payment.authorizationCode copy]];
             [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
             [card setBank:[payParser.payment.bank copy]];
             [card setBalance:[payParser.payment.monederoBalance copy]];


             DLog(@"2do pago Installmentamount: %@",card.installmentsAmount);
             DLog(@"2do pago AUTHNUMBER: %@",card.authNumber);
             DLog(@"2do pago BANK: %@",card.bank);
             DLog(@"2do pago deliveryType: %@",payParser.payment.deliveryType);
             DLog(@"2do pago deliveryNumber: %@",payParser.payment.deliveryNumber);
             DLog(@"2do pago cardBalance: %@",card.balance);


             //set the remaining payment
             txtAmount.text=[payParser.payment.balanceToPay copy];
             

             [Session setEmployeeAccount:@""];
             RFCCode=[payParser.payment.RFCCode copy];


		}
		else { //si el saldo fue insuficiente espera el segundo pago
			[Tools displayAlert:@"Aviso" message:@"favor de deslizar la siguiente tarjeta para terminar el pago"];
			[txtAmount setUserInteractionEnabled:NO];
			//[txtAmount setHidden:YES];
			firstPaymentDone=YES;
			[btnPay setHidden:YES];
			[btnPromo setHidden:YES];
			[lblSubtitle setHidden:NO];
			[btnPay setAlpha:1];
			[self resetLabels];
			
			balanceToPay=[payParser.payment.balanceToPay copy];
			//[self blockPaymentOptionsAfterFirstPayment];
			[lblBalance setText:[Tools amountCurrencyFormatFloat:balance]];
			
             Card *card=[cardsArray lastObject];
             [card setAuthNumber:[payParser.payment.authorizationCode copy]];
             [card setInstallmentsAmount:[payParser.payment.monthlyInterest copy]];
             [card setBank:[payParser.payment.bank copy]];
             [card setBalance:[payParser.payment.monederoBalance copy]];

             //if the payment is monedero we cant get the amount payed because it use all the balance available
             //to pay, to get the amount we have to calculate substracting the total from the balanceToPay
             if ([[card cardType]isEqualToString:@"3"]) {
                  NSString *strTotal=[NSString stringWithFormat:@"%.2f",total];
                  NSString *calculatedBalance=[Tools calculateRestValueAmount:strTotal:balanceToPay];
                  card.amountToPay=[calculatedBalance copy];
                  DLog(@"replace mondero amount to pay:%@",calculatedBalance);
                  
             }
             
             DLog(@"1er pago Installmentamount: %@",card.installmentsAmount);
             DLog(@"1er pago AUTHNUMBER: %@",card.authNumber);
             DLog(@"1er pago balance: %@",balanceToPay);
             DLog(@"1er pago BANK: %@",card.bank);
             DLog(@"2do pago cardBalance: %@",card.balance);

             //if the transaction was sucessful but its waiting for the next payment connect the cardReader
             [scanDevice connect];
             
             firstPaymentDone=YES;
             
             //assign the amount left to the next payment
             txtAmount.text=[payParser.payment.balanceToPay copy];
             
             //get the somsType in order to print the format
             somsDeliveryType=[[[payParser payment]deliveryType] intValue];
             somsDeliveryDate=[[[payParser payment] orderDeliveryDate] copy];
             somsDeliveryNumber=[[[payParser payment] deliveryNumber] copy];
             
             
             [Session setPlanInstallment:@""];
             [Session setMonederoNumber:@""];
             [Session setPlanDescription:@""];
            
		}
        
	}
	else
	{
		[Tools displayAlert:@"Error" message:[payParser getMessageResponse]];
		[barBtnCancel setEnabled:YES];
		[barBtnEmail setEnabled:NO];/////*
		[barBtnDone setEnabled:NO];
		[barBtnSMS setEnabled:NO];////*
		[cardsArray removeAllObjects];
		[Session setMonederoNumber:@""];
         
         //if the transaction was unsucessful connect the cardReader
         [scanDevice connect];
        
	}
	[Tools stopActivityIndicator];
	[payParser release];
}


////////////////// PRINT////////////////////////////////////////////
-(IBAction) printPDFRequest
{
	if (![MFMailComposeViewController canSendMail]) 
	{	
        [Tools displayAlert:@"Error" message:@"La cuenta de correo no ha sido configurada"];
        return;
	}
    
	[Tools startActivityIndicator:self.view];
	DLog(@"ticketPDF"); 
	//DLog(@"ticketPDF %i , %@",[cardsArray count],cardsArray);

	
	//firm to Base64
	// UIImage *signCapture= [Tools captureSign:self.view];
	//NSString *encodedSignImage=[Tools convertImageToBase64String:signCapture];
	
	//DLog(@"PrintTicket:%@",encodedSignImage);
	//NSString *printer=[Session getPrinterName];
	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
	liverpoolRequest.delegate=self;
	// NSArray *pars=[NSArray arrayWithObjects:productList,encodedSignImage,nil];
	NSString *term=[Session getTerminal];
	NSString *docto=[Session getDocTo];
	NSString *tda=[Session getIdStore];
	NSString *vend=[Session getUserName];
	NSString *atendio=[Session getUName];
	NSString *banco=[Session getBank];
	if (banco==nil) {
		banco=@"";
	}
	
	NSArray *pars;
	if ([cardsArray count]==1) {
		Card* card1=[cardsArray objectAtIndex:0];
		pars=[NSArray arrayWithObjects:productListWithPromos,@"ESPF",term,docto,tda,vend,atendio,banco,card1,@"",nil];

	}else if ([cardsArray count]==2) {
		Card* card1=[cardsArray objectAtIndex:0];
		Card* card2=[cardsArray objectAtIndex:1];
		pars=[NSArray arrayWithObjects:productListWithPromos,@"ESPF",term,docto,tda,vend,atendio,banco,card1,card2,nil];
	}
	
	
	[liverpoolRequest sendRequest:@"imprimeTicket" forParameters:pars forRequestType:printingRequest];
	[liverpoolRequest release];
	
	
}
-(void) printingRequestParsing:(NSData*) data
{
	PrinterResponseParser *printingParser=[[PrinterResponseParser alloc] init];
	[printingParser startParser:data];
	//DLog(@"Resultado de la impresion:%@",[printingParser getStateOfMessage]);
	
	if ([printingParser getStateOfMessage]) 
	{	
		//[Tools displayAlert:@"Aviso de Impresion" message:@"Impresion Exitosa"];
		NSString *url=[printingParser returnURLPDF];
		DLog(@"url devuelto Java:%@",url);
		[self sendMail:url];
		
	}
	else
		[Tools displayAlert:@"Aviso de PDF" message:[printingParser returnErrorMessage]];
	
	[printingParser release];
	[Tools stopActivityIndicator];
	
}

-(IBAction) printTicket
{
    [Tools startActivityIndicator:self.view];

     DLog(@"bloqueando boton impresion...");
     
     TicketGeneratorViewController *tk=[[TicketGeneratorViewController alloc]init];
     tk.printGiftTicket=[Session getIsTicketGift];
     [tk setProductList:productListWithPromos];
     [tk setPaymentType:cardType];
     [tk setSOMSDeliveryType:somsDeliveryType];
     [tk setSomsOrderDeliveryDate:somsDeliveryDate];
     [tk setSomsDeliveryNumber:somsDeliveryNumber];
     [tk setRFCCode:RFCCode];
     
     [tk setRefundData:refundData];
     
     DLog(@"printTicketTwoPays");
     for (Card *cardss in cardsArray) {
          DLog(@"CARDSARRAY: %@, %@",cardss.cardNumber,cardss.track1);
     }
     [tk setCardArray:cardsArray];
     [tk printTwoPaymentTicket];

     [tk release];

}


//1.4.5 deprecated
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
//1.4.5 deprecated
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
}


////////////////////////////// LOGOUT ////////////////////////////////////
-(void) logoutRequest
{
	
	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
	liverpoolRequest.delegate=self;
	
	Seller *seller=[[Seller alloc] init];
	seller.password=[Session getPassword];
	seller.userName=[Session getUserName];
	
     NSString *tipoDeVenta=[Tools getTypeOfSaleBCString];

	NSArray *pars;
	
	pars=[NSArray arrayWithObjects:seller,tipoDeVenta,nil];
	
	[seller release];
	
	[liverpoolRequest sendRequest:@"logoutVendedor" forParameters:pars forRequestType:logoutRequest];
	[liverpoolRequest release];
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////// CANCEL_PAYMENT ////////////////////////////////////
-(void) cancelPaymentRequest
{
     
     LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
     liverpoolRequest.delegate=self;
     
     Seller *seller=[[Seller alloc] init];
     seller.password=[Session getPassword];
     seller.userName=[Session getUserName];
     
     NSString *tipoDeVenta=[Tools getTypeOfSaleBCString];
     NSArray *pars;
     
     pars=[NSArray arrayWithObjects:seller,tipoDeVenta,nil];
     
     [seller release];
     
     [liverpoolRequest sendRequest:@"invalidaPrimerPago" forParameters:pars forRequestType:logoutRequest];
     [liverpoolRequest release];
}
//on cancel response logout
-(void) cancelPaymentRequestParsing:(NSData*) data
{
     LogoutParser *logoutParser=[[LogoutParser alloc] init];
     DLog(@"antes de empezar");
     [logoutParser startParser:data];
     DLog(@"termino");
     
     if ([[logoutParser returnErrorMessage]isEqualToString:@"OK"]) {
          [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];
     }

     [logoutParser release];
     [Tools stopActivityIndicator];
}


///////////////////////////////////////////////////////////////////////////



-(BOOL) isValidAmountValue
{
	NSString* amount=txtAmount.text;
     if ([amount length]==0) {
          return NO;
     }
     else
          return [Tools isStringNumber:amount];
     
}

-(BOOL) isValidEmployeeCard
{
     /*SaleType sType=[Session getSaleType];
     Card *aCard=[cardsArray lastObject];
     //employee sale must use the same employee card as before
     //also it can be payed with a debit card even if is not a employee card
     if (sType==NORMAL_EMPLOYEE_TYPE||SOMS_EMPLOYEE_TYPE)
     {
          BOOL isOk=[Tools compareStrings:[Session getEmployeeAccount] :[aCard cardNumber]];
          if (!isOk) {
               [Tools displayAlert:@"Aviso" message:@"La tarjeta deber ser la misma que se deslizo al inicio"];
          }
          return isOk;
     }
     else */
          return YES;
}

//////////////////////////////////////////////////////
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
}

//------------------------------------------------------
//   UITextFieldDelegate
//------------------------------------------------------
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	if (numberKeyPad) {
		numberKeyPad.currentTextField = textField;
	}
	return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {	
    [self keyboardSlideUp:textField];
	if (![textField isEqual:txtAuthCode]) {
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


- (void)textFieldDidEndEditing:(UITextField *)textField {
	//if (![textField isEqual:normal]) {
    [self keyboardSlideDown:textField];
	if (textField == numberKeyPad.currentTextField) {
		/*
		 Hide the number keypad
         */
		[self.numberKeyPad removeButtonFromKeyboard];
		self.numberKeyPad = nil;
	}
	
	if (numberKeyPad.currentTextField == txtAuthCode) {
		/*
		 Hide the number keypad
		 */
		[self.numberKeyPad removeButtonFromKeyboard];
		self.numberKeyPad = nil;
         [[self view] endEditing:YES];
	}
	if (textField == txtAmount) {
		/*
		 Hide the number keypad
		 */
		NSNumberFormatter *currencyFormatter  = [[NSNumberFormatter alloc] init];
		[currencyFormatter setGeneratesDecimalNumbers:YES];
		[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		NSNumber *maxTotal=[currencyFormatter numberFromString:[lblTitle text]];
         [Tools isValidAmountToPay:txtAmount :maxTotal :cardType];
		self.numberKeyPad = nil;
         [currencyFormatter release]; 
	}
}	
-(void) keyboardSlideDown: (UITextField *) textField
{
	CGRect viewFrame=self.view.frame;
	viewFrame.origin.y+=animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self.view setFrame:viewFrame];
	[UIView commitAnimations]; 
}
-(void) keyboardSlideUp: (UITextField *) textField
{
	//keyboard slide
	CGRect textFieldRect=
	[self.view.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect= 
	[self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline=textFieldRect.origin.y +0.8 *textFieldRect.size.height;
	CGFloat numerator=
	midline-viewRect.origin.y-MINIMUN_SCROLL_FRACTION*viewRect.size.height;
	
	CGFloat denominator=
	(MAXIMUM_SCROLL_FRACTION-MINIMUN_SCROLL_FRACTION) * viewRect.size.height;
	
	CGFloat heigthFraction=numerator/denominator;
	
	if (heigthFraction<0.0) {
		heigthFraction=0.0;	
	}
	else if (heigthFraction>1.0)
	{
		heigthFraction=1.0;
	}
	
	UIInterfaceOrientation orientation=
	[[UIApplication sharedApplication] statusBarOrientation];
	if(orientation==UIInterfaceOrientationPortrait||
	   orientation==UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance=floor(PORTRAIT_KEYBOARD_HEIGHT*heigthFraction);
	}
	else {
		animatedDistance=floor(LANDSCAPE_KEYBOARD_HEIGHT*heigthFraction);
	}
	
	CGRect viewFrame=self.view.frame;
	viewFrame.origin.y-=animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
	
	//end keyboard slide
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

-(void) dealloc
{
     [amountReaderView release];
     [cardReaderView release];
     [refundData release];
	DLog(@"dealloc paymentView");
     [RFCCode release];
	[filteredPlanGroup release];
	[promotionGroup release];
	[originalPromotionGroup release];
	
	[cardsArray release], cardsArray=nil;
	[txtAmount release]; txtAmount=nil;
	[lblTitle release], lblTitle=nil;	
	[lblCard release],lblCard=nil;	
	[lblCardNumber release], lblCardNumber=nil;	
	[lblUser release], lblUser=nil;	
	[lblUserText release], lblUserText=nil;	
	[lblDate release], lblDate =nil;	
	[lblDateText release], lblDateText=nil;	
	[lblSubtitle release], lblSubtitle=nil;	
	[lblOperation release], lblOperation=nil;	
	[lblBalance release];
	[btnPay release], btnPay =nil;	
	[barBtnCancel release], barBtnCancel=nil;	
	[barBtnSMS release],barBtnSMS=nil;	
	[barBtnEmail release], barBtnEmail=nil;	
	[barBtnDone release],barBtnDone=nil;
     [barBtnBack release],barBtnBack=nil;
	//[productList release], productList=nil;	
	
	[txtAuthCode release];txtAuthCode=nil;
	[cardData release];
	[btnHideAuthCode release], btnHideAuthCode=nil;
	[super dealloc];
}
@end
