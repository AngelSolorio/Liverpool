//
//  GenericCardReaderViewController.m
//  CardReader
//
//  Created by Jonathan Esquer on 24/12/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "GenericCardReaderViewController.h"
#import "Rules.h"
#import "Styles.h"
@interface GenericCardReaderViewController ()

@end



@implementation GenericCardReaderViewController
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
@synthesize txtAuthCode;
@synthesize txtAmount;
@synthesize cardsArray;
@synthesize btnCashPay;
@synthesize btnCardPay;
@synthesize btnMonederoPay;
@synthesize btnAmountBack;
@synthesize btnAmountOk;
@synthesize btnCardBack;
@synthesize btnCardOk;
@synthesize lblBalance;
@synthesize cardCount;
@synthesize lblDigits;
@synthesize cardsBin;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
    [scanDevice connect];
    
    txtAuthCode.inputAccessoryView=[Tools inputAccessoryView:txtAuthCode];

    [self askForNextCard];
    cardCount=0;
    cardsArray=[[NSMutableArray alloc] init];

    [Styles bgGradientColorPurple:self.view];
    [Styles silverButtonStyle:btnCardOk];
    [Styles silverButtonStyle:btnCardBack];



}
-(void) viewWillDisappear:(BOOL)animated
{
    [scanDevice removeDelegate:self];
    [scanDevice disconnect];
    scanDevice = nil;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void) addCardToCardArray
{
	Card *ca=[cardData copy];
    if ([cardsArray lastObject]==nil) {
        [cardsArray addObject:ca];
        DLog(@"addobject");

    }else{
        int index=[cardsArray indexOfObject:[cardsArray lastObject]];
        [cardsArray replaceObjectAtIndex:index withObject:ca];
        DLog(@"se reemplazo card# %i",cardCount);

    }
    
//    if ([cardsArray count]==0 ) {
//        [cardsArray addObject:ca];
//        DLog(@"addobject");
//    }
//    else{
//        [cardsArray replaceObjectAtIndex:(cardCount-1) withObject:ca];
//        DLog(@"se reemplazo card# %i",cardCount);
//    }
    [ca release];
}


-(BOOL) validatePaymentData
{
    //cash payment type
    if (cardType==4) {
        return YES;
    }
    else if(cardType==-1){ //fix 1.4.4
        [Tools displayAlert:@"Error" message:@"Introduzca un modo de pago valido"];
        return NO;
    }
	else if	([cardData.track1 length]==0 || [cardData.track2 length]==0)
	{	[Tools displayAlert:@"Error" message:@"Favor de deslizar la tarjeta nuevamente"];
		return NO;
	}
	else
		return YES;
}
-(void) resetLabels
{
    
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
    
    [btnCardPay setEnabled:YES];
    [btnCashPay setEnabled:YES];
    [btnMonederoPay setEnabled:YES];
    
}
-(void) identifyBINCard
{
    DLog(@"switching cardType:%i",cardType);
    DLog(@"cardata cardnumber %@",[cardData cardNumber]);
    int isOldDilisa;
    
    if ([Rules isLPCBINCard:[cardData cardNumber]]) {
        cardType=1; //LPC
        [txtAuthCode setHidden:NO];
        
    }else if ([Rules isDilisaBINCard:[cardData cardNumber]:&isOldDilisa])
    {
        cardType=2;//DILISA
        if (isOldDilisa==1) {
            [txtAuthCode setHidden:YES];
        }
        else
            [txtAuthCode setHidden:NO];
    }
    else if([Rules isMonederoBINCard:[cardData cardNumber]]) //is monedero
    {
        cardType=3;
        [txtAuthCode setHidden:YES];
        
    }
    else
    {    cardType=0;
        [txtAuthCode setHidden:NO];
    }
    
    
    DLog(@"result cardtype :%i flag:%i",cardType,isOldDilisa);
}

- (IBAction)okCardReadAction:(id)sender {
    
    if ([self validatePaymentData]&&[self IsValidEglobalCard])
    {
        DLog(@"cardCount==[cardsBin count]");
        Card *ca=[cardsArray lastObject];
        [ca setAuthCode:[txtAuthCode text]];
        [ca setCardType:[[NSString stringWithFormat:@"%i",cardType] copy]];
        cardCount++;
        if (cardCount==[cardsBin count]) {
            [self okAction:nil];
            
        }else{
            DLog(@"cardCount==[cardsBin count] else");
            [self resetLabels];
            [self askForNextCard];
            //show next card
        }

    }
    
}
//error en el count++;
-(BOOL) IsValidEglobalCard{
    
    DLog(@"cardcount %i / cardBinCount: %i",cardCount,[cardsBin count]-1);
    DLog(@"cardsarray %i",[cardsArray count]-1);

//    if (cardCount<[cardsBin count]) {
        NSString *eglobalCard=(NSString*)[cardsBin objectAtIndex:cardCount];
        NSString * lastNumbersInCardReaded =[[cardsArray lastObject] cardNumber];
        DLog(@"lastnumber:%@",lastNumbersInCardReaded);

        lastNumbersInCardReaded=[lastNumbersInCardReaded substringWithRange:NSMakeRange(12, 4)];
        DLog(@"comparing eglobalcard:%@ / lastnumber:%@",eglobalCard,lastNumbersInCardReaded);
        if ([lastNumbersInCardReaded isEqualToString:eglobalCard]){
            return YES;
        }
        else{
            [Tools displayAlert:@"Aviso" message:@"Tarjeta ingresada no corresponde a la transaccion original"];
            return NO;
        }
//    }
//    else{
//        return NO;
//    }

}
-(void) askForNextCard{
    if (cardCount<[cardsBin count]) {
        [lblDigits setText:[cardsBin objectAtIndex:cardCount]];
    }
}
-(IBAction) okAction:(id)sender
{
	[delegate performAction:cardsArray];
}
-(IBAction) exitAction:(id)sender
{
	[delegate performExitAction];
    DLog(@"performexitaction");
}

-(void)dealloc{
    [super dealloc];
 
    //[cardsBin release];
    [delegate release];
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

	[txtAuthCode release];txtAuthCode=nil;
	[cardData release];
}

@end
