//
//  TicketGeneratorViewController.m
//  CardReader
//


#import "TicketGeneratorViewController.h"
#import "FindItemModel.h"
#import "Tools.h"
#import "StarIO/SMPort.h"
#import "FindItemModel.h"
#import "Promotions.h"
#import "CloseTerminalData.h"
#import "Session.h"
#import "CardReaderAppDelegate.h"
#import "CancelTicketData.h"
#define C_AutoCutterFullCut "\x1b\x64\x30"
#define C_LineFeedx6 "\x0a\x0a\x0a\x0a\x0a\x0a"
#define C_LineFeedx6_Size 3
#define C_AutoCutterFullCut_Size 2
@implementation TicketGeneratorViewController
@synthesize txtAProducts,productList,card,cardArray;
@synthesize promotionPlanArray;
@synthesize printGiftTicket;
@synthesize SOMSDeliveryType;
@synthesize somsOrderDeliveryDate;
@synthesize somsDeliveryNumber;
@synthesize RFCCode;
@synthesize refundData;
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
}
/*
-(void) printTicket
{

	NSMutableString *header=[[[NSMutableS tring alloc] init] autorelease];
	
	//tab settings 
	[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"]; 
	
	//LOGO
	//HEX	1B 66 00 0C
	[header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
	
	//Center aligment
	[header appendString:@"\x1b\x61\x01"];
	
	[header appendString:@" Distribuidora Liverpool S.A de C.V. \n"];
	[header appendString:@" C. Mario Pani No. 200 \n"];
	[header appendString:@" Col Santa Fe C.P. 05109 \n"];
	[header appendString:@" Deleg. Cuajimalpa de Morelos D.F \n"];
	[header appendString:@" Tel. 52.68.30.00 RFC:DLI-931201-MI9 \n"];
	[header appendString:@"------------------------------------------ \n"];
	//Left aligment
	[header appendString:@"\x1b\x61\x00"];
	
	NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
	//Center aligment
	[subHeader appendString:@"\x1b\x61\x01"];
	
	[subHeader appendFormat:@"%@ \n",[Session getStorePrint]];
    [subHeader appendString:[Session getStoreAddress]];

	[subHeader appendString:@" Blv.Cto Int Carlos Pellicer Camara Num. 129 \n"];
	[subHeader appendString:@" Col. Primero de Mayo C.P. 86190 \n"];
	[subHeader appendString:@" Villahermosa, Tabasco \n"];
	[subHeader appendString:@"\n------------------------------------------ \n\n"];
	
	//Left aligment
	[subHeader appendString:@"\x1b\x61\x00"];
	
	NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
   
    //Center aligment
	[saleData appendString:@"\x1b\x61\x01"];
    [saleData appendFormat:@"%@ \n \n",[self getSaleTypeHeader]];
    //Left aligment
	[saleData appendString:@"\x1b\x61\x00"];
	
    //Center aligment
	[subHeader appendString:@"\x1b\x61\x01"];
	[saleData appendString:@"TERM \t   DOCTO \tTDA \tVEND  \n"];
	[saleData appendFormat:@"%@ \t   %@ \t%@ \t%@  \n \n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
	[saleData appendFormat:@"\t ATENDIO:%@  \n \n",[Session getUName]];
    [saleData appendFormat:@"%@",[self getOrderNumber]];

	// appending the productarray to an string format
	
	float total=0;
	float totalDiscounts=0;
	float totalAbonoMonedero=0;
	NSString *monthlyPaymentMessage=@"";
	NSString *installmentSelected=@"";
	NSMutableString *products=[[[NSMutableString alloc] init] autorelease];

	for (FindItemModel *item in productList) {
		[Tools calculateSuccesiveDiscounts:item];

		[products appendFormat:@"%@\t         SECC %@\n ",item.description,item.department];
		[products appendFormat:@"%@\t%@     %@\n ",[self generateItemBarcodeWithZeros:item.barCode],[self getQuantityTicket:item],[self getExtendedPrice:item]];
		
		for (Promotions *promo in item.discounts) {
			if (promo.promoType==1)  //print promotion monedero
			{	[products appendFormat:@"\t%@ %@ \n",[Tools calculateDiscountValuePercentage:[promo promoValue] :promo.promoDiscountPercent] ,[promo promoDescription]];
				
				totalAbonoMonedero+=[[Tools calculateDiscountValuePercentage:[promo promoValue] :promo.promoDiscountPercent] floatValue];
                DLog(@"CACULO MONEDERO >>>Z>Z>Z>Z>Z>Z %@ - %@",[promo promoValue], [promo promoDiscountPercent]);

			}
			else if (promo.promoType==3) //print promotion by key with %
			{	
				//promo.promoValue=[Tools calculateDiscountValuePercentage:[item price]:[promo promoDiscountPercent]];
			
				[products appendFormat:@"\t%@ %@%% \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoValue]]];
				totalDiscounts+=[promo.promoValue floatValue];
				
			}
			else if(promo.promoType==4) //print promotion by key with fixed amount
				{	
				[products appendFormat:@"\t%@ $%@ \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoDiscountPercent]]];
				totalDiscounts+=[promo.promoDiscountPercent floatValue];
				
				}
			else //if([promo.promoTypeBenefit isEqualToString:@"PaymentPlanBenefit"])
				{	
					monthlyPaymentMessage=[NSString stringWithFormat:@"%@ PAGOS MENSUALES DE:",promo.promoInstallmentSelected];
					installmentSelected=[promo.promoInstallmentSelected copy];
					DLog(@"promoinstallment selected ticket:%@",promo.promoInstallmentSelected);
					//[products appendFormat:@"\t%@ %@ \n",installmentSelected,[promo promoDescription]];
					[products appendFormat:@"\t %@ \n",[promo promoDescription]];

					
				}

			
		}

		[products appendString:@"\n"];

		total+=[item.priceExtended floatValue];
	}
	//calculate the total amount for ticket with discounts
	total=total-totalDiscounts;
	
	NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];
	
	
	[footer appendFormat:@"\t\t TOTAL    %@ \n \n",[Tools amountCurrencyFormatFloat:total]];
	//Center aligment
	[footer appendString:@"\x1b\x61\x01"];
	[footer appendFormat:@"%@\n \n",[self generateTextualAmountDescription:total]];
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
	[footer appendString:@"****************************************** \n \n \n"];
	[footer appendFormat:@"\t %@  %@ \n\n",[self getPaymentType],[Tools amountCurrencyFormatFloat:total]];
	[footer appendFormat:@"%@ \n",[self getAuthorizationNumber:card]];
	[footer appendFormat:@"CUENTA:  %@ \n",[self getCardNumberMaskFormat:card.cardNumber]];
	[footer appendFormat:@"NOMBRE:  %@ \n\n",card.userName];
    [footer appendFormat:@"%@",[self getSOMSAgreements]];

	//this part calculate the payment if a payment plan was selected
	// do nothing otherwise
	// installmentamount en la respuesta de paymentparse esta devolviendo el total no el interes
	if ([installmentSelected length]!=0) {
		//if the payment is without interest
		DLog(@"entro a installmentselected monthyinsteres %@",[Session getMonthyInterest]);
		if ([[Session getMonthyInterest] length]==0)
		{
			DLog(@"installmentSelected ticket:%@ total:%f",installmentSelected,total);
			NSString *totalS=[NSString stringWithFormat:@"%.02f",total];
			NSString *div=[Tools calculateDivisionValueAmount:installmentSelected:totalS];
			div=[Tools amountCurrencyFormat:div];
			monthlyPaymentMessage=[monthlyPaymentMessage stringByAppendingString:div];
			[footer appendString:@"\t"];
			[footer appendString:monthlyPaymentMessage];
			[footer appendString:@"\n\n"];
		}
		else { // payment with interest
			DLog(@"installmentSelected payment con interes");

			NSString *interest=[Session getMonthyInterest];
			interest=[Tools amountCurrencyFormat:interest];
			monthlyPaymentMessage=[monthlyPaymentMessage stringByAppendingString:interest];
			[footer appendString:@"\t"];
			[footer appendString:monthlyPaymentMessage];
			[footer appendString:@"\n\n"];
			
			//[Session setMonthyInterest:@""];

		}
	}
	[installmentSelected release];

	//----- end of plan payment
	
	//Monedero this section only applies if the lista has a monedero promotion
	if ([Tools monederoPromotionInList:productList]) {
		DLog (@"////////////////// SI CONTIENE UN ABONO A MONEDERO");
		
		//MONEDERO DATA
		//NSString *totalS=[NSString stringWithFormat:@"%f",total];
		NSString *montoObtenido=[NSString stringWithFormat:@"%.02f",totalAbonoMonedero];
		NSString *monedero=[Session getMonederoAmount];
		NSString *saldoAnterior=[Tools calculateAddUpValueAmount:monedero :montoObtenido];

		
		DLog(@"TICKET PART MONEDEROOBTENIDO:%@ , SaldoMonederoFinal %:%@ ,montoObtenido:%@",monedero,saldoAnterior,montoObtenido);
		[footer appendFormat:@"%@           %@ \n\n",[self getCardNumberMaskFormat:card.cardNumber],[Tools amountCurrencyFormatFloat:total]];
		[footer appendFormat:@"MONEDERO %@ \n",[Session getMonederoNumber]];

		[footer appendFormat:@"Saldo Anterior\t  %@ \n",[Tools amountCurrencyFormat:monedero]];
		[footer appendFormat:@"Monto Utilizado\t  %@ \n",[Tools amountCurrencyFormatFloat:0]];
		[footer appendFormat:@"Monto Obtenido\t  %@ \n",[Tools amountCurrencyFormat:montoObtenido]];
		[footer appendFormat:@"Saldo Actual\t  %@ \n\n",[Tools amountCurrencyFormat:saldoAnterior]];
		
		[Session setMonederoAmount:@""];
		[Session setMonederoPercent:@""];
		[Session setMonederoNumber:@""];
	}
	
	//End of Monedero Balance
	
	//Center aligment
	[footer appendString:@"\x1b\x61\x01"];
	[footer appendString:@"Gracias Por Su Visita!  \n \n"];
	[footer appendFormat:@"%@ \n \n",[self generateDate]];
	[footer appendString:@"liverpool.com.mx  \n"];	
	[footer appendString:@"Centro de atencion telefonica\n"];
	[footer appendString:@"01-800-713-5555 \n\n\n\n"];
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
	
	//HEX 1D 6B m n d1....dn
	[footer appendString:@"        "];
	[footer appendString:@"\x1d\x68\x3c"]; //height
	[footer appendString:@"\x1d\x77\x02"]; //width
	[footer appendString:@"\x1d\x6b\x05"]; //command
	[footer appendFormat:@"%@\x00 \n\n",[self generateTicketCodeBar]]; //data
	[footer appendString:@"\n\n\n"];
	
	 
	
	**************************TICKET COPY ******************************************
	
	//subheader+ products custom + text	
	NSMutableString *totalCopyComprobant=[[[NSMutableString alloc] init] autorelease];
    //Center aligment
	[totalCopyComprobant appendString:@"\x1b\x61\x01"];
    [totalCopyComprobant appendFormat:@"%@ \n \n",[self getSaleTypeHeader]];
    //Left aligment
	[totalCopyComprobant appendString:@"\x1b\x61\x00"];
    
	[totalCopyComprobant appendFormat:@"\t %@  \t%@ \n",[self getPaymentType],[Tools amountCurrencyFormatFloat:total]];
	[totalCopyComprobant appendFormat:@"%@ \n",[self getAuthorizationNumber:card]];
	[totalCopyComprobant appendString:@"**********************************\n"];
	[totalCopyComprobant appendFormat:@"CUENTA:  %@ \n",[self getCardNumberMaskFormat:card.cardNumber]];
	[totalCopyComprobant appendFormat:@"NOMBRE:  %@ \n",card.userName];
	
	[totalCopyComprobant appendString:@"\t"];
	[totalCopyComprobant appendString:monthlyPaymentMessage];
	[totalCopyComprobant appendString:@"\n\n"];
	
	NSMutableString *comprobant=[[[NSMutableString alloc] init] autorelease];
	[comprobant appendString:@"\n \n Distribuidora Liverpool S.A. de C.V. \n \n"];
	[comprobant appendString:@"Mario Pani Num. 200 Col. Sta Fe. Deleg"];
	[comprobant appendString:@"Cuajimalpa de Morelos C.P. 05109 Mexico, D.F."];
	[comprobant appendString:@"TEL. 5268-3000 R.F.C DLI-931201-MI9 \n\n"];
	[comprobant appendString:@"Por el presente PAGARE, me obligo a pagar "];
	[comprobant appendString:@"incondicionalmente a la orden de distribuidora "];
	[comprobant appendString:@"Liverpool SA de C.V. y/o del emisor de la "];
	[comprobant appendString:@"tarjeta, en la ciudad de Mexico DF, o en "];
	[comprobant appendString:@"cualquier otra que se me requiera, el dia ___ "];
	[comprobant appendString:@"de ___ de ___ la cantidad de $_________. "];
	[comprobant appendString:@"El presente causara interes mensual del ____% "];
	[comprobant appendString:@"sobre el importe de este pagare y en caso de "];
	[comprobant appendString:@"incumplimiento, pagare ademas de un interes "];
	[comprobant appendString:@"moratorio del ___% mensual en terminos del "];
	[comprobant appendString:@"contrato suscrito.\n"];
	[comprobant appendString:@"Algunos de los adeudos a su cargo han sido o podran "];
	[comprobant appendString:@"ser cedidos a un fideicomiso\n \n\n\n"];
	//Center aligment
	[comprobant appendString:@"\x1b\x61\x01"];
	
	[comprobant appendString:@"___________________\n"];
	[comprobant appendString:@"Acepto       \n\n"];
	
	//Left aligment
	[subHeader appendString:@"\x1b\x61\x00"]; 
	
	[comprobant appendFormat:@"TIENDA: %i %@ \n \n",[Tools getVoucherNumber],[self generateDate]];
	
	
	NSString *ticketString=[[NSString alloc] init];
	ticketString=[ticketString stringByAppendingString:header];
	ticketString=[ticketString stringByAppendingString:subHeader];
	ticketString=[ticketString stringByAppendingString:saleData];
	ticketString=[ticketString stringByAppendingString:products];
	ticketString=[ticketString stringByAppendingString:footer];
	//[self WriteToPrinter:ticketString];
    [PrinterQueue addPrintToQueue:ticketString];


	// ticket copy part
		NSString *ticketStringComprobant=[[NSString alloc] init];
	ticketStringComprobant=[ticketStringComprobant stringByAppendingString:subHeader];
	ticketStringComprobant=[ticketStringComprobant stringByAppendingString:saleData];
	ticketStringComprobant=[ticketStringComprobant stringByAppendingString:totalCopyComprobant];
	ticketStringComprobant=[ticketStringComprobant stringByAppendingString:comprobant];
	
    [PrinterQueue addPrintToQueue:ticketStringComprobant];
    [self printComprobant];



//							[NSTimer scheduledTimerWithTimeInterval:8.0
//													  target:self 
//													selector:@selector(printComprobant:) 
//													userInfo:ticketStringComprobant repeats:NO];
	
	//txtAProducts.text=ticketString;
	
}
*/
-(void) printTwoPaymentTicket
{
	
	NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
	
	//tab settings 
	//[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
	
	//LOGO
    //Center aligment
    
	[header appendString:@"\x1b\x61\x01"];

	//HEX	1B 66 00 0C
	[header appendString:@"\t\x1b\x66\x00\x0c\n\n"];
   // [header appendString:[PrinterQueue getImageBitMapData]];
	
	//Center aligment
	[header appendString:@"\x1b\x61\x01"];
	
    

	[header appendString:@" Distribuidora Liverpool S.A de C.V. \n"];
	[header appendString:@" Mario Pani, 200 \n"];
	[header appendString:@" Col.Santa Fe Cuajimalpa C.P. 05438 \n"];
	[header appendString:@" Del. Cuajimalpa de Morelos D.F. \n"];
	[header appendString:@" RFC: DLI-931201-MI9 \n"];
	[header appendString:@"------------------------------------------ \n"];
    

	//Left aligment
	[header appendString:@"\x1b\x61\x00"];
	
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"header" ofType:@"xml"];
    //NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //[header appendString:fileContent];

    
	NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
	//Center aligment
	[subHeader appendString:@"\x1b\x61\x01"];
	
    //Bold Text ON
	[subHeader appendString:@"\x1b\x45\x01"];
	[subHeader appendFormat:@"%@ \n",[Session getStorePrint]];
    //Bold Text OFF
	[subHeader appendString:@"\x1b\x45\x00"];
    [subHeader appendString:[Session getStoreAddress]];

    /*[subHeader appendString:@" Blv.Cto Int Carlos Pellicer Camara Num. 129 \n"];
	[subHeader appendString:@" Col. Primero de Mayo C.P. 86190 \n"];
	[subHeader appendString:@" Villahermosa, Tabasco \n"];*/
	[subHeader appendString:@"\n------------------------------------------ \n\n"];
	
	//Left aligmen
	[subHeader appendString:@"\x1b\x61\x00"];
	
	NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
    //Center aligment
	[saleData appendString:@"\x1b\x61\x01"];
    //Bold Text ON
	[saleData appendString:@"\x1b\x45\x01"];
    [saleData appendFormat:@"%@ \n \n",[self getSaleTypeHeader]];
    //Bold Text OFF
	[saleData appendString:@"\x1b\x45\x00"];
    //Left aligment
	[saleData appendString:@"\x1b\x61\x00"];
    
	[saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
	[saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
	//Center aligment
    [saleData appendString:@"\x1b\x61\x01"];
    [saleData appendFormat:@"ATENDIO: %@\n \n",[Session getUName]];
    if([Session hasWarranties]) {
        [saleData appendString:@"\x1b\x61\x00"]; //Left aligment
        [saleData appendString:@"\x1b\x45\x01"]; //Bold Text ON
        [saleData appendFormat:@"REFERENCIA: %@\n\n\n",[Session getReferenceWarranty]];
        [saleData appendString:@"\x1b\x45\x00"]; //Bold Text Off
    }
    [saleData appendFormat:@"%@",[self getOrderNumber]];
	//Left aligment
    [saleData appendString:@"\x1b\x61\x00"];
	// appending the productarray to an string format
	
	float total=0;
	float totalDiscounts=0;
	float totalAbonoMonedero=0;
	NSString *monthlyPaymentMessage=@"";
	NSString *installmentSelected=@"";
	NSMutableString *products=[[[NSMutableString alloc] init] autorelease];
    float totalWarranties = 0;
	for (FindItemModel *item in productList) {
        if(item.warranty != NULL) totalWarranties += [item.warranty.cost floatValue];
        [Tools calculateSuccesiveDiscounts:item];

        //backup lines no muestran cantidad
		//[products appendFormat:@"%@\t         SECC %@\n ",item.description,item.department];
		//[products appendFormat:@"%@         %@\n ",[self generateItemBarcodeWithZeros:item.barCode],[self getExtendedPrice:item]];
		
        [products appendFormat:@"%@                 SECC %@\n ",item.description,item.department];
		[products appendFormat:@"%@       %@          %@\n ",[self generateItemBarcodeWithZeros:item.barCode],[self getQuantityTicket:item],[self getExtendedPrice:item]];
        NSLog(@"Warranty for item %@",item.warranty);
        if (item.warranty.warrantyId != NULL) {
            [products appendFormat:@"%@                 SECC %@\n ",item.warranty.detail,item.warranty.department];
            [products appendFormat:@"%@       %@          %@\n ",[item.warranty.sku substringFromIndex:8],[NSNumber numberWithInt:1],item.warranty.cost];
        }
        
        float baseAmount=0;
		for (Promotions *promo in item.discounts) {

			//if the promotion is payment plan print the format . else print the format of percentage discount
			if ([promo.promoInstallment length]>0||promo.promoType==1)  //print promotion installmetn
			{	
                DLog(@"promoValue----%@ %@",[promo promoValue],[promo promoDiscountPercent]);
                DLog(@"promoBaseAmount ---%@",[promo promoBaseAmount]);
//                [products appendFormat:@"     %@ %@ \n",[Tools calculateDiscountValuePercentage:[promo promoBaseAmount] :promo.promoDiscountPercent] ,[promo promoDescription]];
//                    totalAbonoMonedero+=[[Tools calculateDiscountValuePercentage:[promo promoBaseAmount] :promo.promoDiscountPercent] floatValue];
               
                baseAmount=[[item priceExtended]floatValue]-baseAmount;
                DLog(@"BASE AMOUNT Rest %f",baseAmount);

                NSString *baseAmountS=[NSString stringWithFormat:@"%.02f",baseAmount];
                //[products appendFormat:@"     %@ %@ \n",[Tools calculateDiscountValuePercentage:baseAmountS :promo.promoDiscountPercent] ,[promo promoDescription]];
                [products appendFormat:@"     %@ MONEDERO %%%@ \n",[Tools calculateDiscountValuePercentage:baseAmountS :promo.promoDiscountPercent] ,[promo promoDiscountPercent]];

                totalAbonoMonedero+=[[Tools calculateDiscountValuePercentage:baseAmountS :promo.promoDiscountPercent] floatValue];
   
			}
			else
			{	if (promo.promoType==3) //print promotion by key with %
			{
				//promo.promoValue=[Tools calculateDiscountValuePercentage:[item price]:[promo promoDiscountPercent]];
				
				[products appendFormat:@"     %@ %@%%      %@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoValue]]];
				totalDiscounts+=[promo.promoValue floatValue];
                baseAmount+=[[promo promoValue]floatValue];
                DLog(@"BASE AMOUNT %f",baseAmount);

				
			}
			else if(promo.promoType==4) //print promotion by key with fixed amount
			{	
				[products appendFormat:@"     %@ $%@      %@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoDiscountPercent]]];
				totalDiscounts+=[promo.promoDiscountPercent floatValue];
                baseAmount+=[[promo promoDiscountPercent]floatValue];
                DLog(@"BASE AMOUNT %f",baseAmount);

				
			}else //if([promo.promoTypeBenefit isEqualToString:@"PaymentPlanBenefit"])
			{	
				//installmentSelected=[promo.promoInstallmentSelected copy];
				//DLog(@"promoinstallment selected ticket:%@",promo.promoInstallmentSelected);
				//[products appendFormat:@"\t%@ %@ \n",installmentSelected,[promo promoDescription]];
				//[products appendFormat:@"\t %@ \n",[promo promoDescription]];
				for (Card* cards in cardArray) {
                    DLog(@"TICKETPRING planid @@@@ %@",[cards planId]);
                    if( [[cards planId]length]>=1) //patch 1.4.5 rev1
                    {
                        installmentSelected=[cards.planInstallment copy];
                        //DLog(@"promoinstallment selected ticket:%@",promo.promoInstallmentSelected);
                        //[products appendFormat:@"     %@ %@ \n",installmentSelected,[cards planDescription]];
                        [products appendString:[self getInstallmentsText:cards]];
                        //[products appendFormat:@"\t %@ \n",[promo promoDescription]];
                        [installmentSelected release];
                    }
                }

				
			}
			}
		}
        //soms deliveryDate
        [products appendString:[self getItemDeliveryDate:[item deliveryDate]]];

        
		[products appendString:@"\n"];
		
        total+=[item.priceExtended floatValue];
	}
	//calculate the total amount for ticket with discounts
    total = [Session hasWarranties] ? total-totalDiscounts+totalWarranties : total-totalDiscounts;
    
	NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];
	
    //Refund Data - print the refund data
    [footer appendString:[self getRefundDataInfo]];

    //End of Refund Data
    
    
    //Bold Text ON
	[footer appendString:@"\x1b\x45\x01"];
	[footer appendFormat:@"     ****  TOTAL    %@ \n \n",[Tools amountCurrencyFormatFloat:total]];
    //Bold Text OFF
	[footer appendString:@"\x1b\x45\x00"];
	//Center aligment
	[footer appendString:@"\x1b\x61\x01"];
	[footer appendFormat:@"*******%@********\n \n",[self generateTextualAmountDescription:total]];
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
	[footer appendString:@"\n \n \n"];
	
    BOOL isMonederoCardPrinted=NO;
	for (Card* cards in cardArray) {
        if ([cards.track1 isEqual:@"Efectivo"]) {
			pType=monederoType;
			DLog(@"CASH ACA");
			//Cash DATA
			[footer appendFormat:@"\n\t\tCONTADO %@ \n\n",[Tools amountCurrencyFormat:[cards amountToPay]]];
            [footer appendString:[self getCashChangeinfo:[cards cashChange]]];

		}
		else if ([cards.track1 isEqual:@"Monedero"]) {
            //its monedero
            isMonederoCardPrinted=YES;
			pType=monederoType;
			DLog(@"ASBSAAS ACA");
			//MONEDERO DATA
			//if the first payment was monedero the amount to pay is equal to the monedero balance coz it use all of the balance to do the first pay
			NSString *totalS=([cards.amountToPay length]>0 ? cards.amountToPay : cards.balance);
			NSString *totalAbonoMonederoS=[NSString stringWithFormat:@"%.02f",totalAbonoMonedero];
			NSString *monedero=[cards balance];
            //if the transaction is a refund type we must calculate de total and add it to the balance of the card
            SaleType saleType=[Session getSaleType];
            if (saleType==REFUND_NORMAL_TYPE||saleType==REFUND_SOMS_EMPLOYEE_TYPE||saleType==REFUND_SOMS_TYPE||saleType==REFUND_NORMAL_EMPLOYEE_TYPE) {
                [self setMonederoDepositText:totalS];
                totalS=@"0";
            }
            else{
                [self setMonederoDepositText:totalAbonoMonederoS];
            }
            NSString *montoObtenido=[cards monederoDeposit];
            NSString *saldoAnterior= [Tools calculateAddUpValueAmount:monedero :totalS];
            monedero=[Tools calculateAddUpValueAmount:monedero :montoObtenido];

            
			DLog(@"cards.amountToPay %@",cards.amountToPay);
			DLog(@"[cards balance] %@",[cards balance]);

			[footer appendFormat:@"MONEDERO %@           %@ \n\n",[self getCardNumberMaskFormat:cards.cardNumber],[Tools amountCurrencyFormat:totalS]];

			DLog(@"TICKET PART MONEDEROOBTENIDO:%@ , MON %%: %@",montoObtenido,[Session getMonederoPercent]);
			
			[footer appendFormat:@"Saldo Anterior\t  %@ \n",[Tools amountCurrencyFormat:saldoAnterior]];
			[footer appendFormat:@"Monto Utilizado\t  %@ \n",[Tools amountCurrencyFormat:totalS]];
			[footer appendFormat:@"Monto Obtenido\t  %@ \n",[Tools amountCurrencyFormat:[cards monederoDeposit]]];
			[footer appendFormat:@"Saldo Actual\t  %@ \n\n",[Tools amountCurrencyFormat:monedero] ];
            
			
			
		}else { //its dilisa-lpc
			pType=[cards.cardType intValue];
			[footer appendFormat:@"%@  \t%@ \n",[self getPaymentType:cards],[Tools amountCurrencyFormat:cards.amountToPay]];
			[footer appendFormat:@"%@ \n",[self getAuthorizationNumber:cards]];
			[footer appendFormat:@"CUENTA:  %@ \n",[self getCardNumberMaskFormat:cards.cardNumber]];
			[footer appendFormat:@"NOMBRE:  %@ \n",cards.userName];
            [footer appendString:[self printAffiliationNumber:cards]];
            //this part calculate the payment if a payment plan was selected
            // do nothing otherwise
            if ([cards.planInstallment length]!=0) {
                //if the payment is without interest
                monthlyPaymentMessage=[NSString stringWithFormat:@"%@ PAGOS MENSUALES DE:",[Tools roundUpValue:[cards planInstallment]]];

                if ([[cards installmentsAmount] length]==0)
                {
                    //NSString *totalS=[NSString stringWithFormat:@"%.02f",total];
                    NSString *div=[Tools calculateDivisionValueAmount:cards.planInstallment:cards.amountToPay];
                    float fDiv=[div floatValue];
                    fDiv=ceilf(fDiv);
                    div=[NSString stringWithFormat:@"%0.2f",fDiv];
                    div=[Tools amountCurrencyFormat:div];
                    monthlyPaymentMessage=[monthlyPaymentMessage stringByAppendingString:div];
                    [footer appendString:@"\t"];
                    [footer appendString:monthlyPaymentMessage];
                    [footer appendString:@"\n\n"];
                }
                else { // payment with interest
                   // NSString *interest=[Session getMonthyInterest];
                    NSString *interest=[cards installmentsAmount];
                    interest=[Tools amountCurrencyFormat:interest];
                    monthlyPaymentMessage=[monthlyPaymentMessage stringByAppendingString:interest];
                    [footer appendString:@"\t"];
                    [footer appendString:monthlyPaymentMessage];
                    [footer appendString:@"\n\n"];
                    
                    //[Session setMonthyInterest:@""];
                    
                }
                
            }
		}
	}
    
    //Monedero this section only applies if the lista has a monedero promotion
	if ([Tools monederoPromotionInList:productList]&&!isMonederoCardPrinted) {
        DLog (@"////////////////// SI CONTIENE UN ABONO A MONEDERO");
		
		//MONEDERO DATA
		//NSString *totalS=[NSString stringWithFormat:@"%f",total];
		NSString *montoObtenido=[NSString stringWithFormat:@"%.02f",totalAbonoMonedero];
		NSString *monedero=[Session getMonederoAmount];
		NSString *saldoAnterior=[Tools calculateAddUpValueAmount:monedero :montoObtenido];
        
		
		DLog(@"TICKET PART MONEDEROOBTENIDO:%@ , SaldoMonederoFinal %%:%@ ,montoObtenido:%@",monedero,saldoAnterior,montoObtenido);
		[footer appendFormat:@"------  %@  ------\n",[Session getMonederoNumber]];
        
		[footer appendFormat:@"Saldo Anterior\t  %@ \n",[Tools amountCurrencyFormat:monedero]];
		[footer appendFormat:@"Monto Utilizado\t  %@ \n",[Tools amountCurrencyFormatFloat:0]];
		[footer appendFormat:@"Monto Obtenido\t  %@ \n",[Tools amountCurrencyFormat:montoObtenido]];
		[footer appendFormat:@"Saldo Actual\t  %@ \n\n",[Tools amountCurrencyFormat:saldoAnterior]];
		
	
	}
    
    //Refund Data - print the refund data
    [footer appendString:[self getRefundDataWarning]];
    //End of Refund Data
    
    [footer appendFormat:@"%@",[self getSOMSAgreements]];
	[footer appendString:@"****************************************** \n \n \n"];

	//Center aligment
	[footer appendString:@"\x1b\x61\x01"];
    //Bold Text ON
	[footer appendString:@"\x1b\x45\x01"];
	[footer appendString:@"Gracias Por Su Visita!  \n \n"];
    //Bold Text OFF
	[footer appendString:@"\x1b\x45\x00"];
	[footer appendFormat:@"CLIENTE      %@ \n \n",[self generateDate]];
    
    [footer appendString:@"------------------------------------------\n\n"];
    [footer appendString:@"Codigo de barras para facturacion\n\n"];
    [footer appendFormat:@"CF:%@ \n \n",[Tools getRFCFormat:RFCCode]]; //<<<<< codigo de facturacion
                                                                                                                                                                   [footer appendString:@"------------------------------------------\n\n"];

	[footer appendString:@"liverpool.com.mx  \n"];
	[footer appendString:@"Centro de atencion telefonica CAT\n"];
    [footer appendString:@"De la Cd. de Mexico llame al 52-62-99-99\n"];
	[footer appendString:@"Del interior sin costo al 01-800-713-5555 \n\n\n\n"];
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
	
	//HEX 1D 6B m n d1....dn
	[footer appendString:@"        "];
	[footer appendString:@"\x1d\x68\x3c"]; //height
	[footer appendString:@"\x1d\x77\x02"]; //width
	[footer appendString:@"\x1d\x6b\x05"]; //command
	[footer appendFormat:@"%@\x00\n\n",[self generateTicketCodeBar]]; //data
	[footer appendString:@"\n\n\n"];
	
    //////////////////////put the ticke in the printer QUEUE/////////////////////////////////////
	NSString *ticketString=[[NSString alloc] init];
	ticketString=[ticketString stringByAppendingString:header];
	ticketString=[ticketString stringByAppendingString:subHeader];
	ticketString=[ticketString stringByAppendingString:saleData];
	ticketString=[ticketString stringByAppendingString:products];
	ticketString=[ticketString stringByAppendingString:footer];
    [PrinterQueue addPrintToQueue:ticketString];
	
	
    
    /**************************TICKET COPY *******************************************/
	
	////////////////////////// put ticket voucher in queue////////////////////////////////////////
	for (Card* cards in cardArray) {
        
        if (![[cards cardType]isEqualToString:@"3"]&&![[cards cardType]isEqualToString:@"4"]) { // if monedero or cash it doesn't print a voucher

        NSMutableString *totalCopyComprobant=[[[NSMutableString alloc] init] autorelease];
        //Center aligment
        [totalCopyComprobant appendString:@"\x1b\x61\x01"];
        //Bold Text ON
        [totalCopyComprobant appendString:@"\x1b\x45\x01"];
        [totalCopyComprobant appendFormat:@"%@ \n \n",[self getSaleTypeHeader]];
        //Bold Text OFF
        [totalCopyComprobant appendString:@"\x1b\x45\x00"];
        //Left aligment
        [totalCopyComprobant appendString:@"\x1b\x61\x00"];
    
            
//		if ([cards.track1 isEqual:@"Monedero"]) {
//			//its monedero
//			pType=monederoType;
//			NSString *totalS=([cards.amountToPay length]>0 ? [cards amountToPay] : [cards balance]);
//			[totalCopyComprobant appendFormat:@"MONEDERO %@           %@ \n\n",[self getCardNumberMaskFormat:cards.cardNumber],[Tools amountCurrencyFormat:totalS]];
//            
//			[Session setMonederoAmount:@""];
//			[Session setMonederoPercent:@""];
//			[Session setMonederoNumber:@""];
//			
//		}
//        else { //its external card
			pType=[cards.cardType intValue];
			[totalCopyComprobant appendFormat:@"\t %@  \t%@ \n",[self getPaymentType:cards],[Tools amountCurrencyFormat:cards.amountToPay]];
			[totalCopyComprobant appendFormat:@"%@ \n",[self getAuthorizationNumber:cards]];
			[totalCopyComprobant appendFormat:@"CUENTA:  %@ \n",[self getCardNumberMaskFormat:cards.cardNumber]];
			[totalCopyComprobant appendFormat:@"NOMBRE:  %@ \n",cards.userName];
            [totalCopyComprobant appendString:[self printAffiliationNumber:cards]];

            /*
            [totalCopyComprobant appendString:@"\n\t ****"];
            [totalCopyComprobant appendFormat:@"%@ PAGOS MENSUALES",cards.planInstallment];
            [totalCopyComprobant appendString:@"****\n\n"];*/
            
            //this part calculate the payment if a payment plan was selected
            // do nothing otherwise
            if ([cards.planInstallment length]!=0) {
                //if the payment is without interest
                monthlyPaymentMessage=[NSString stringWithFormat:@"%@ PAGOS MENSUALES DE:",cards.planInstallment];
                
                if ([[cards installmentsAmount] length]==0)
                {
                    //NSString *totalS=[NSString stringWithFormat:@"%.02f",total];
                    NSString *div=[Tools calculateDivisionValueAmount:cards.planInstallment:cards.amountToPay];
                    div=[Tools amountCurrencyFormat:div];
                    monthlyPaymentMessage=[monthlyPaymentMessage stringByAppendingString:div];
                    [totalCopyComprobant appendString:@"\t"];
                    [totalCopyComprobant appendString:monthlyPaymentMessage];
                    [totalCopyComprobant appendString:@"\n\n"];
                }
                else { // payment with interest
                    // NSString *interest=[Session getMonthyInterest];
                    NSString *interest=[cards installmentsAmount];
                    interest=[Tools amountCurrencyFormat:interest];
                    monthlyPaymentMessage=[monthlyPaymentMessage stringByAppendingString:interest];
                    [totalCopyComprobant appendString:@"\t"];
                    [totalCopyComprobant appendString:monthlyPaymentMessage];
                    [totalCopyComprobant appendString:@"\n\n"];
                    
                    //[Session setMonthyInterest:@""];
                    
                }
                
            }
//          }
            
            //this part generate the different formats for SALE and REFUND, including 
            NSMutableString *comprobant=[[[NSMutableString alloc] init] autorelease];
            NSMutableString *refundComprobant=[[[NSMutableString alloc] init] autorelease];
            SaleType saleType=[Session getSaleType];

            if (saleType==REFUND_SOMS_TYPE||saleType==REFUND_NORMAL_EMPLOYEE_TYPE||saleType==REFUND_NORMAL_TYPE||saleType==REFUND_NORMAL_EMPLOYEE_TYPE ) {
                
                [refundComprobant appendString:[self getRefundDataInfo]];
                
                [refundComprobant appendFormat:@"\n\n***** TOTAL $\t%@\n\n",[cards amountToPay]];
                [refundComprobant appendString:@"\t D U P L I C A D O \n\n"];
                
                [comprobant appendString:@"\n\n*ESTE DOCTO NO ES VALIDO PARA COMPRAS* \n\n"];
                [comprobant appendString:@"NOMBRE :__________________________________\n\n\n"];
                [comprobant appendString:@"DIRECC :__________________________________\n\n\n"];
                [comprobant appendString:@"__________________________________________\n\n\n"];
                [comprobant appendString:@"TELEF :__________________________________\n\n\n"];
                [comprobant appendString:@"FIRMA :__________________________________\n\n\n\n"];
                [comprobant appendFormat:@"TIENDA: %i %@ \n\n\n\n\n",[Tools getVoucherNumber],[self generateDate]];
            }
            else{
                [refundComprobant appendString:@""];
               
                //Bold Text ON
                [comprobant appendString:@"\x1b\x45\x01"];
                [comprobant appendString:@"\n \n Distribuidora Liverpool S.A. de C.V. \n \n"];
                [comprobant appendString:@"Mario Pani Num. 200 Col. Sta Fe. Deleg"];
                [comprobant appendString:@"Cuajimalpa de Morelos C.P. 05109 Mexico, D.F."];
                [comprobant appendString:@"TEL. 5268-3000 R.F.C DLI-931201-MI9 \n\n"];
                [comprobant appendString:@"Por el presente PAGARE, me obligo a pagar "];
                [comprobant appendString:@"incondicionalmente a la orden de distribuidora "];
                [comprobant appendString:@"Liverpool SA de C.V. y/o del emisor de la "];
                [comprobant appendString:@"tarjeta, en la ciudad de Mexico DF, o en "];
                [comprobant appendString:@"cualquier otra que se me requiera, el dia ___ "];
                [comprobant appendString:@"de ___ de ___ la cantidad de $_________. "];
                [comprobant appendString:@"El presente causara interes mensual del ____% "];
                [comprobant appendString:@"sobre el importe de este pagare y en caso de "];
                [comprobant appendString:@"incumplimiento, pagare ademas de un interes "];
                [comprobant appendString:@"moratorio del ___% mensual en terminos del "];
                [comprobant appendString:@"contrato suscrito.\n"];
                [comprobant appendString:@"Algunos de los adeudos a su cargo han sido o podran "];
                [comprobant appendString:@"ser cedidos a un fideicomiso\n \n\n\n"];
                //Center aligment
                [comprobant appendString:@"\x1b\x61\x01"];
                
                [comprobant appendString:@"___________________\n"];
                [comprobant appendString:@"Acepto       \n\n"];
                
                [comprobant appendString:[self printExternalPagareText:[cards cardType]]];
                 
                //Bold Text OFF
                [comprobant appendString:@"\x1b\x45\x00"];
                
                //Left aligment
                [comprobant appendString:@"\x1b\x61\x00"];
                
                [comprobant appendFormat:@"TIENDA: %i %@ \n \n",[Tools getVoucherNumber],[self generateDate]];
                

            }
            

        NSString *ticketStringComprobant=[[NSString alloc] init];
        ticketStringComprobant=[ticketStringComprobant stringByAppendingString:subHeader];
        ticketStringComprobant=[ticketStringComprobant stringByAppendingString:saleData];
        ticketStringComprobant=[ticketStringComprobant stringByAppendingString:refundComprobant];
        ticketStringComprobant=[ticketStringComprobant stringByAppendingString:totalCopyComprobant];
        ticketStringComprobant=[ticketStringComprobant stringByAppendingString:comprobant];
	
        [PrinterQueue addPrintToQueue:ticketStringComprobant];
        }
    }

    //check if is a SOMS sale
    [self printSOMSVoucher];
    //when the ticket string is complete and on queue start the printing
    [self printComprobant];
    //Print the extended warranty ticket if it has some warranties
    if([Session hasWarranties]) [self printExtendedWarrantyTicket];
    

}
-(NSString*) getInstallmentsText:(Card*)aCard
{
    NSRange binRange;
    binRange=[[aCard planDescription] rangeOfString:[aCard planInstallment] options:NSCaseInsensitiveSearch];
    //DLog(@"getInstallmentsText %@, %@",[aCard planDescription],[aCard planInstallment]);
    NSString *installment=@"";
    if(binRange.location == NSNotFound)
    {
        installment=[installment stringByAppendingFormat:@"     %@ %@ \n",[aCard planInstallment],[aCard planDescription]];
    }
    else
    {
        installment=[installment stringByAppendingFormat:@"        %@ \n",[aCard planDescription]];
    }
    
    return installment;
	
}
-(NSString*) printExternalPagareText:(NSString*) cardType
{
    //int type=[cardType integerValue];
    //print the text
    //if (type==0) {
    DLog(@"printExternalPagareText %@",cardType);
    if ([cardType isEqualToString:@"0"]) {
        
        return @"PAGARE NEGOCIABLE UNICAMENTE CON\n   INSTITUCIONES DE CREDITO \n\n";
    }else{
        return @"";
    }
}
-(NSString*) getCashChangeinfo:(NSString*) cashChange
{
//    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
//    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
//    [nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
//	
//    NSNumber *number = [nf numberFromString:cashChange];
//
//    float cash = [number floatValue];
//
    float cash =[cashChange floatValue];
    //fabsf(cash);
    DLog(@"cashchange : %@",cashChange);
    NSString* stringLine=@"";
    DLog(@"there is no change!!!! Value:%f",cash);

    if (cash!=0) { //if there's change left print the next line
        stringLine=[NSString stringWithFormat:@"\t\tCAMBIO  %@ \n\n\n",[Tools amountCurrencyFormat:cashChange]];
    }
    //[nf release];
    return stringLine;
}
//this method is called when the sale is a refund, it calculate the amount to refund and print it.
-(NSString*) getRefundMonederoData
{
    return @"";
}
-(NSString*) getSaleComprobant
{
  return @"";
}
-(NSString*) getRefundComprobant
{
  return @"";
}
-(void) setMonederoDepositText:(NSString*) amount
{
    Card *card1;
    Card *card2;
    if ([cardArray count]==1) {
        card1=[cardArray objectAtIndex:0];
        
        if ([card1.cardType isEqualToString:@"3"]) {
            card1.monederoDeposit=amount;
        }
    }
    else if ([cardArray count]==2) {
        card1=[cardArray objectAtIndex:0];
        card2=[cardArray objectAtIndex:1];
        
        if ([card2.cardType isEqualToString:@"3"]) {
            card2.monederoDeposit=amount;
            card1.monederoDeposit=@"";
        }
    }
    
    
}

-(NSString*) printAffiliationNumber:(Card*) aCard{
    NSString *affLine=@"AFILIACION :";
    NSString *affiliation=@"";
    int type=[[aCard cardType]intValue];
    if (type==0) {
        if ([[aCard bank] isEqualToString:@"AMEX"]) {
            affiliation=[Session getAmexAffNumber];
        }else{
            affiliation=[Session getBancomerAffNumber];
        }
        DLog(@"[Session getAmexAffNumber]:%@",[Session getAmexAffNumber]);
        DLog(@"[Session getBancomerAffNumber]:%@",[Session getBancomerAffNumber]);

        affLine=[affLine stringByAppendingString:affiliation];
        affLine=[affLine stringByAppendingString:@"\n\n"];
        DLog(@"AFILIATION %@",affiliation);
        DLog(@"AFFLINE %@",affLine);

        return affLine;
    }else{
        return @"\n";
    }
}
- (void)printComprobant {
//
//    if (printGiftTicket) {
//        DLog(@"preparando impresion de ticket de regalo");
//
//        [self printTicketGift];
//        [PrinterQueue startPrinting];
//    }
//    else {
//        [PrinterQueue startPrinting];
//    }

    //fix for manual setting the item for gift
    [self printTicketGift];
    NSLog(@"Start printing");
    [PrinterQueue startPrinting];
}
-(void) printSOMSVoucher
{
	if (SOMSDeliveryType==4) {
        
    
		NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
        
        //tab settings
        //[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
        
        //LOGO
        //HEX	1B 66 00 0C
        [header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
        //[header appendString:[PrinterQueue getImageBitMapData]];

        
        //Left aligment
        [header appendString:@"\x1b\x61\x00"];
        
        NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
        //Center aligment
        [subHeader appendString:@"\x1b\x61\x01"];
	
        [subHeader appendFormat:@"%@ \n",[Session getStorePrint]];
        [subHeader appendString:[Session getStoreAddress]];
        [subHeader appendString:@"\n\n"];

        NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
        //Left aligment
        [saleData appendString:@"\x1b\x61\x00"];
        
        [saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
        [saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
        //Center aligment
        [saleData appendString:@"\x1b\x61\x01"];
        [saleData appendFormat:@"ATENDIO: %@\n \n",[Session getUName]];
        // appending the productarray to an string format
        
        NSMutableString *footer=[[NSMutableString alloc]init];
        [footer appendString:@"A SU ARRIBO \n\n"];
        //Left aligment
        [footer appendString:@"\x1b\x61\x00"];
        [footer appendString:@"*********************************************** \n"];
        [footer appendString:@"En esta fecha hago pedido del producto \n"];
        [footer appendString:@"especificado en este mismo documento el cual se \n"];
        [footer appendString:@"me informo que esta agotado por el momento y \n"];
        [footer appendFormat:@"acepto entrar en fila de espera con el no.%@, \n",[self somsDeliveryNumber]];
        [footer appendString:@"con tiempo aproximado de ____ dias. \n"];
        [footer appendString:@"Recibi copia del presente. \n"];
        [footer appendString:@"**********************************************\n\n\n\n"];
    
    
        //Center aligment
        [footer appendString:@"\x1b\x61\x01"];
        [footer appendString:@"____________________________\n"];
        [footer appendString:@"Firma       \n\n"];
	
        //Left aligment
        [footer appendString:@"\x1b\x61\x00"];
        [footer appendFormat:@"TIENDA: %i %@ \n \n",[Tools getVoucherNumber],[self generateDate]];
        
        NSString *ticketString=[[NSString alloc] init];
        ticketString=[ticketString stringByAppendingString:header];
        ticketString=[ticketString stringByAppendingString:subHeader];
        ticketString=[ticketString stringByAppendingString:saleData];
        ticketString=[ticketString stringByAppendingString:footer];
        
        //[ticketString retain];
        [PrinterQueue addPrintToQueue:ticketString];
    }
    
}

/*
-(void) printTicketAirtime:(NSString*) phoneNumber
{
	
	NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
	
	//tab settings printer port
	[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"]; 
	
	//LOGO
	//HEX	1B 66 00 0C
	[header appendString:@"\t \x1b\x66\x00\x0c \n\n "]; 
	
	
	//Center aligment
	[header appendString:@"\x1b\x61\x01"]; 

	
	[header appendString:@" Distribuidora Liverpool S.A de C.V. \n"];
	[header appendString:@" C. Mario Pani No. 200 \n"];
	[header appendString:@" Col Santa Fe C.P. 05109 \n"];
	[header appendString:@" Deleg. Cuajimalpa de Morelos D.F \n"];
	[header appendString:@" Tel. 52.68.30.00 RFC:DLI-931201-MI9 \n"];
	[header appendString:@"------------------------------------------ \n"];
	
	NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
	[subHeader appendFormat:@"%@ \n",[Session getStorePrint]];
    [subHeader appendString:[Session getStoreAddress]];

    [subHeader appendString:@" Blv.Cto Int Carlos Pellicer Camara Num. 129 \n"];
	[subHeader appendString:@" Col. Primero de Mayo C.P. 86190 \n"];
	[subHeader appendString:@" Villahermosa, Tabasco \n"];
	[subHeader appendString:@"\n------------------------------------------ \n\n"];
	
	
	//Left aligment
	[subHeader appendString:@"\x1b\x61\x00"]; 
	
	
	
	NSMutableString *products=[[[NSMutableString alloc] init] autorelease];
	[products appendString:@"TERM \t   DOCTO \t TDA \t VEND  \n"];
	[products appendFormat:@"%@ \t   %@ \t%@ \t%@  \n \n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
	[products appendString:@"\t ATENDIO:  \n \n"];
    [products appendFormat:@"%@",[self getOrderNumber]];

	// appending the productarray to an string format
	
	float total=0;
	float totalDiscounts=0;
	for (FindItemModel *item in productList) {
		[products appendFormat:@"%@\t SECC %@\n ",item.description,item.department];
		[products appendFormat:@"%@ %@\n ",[self generateItemBarcodeWithZeros:item.barCode],[self getExtendedPrice:item]];
		
		for (Promotions *promo in item.discounts) {
			//if the promotion is payment plan print the format . else print the format of percentage discount
			if ([promo.promoInstallment length]>0)  //print promotion installmetn
				[products appendFormat:@"\t%@ \n\n",[promo promoDescription]];
			else	
			{	if (promo.promoType==3) //print promotion by key with %
			{	
				promo.promoValue=[Tools calculateDiscountValuePercentage:[item price]:[promo promoDiscountPercent]];
				
				[products appendFormat:@"\t%@ %@%% \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoValue]]];
				totalDiscounts+=[promo.promoValue floatValue];
				
			}
			else if(promo.promoType==4) //print promotion by key with fixed amount
			{	
				[products appendFormat:@"\t%@ $%@ \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[promo promoDiscountPercent]];
				totalDiscounts+=[promo.promoDiscountPercent floatValue];
				
			}
			}
		}
		[products appendString:@"\n"];

		total+=[item.priceExtended floatValue];
	}
	//calculate the total amount for ticket with discounts
	total=total-totalDiscounts;
	
	NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];
	[footer appendFormat:@"\t\t TOTAL  $%.02f \n \n",total];
	[footer appendFormat:@" %@\n \n",[self generateTextualAmountDescription:total]];
	[footer appendString:@"****************************************** \n \n"];
	[footer appendFormat:@"\t %@ $ \t%.02f \n",[self getPaymentType],total];
	[footer appendString:@"\tAUTORIZACION \n"];
	[footer appendString:@"*************PRESUPUESTO******************  \n"];
	[footer appendFormat:@"CUENTA:  %@ \n",[self getCardNumberMaskFormat:card.cardNumber]];
	[footer appendFormat:@"NOMBRE:  %@ \n",card.userName];
	[footer appendFormat:@"VENCE:  %@ \n\n",card.expireDate];
	[footer appendString:@"****************************************** \n \n"];
	[footer appendString:@"CONFIRMACION : \n"];
	[footer appendFormat:@"TELEFONO: %@\n\n",phoneNumber];
	[footer appendString:@"****************************************** \n \n"];
    [footer appendFormat:@"%@",[self getSOMSAgreements]];

	//NOTA falta agregar la firma con info de las compañias de telefono.
	
	
	*************************TICKET COPY ******************************************
	
	//subheader+ products custom + text	
	NSMutableString *headerCopyComprobant=[[[NSMutableString alloc] init] autorelease];
	[headerCopyComprobant appendFormat:@"\t %@ \n",[Session getStore]];
	[headerCopyComprobant appendString:@"Av. Mario Pani No-200 Santa Fe, Mex DF.\t"];
	
	
	NSMutableString *productsComprobant=[[[NSMutableString alloc] init] autorelease];
	[productsComprobant appendString:@"TERM \t DOCTO \t TDA \t VEND  \n"];
	[productsComprobant appendFormat:@"  %@ \t%@ \t%@ \t%@  \n \n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
	[productsComprobant appendString:@"\t ATENDIO:  \n \n"];
	// appending the productarray to an string format
	
	total=0;
	totalDiscounts=0;
	for (FindItemModel *item in productList) {
		[productsComprobant appendFormat:@"%@\t SECC %@\n ",item.description,item.department];
		[productsComprobant appendFormat:@"%@\t %@\n ",[self generateItemBarcodeWithZeros:item.barCode],item.price];
		
		for (Promotions *promo in item.discounts) {
			//if the promotion is payment plan print the format . else print the format of percentage discount
			if ([promo.promoInstallment length]>0)  //print promotion installmetn
				[productsComprobant appendFormat:@"\t%@ \n",[promo promoDescription]];
			else	
			{	if (promo.promoType==3) //print promotion by key with %
			{	
				[productsComprobant appendFormat:@"\t%@ %@%% \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[promo promoValue]];
				totalDiscounts+=[promo.promoValue floatValue];
				
			}
			else if(promo.promoType==4) //print promotion by key with fixed amount
			{	
				[productsComprobant appendFormat:@"\t%@ $%@ \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[promo promoDiscountPercent]];
				totalDiscounts+=[promo.promoDiscountPercent floatValue];
				
			}
			}
		}
		[productsComprobant appendString:@"\n"];

		total+=[item.priceExtended floatValue];
	}
	//calculate the total amount for ticket with discounts
	total=total-totalDiscounts;
    //Center aligment
	[productsComprobant appendString:@"\x1b\x61\x01"];
    [productsComprobant appendFormat:@"%@ \n \n",[self getSaleTypeHeader]];
    //Left aligment
	[productsComprobant appendString:@"\x1b\x61\x00"];
    
	[productsComprobant appendFormat:@"\t %@ $ \t%.02f \n\n",[self getPaymentType],total];
	[productsComprobant appendFormat:@"%@ \n",[self getAuthorizationNumber:card]];
	[productsComprobant appendFormat:@"CUENTA:  %@ \n",[self getCardNumberMaskFormat:card.cardNumber]];
	[productsComprobant appendFormat:@"NOMBRE:  %@ \n",card.userName];
	[productsComprobant appendFormat:@"VENCE:  %@ \n\n",card.expireDate];
	
	
	
	NSMutableString *comprobant=[[[NSMutableString alloc] init] autorelease];
	[comprobant appendString:@"\n \n Distribuidora Liverpool S.A. de C.V. \n \n"];
	[comprobant appendString:@"Mario Pani Num. 200 Col. Sta Fe. Deleg"];
	[comprobant appendString:@"Cuajimalpa de Morelos C.P. 05109 Mexico, D.F."];
	[comprobant appendString:@"TEL. 5268-3000 R.F.C DLI-931201-MI9 \n\n"];
	[comprobant appendString:@"Por el presente PAGARE, me obligo a pagar "];
	[comprobant appendString:@"incondicionalmente a la orden de distribuidora "];
	[comprobant appendString:@"Liverpool SA de C.V. y/o del emisor de la "];
	[comprobant appendString:@"tarjeta, en la ciudad de Mexico DF, o en "];
	[comprobant appendString:@"cualquier otra que se me requiera, el dia ___ "];
	[comprobant appendString:@"de ___ de ___ la cantidad de $_________."];
	[comprobant appendString:@"El presente causara interes mensual del ____% "];
	[comprobant appendString:@"sobre el importe de este pagare y en caso de "];
	[comprobant appendString:@"incumplimiento, pagare ademas de un interes "];
	[comprobant appendString:@"moratorio del ___% mensual en terminos del "];
	[comprobant appendString:@"contrato suscrito.\n"];
	[comprobant appendString:@"Algunos de los adeudos a su cargo han sido o podran "];
	[comprobant appendString:@"ser cedidos a un fideicomiso\n \n\n\n"];
	[comprobant appendString:@"\t ___________________\n"];
	[comprobant appendString:@"\t       Acepto       \n\n"];
	[comprobant appendFormat:@"TIENDA: %@ %@ \n \n",[Session getIdStore],[self generateDate]];
	
	
	NSString *ticketString=[[NSString alloc] init];
	ticketString=[ticketString stringByAppendingString:header];
	ticketString=[ticketString stringByAppendingString:subHeader];
	ticketString=[ticketString stringByAppendingString:products];
	ticketString=[ticketString stringByAppendingString:footer];
    [PrinterQueue addPrintToQueue:ticketString];
    [self printComprobant];
	// ticket copy part
	NSString *ticketStringComprobant=[[NSString alloc] init];
	ticketStringComprobant=[ticketStringComprobant stringByAppendingString:headerCopyComprobant];
	ticketStringComprobant=[ticketStringComprobant stringByAppendingString:productsComprobant];
	ticketStringComprobant=[ticketStringComprobant stringByAppendingString:comprobant];
	
					[NSTimer scheduledTimerWithTimeInterval:8.0
													  target:self 
													selector:@selector(printComprobant:) 
													userInfo:ticketStringComprobant repeats:NO];
	
	//txtAProducts.text=ticketString;
	
	
}
*/
/*
-(void) printTicketMonedero
{
	NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
	
	//tab settings 
	[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"]; 
	
	//LOGO
	//HEX	1B 66 00 0C
	[header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
	
	//Center aligment
	[header appendString:@"\x1b\x61\x01"];
	
	[header appendString:@" Distribuidora Liverpool S.A de C.V. \n"];
	[header appendString:@" C. Mario Pani No. 200 \n"];
	[header appendString:@" Col Santa Fe C.P. 05109 \n"];
	[header appendString:@" Deleg. Cuajimalpa de Morelos D.F \n"];
	[header appendString:@" Tel. 52.68.30.00 RFC:DLI-931201-MI9 \n"];
	[header appendString:@"------------------------------------------ \n"];
	//Left aligment
	[header appendString:@"\x1b\x61\x00"];
	
	NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
	//Center aligment
	[subHeader appendString:@"\x1b\x61\x01"];
	[subHeader appendFormat:@"%@ \n",[Session getStorePrint]];
    [subHeader appendString:[Session getStoreAddress]];

	[subHeader appendString:@" Blv.Cto Int Carlos Pellicer Camara Num. 129 \n"];
	[subHeader appendString:@" Col. Primero de Mayo C.P. 86190 \n"];
	[subHeader appendString:@" Villahermosa, Tabasco \n"];
	[subHeader appendString:@"\n------------------------------------------ \n\n"];
	
	//Left aligment
	[subHeader appendString:@"\x1b\x61\x00"];
	
	NSMutableString *products=[[[NSMutableString alloc] init] autorelease];
    //Center aligment
	[products appendString:@"\x1b\x61\x01"];
    [products appendFormat:@"%@ \n \n",[self getSaleTypeHeader]];
    //Left aligment
	[products appendString:@"\x1b\x61\x00"];
    
	[products appendString:@"TERM \t   DOCTO \tTDA \tVEND  \n"];
	[products appendFormat:@"%@ \t   %@ \t%@ \t%@  \n \n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
	[products appendFormat:@"\t ATENDIO:%@  \n \n",[Session getUName]];
    [products appendFormat:@"%@",[self getOrderNumber]];

	// appending the productarray to an string format
	
	float total=0;
	float totalDiscounts=0;
	float totalAbonoMonedero=0;
	for (FindItemModel *item in productList) {

		[Tools calculateSuccesiveDiscounts:item];

		[products appendFormat:@"%@\t     SECC %@\n ",item.description,item.department];
		[products appendFormat:@"%@     %@\n ",[self generateItemBarcodeWithZeros:item.barCode],[self getExtendedPrice:item]];
		
		for (Promotions *promo in item.discounts) {
			//if the promotion is payment plan print the format . else print the format of percentage discount
			if ([promo.promoInstallment length]>0||promo.promoType==1)  //print promotion installmetn
			{	[products appendFormat:@"\t%@ %@ \n",[Tools calculateDiscountValuePercentage:item.price :promo.promoDiscountPercent] ,[promo promoDescription]];
				totalAbonoMonedero+=[[Tools calculateDiscountValuePercentage:item.price :promo.promoDiscountPercent] floatValue];
			}
			else	
			{	if (promo.promoType==3) //print promotion by key with %
			{	
				[products appendFormat:@"\t%@ %@%% \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[promo promoValue]];
				totalDiscounts+=[promo.promoValue floatValue];
				
			}
			else if(promo.promoType==4) //print promotion by key with fixed amount
			{	
				[products appendFormat:@"\t%@ $%@ \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[promo promoDiscountPercent]];
				totalDiscounts+=[promo.promoDiscountPercent floatValue];
				
			}
			}
		}
		[products appendString:@"\n"];
		
		total+=[item.priceExtended floatValue];
	}
	//calculate the total amount for ticket with discounts
	total=total-totalDiscounts;
	
	NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];
	
	
	[footer appendFormat:@"\t\t TOTAL    %@ \n \n",[Tools amountCurrencyFormatFloat:total]];
	//Center aligment
	[footer appendString:@"\x1b\x61\x01"];
	[footer appendFormat:@"%@\n \n",[self generateTextualAmountDescription:total]];
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
	[footer appendString:@"****************************************** \n \n \n"];
	//[footer appendFormat:@"%@                 %@ \n",[self getPaymentType],[Tools amountCurrencyFormatFloat:total]];
	
	//MONEDERO DATA
	NSString *totalS=[NSString stringWithFormat:@"%f",total];
	NSString *totalAbonoMonederoS=[NSString stringWithFormat:@"%.02f",totalAbonoMonedero];
	//NSString *monedero=[Session getMonederoAmount];
	//NSString *saldoAnterior= [Tools calculateRestValueAmount:monedero :totalS];
	NSString *saldoAnterior= [Session getMonederoAmount];
	NSString *monedero= [Tools calculateRestValueAmount:saldoAnterior :totalS];

	NSString *montoObtenido=totalAbonoMonederoS;
	monedero=[Tools calculateAddUpValueAmount:monedero :montoObtenido];

	
	DLog(@"TICKET PART MONEDEROOBTENIDO:%@ , MON %:%@",montoObtenido,[Session getMonederoPercent]);
	[footer appendFormat:@"%@           %@ \n\n\n",[self getCardNumberMaskFormat:card.cardNumber],[Tools amountCurrencyFormatFloat:total]];
	
	[footer appendFormat:@"Saldo Anterior\t  %@ \n",[Tools amountCurrencyFormat:saldoAnterior]];
	[footer appendFormat:@"Monto Utilizado\t  %@ \n",[Tools amountCurrencyFormatFloat:total]];
	[footer appendFormat:@"Monto Obtenido\t  %@ \n",[Tools amountCurrencyFormat:montoObtenido]];
	[footer appendFormat:@"Saldo Actual\t  %@ \n\n",[Tools amountCurrencyFormat:monedero] ];
    [footer appendFormat:@"%@",[self getSOMSAgreements]];

	[Session setMonederoAmount:@""];
	[Session setMonederoPercent:@""];
	[Session setMonederoNumber:@""];
	//----------------
	
	//Center aligment
	[footer appendString:@"\x1b\x61\x01"];
	[footer appendString:@"Gracias Por Su Visita!  \n \n"];
	[footer appendFormat:@"%@ \n \n",[self generateDate]];
	[footer appendString:@"liverpool.com.mx  \n"];	
	[footer appendString:@"Centro de atencion telefonica\n"];
	[footer appendString:@"01-800-713-5555 \n\n\n\n"];
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
	
	//HEX 1D 6B m n d1....dn
	[footer appendString:@"        "];
	[footer appendString:@"\x1d\x68\x3c"]; //height
	[footer appendString:@"\x1d\x77\x02"]; //width
	[footer appendString:@"\x1d\x6b\x05"]; //command
	[footer appendFormat:@"%@\x00 \n\n",[self generateTicketCodeBar]]; //data
	[footer appendString:@"\n\n\n"];
	
	
	NSString *ticketString=[[NSString alloc] init];
	ticketString=[ticketString stringByAppendingString:header];
	ticketString=[ticketString stringByAppendingString:subHeader];
	ticketString=[ticketString stringByAppendingString:products];
	ticketString=[ticketString stringByAppendingString:footer];
	
    [PrinterQueue addPrintToQueue:ticketString];
    [self printComprobant];
//	txtAProducts.text=ticketString;
//	[Session setStatus:CLOSE_SESSION];
//	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];

	
}
*/
-(void) printTicketBalance:(NSString*) balance
{
	NSMutableString *ticketString=[[[NSMutableString alloc] init] autorelease];
	
	
	//tab settings 
	//[ticketString appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
	
	//LOGO
	//HEX	1B 66 00 0C
	[ticketString appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
    //[ticketString appendString:[PrinterQueue getImageBitMapData]];

	/**************** END OF SM-T300 COMMAND CONFIG ****************************************/
	
	//	[ticketString appendString:@"****************************************** \n"];
	//[ticketString appendString:@"------------------------------------------ \n\n\n"];	
	//[ticketString appendString:@"\t\tLiverpool \n"];
	//[ticketString appendString:@"------------------------------------------ \n\n\n"];
	//	[ticketString appendString:@"****************************************** \n\n\n"];
	[ticketString appendString:@"\tConsulta de Saldo                   \n\n\n"];
	//	[ticketString appendString:@"****************************************** \n\n\n"];
	[ticketString appendString:@"------------------------------------------ \n\n\n"];
	[ticketString appendFormat:@"Cuenta :   %@\n\n",[self getCardNumberMaskFormat:[card cardNumber]]];
	[ticketString appendString:[self printBalanceMessage:balance]];
	[ticketString appendFormat:@"\t%@ \n \n",[self generateDate]];
	//	[ticketString appendString:@"****************************************** \n\n\n"];
	[ticketString appendString:@"------------------------------------------ \n\n\n"];
	[ticketString appendFormat:@"Centro de Atencion Telefonica\n"];
	[ticketString appendFormat:@"5262-9999 en el D.F. o al 01800-713-5555\n"];
	[ticketString appendFormat:@"desde cualquier parte de la Republica sin costo\n"];
	[ticketString appendFormat:@"Liverpool en Linea www.liverpool.com.mx\n\n\n"];
	
	/*
	 //HEX 1D 6B m n d1....dn
	 [ticketString appendString:@"\x1d\x68\x3c"]; //height
	 [ticketString appendString:@"\x1d\x77\x02"]; //width
	 [ticketString appendString:@"\x1d\x6b\x04"]; //command
	 [ticketString appendFormat:@"%@\x00 \n\n",[self generateTicketCodeBar]]; //data
	 [ticketString appendString:@"\n\n\n"];
	 
	 */
    [PrinterQueue addPrintToQueue:ticketString];
    [self printComprobant];
	//txtAProducts.text=ticketString;
	
}
-(NSString*) printBalanceMessage:(NSString*)balance
{
    DLog(@"printlin2 balance %@",balance);
    
    NSString *balanceLine=@"";
    if (pType==monederoType) {
        int bal=[[balance stringByReplacingOccurrencesOfString:@"$" withString:@""] intValue];
        if (bal<0) {
            return @"FAVOR DE PASAR A CREDITO\n\n";
        }
        else if(bal==0){
            return [balanceLine stringByAppendingFormat:@"\t%@ Saldo :  %@\n\n",[card cardType],@"C E R O"];
        }
        else{
            return [balanceLine stringByAppendingFormat:@"\t%@ Saldo :  %@\n\n",[card cardType],balance];

        }
    }else{
      return [balanceLine stringByAppendingFormat:@"\t%@ Saldo :  %@\n\n",[card cardType],balance];
    }
    
    
}
-(void) printTicketGift
{
    DLog(@"printTicketGift");
	//check if the items has been marked for gift
    for (FindItemModel *item in productList) {
        //if the ticket is marked for gift print it
            
        if ([item itemForGift]) {

		NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
        
        //tab settings 
        //[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
        
        //LOGO
        //HEX	1B 66 00 0C
       [header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
       //[header appendString:[PrinterQueue getImageBitMapData]];

        
        //Left aligment
        [header appendString:@"\x1b\x61\x00"];
        
        NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
        //Center aligment
        [subHeader appendString:@"\x1b\x61\x01"];
        [subHeader appendString:@"\n TICKET REGALO \n\n"];

        [subHeader appendString:@"\n------------------------------------------ \n\n"];
        
        //Left aligment
        [subHeader appendString:@"\x1b\x61\x00"];
        
        NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
        //Center aligment
        [saleData appendString:@"\x1b\x61\x01"];
        [saleData appendFormat:@"%@ \n \n",[self getSaleTypeHeader]];
        //Left aligment
        [saleData appendString:@"\x1b\x61\x00"];
        
        [saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
        [saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
        [saleData appendFormat:@"     ATENDIO: %@\n \n",[Session getUName]];
            // appending the productarray to an string format
        
//        float total=0;
        float totalDiscounts=0;
//        float totalAbonoMonedero=0;
//        NSString *monthlyPaymentMessage=@"";
//        NSString *installmentSelected=@"";
        NSMutableString *products=[[[NSMutableString alloc] init] autorelease];
        
        
		[Tools calculateSuccesiveDiscounts:item];
        
		[products appendFormat:@"%@\t         SECC %@\n ",item.description,item.department];
		[products appendFormat:@"%@\t         \n ",[self generateItemBarcodeWithZeros:item.barCode]];
//		
//		for (Promotions *promo in item.discounts) {
//			//if the promotion is payment plan print the format . else print the format of percentage discount
//			if ([promo.promoInstallment length]>0||promo.promoType==1)  //print promotion installmetn
//			{	
//				[products appendFormat:@"\t%@ %@ \n",[Tools calculateDiscountValuePercentage:[item price] :promo.promoDiscountPercent] ,[promo promoDescription]];
//				
//				totalAbonoMonedero+=[[Tools calculateDiscountValuePercentage:[item price] :promo.promoDiscountPercent] floatValue];
//			
//			}
//			else	
//			{	if (promo.promoType==3) //print promotion by key with %
//			{	
//				promo.promoValue=[Tools calculateDiscountValuePercentage:[item price]:[promo promoDiscountPercent]];
//				
//				[products appendFormat:@"\t%@ %@%% \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoValue]]];
//				totalDiscounts+=[promo.promoValue floatValue];
//				
//			}
//			else if(promo.promoType==4) //print promotion by key with fixed amount
//			{	
//				[products appendFormat:@"\t%@ $%@ \t%@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoDiscountPercent]]];
//				totalDiscounts+=[promo.promoDiscountPercent floatValue];
//				
//			}else //if([promo.promoTypeBenefit isEqualToString:@"PaymentPlanBenefit"])
//			{	
//				monthlyPaymentMessage=[NSString stringWithFormat:@"%@ PAGOS MENSUALES DE:",promo.promoInstallmentSelected];
//				installmentSelected=[promo.promoInstallmentSelected copy];
//				DLog(@"promoinstallment selected ticket:%@",promo.promoInstallmentSelected);
//				[products appendFormat:@"\t %@ \n",[promo promoDescription]];
//			}
//			}
//		
//		[products appendString:@"\n"];
//		
//		total+=[item.priceExtended floatValue];
//        }
		[products appendString:@"\n"];
        
        NSMutableString *footer=[[NSMutableString alloc]init];
        //Bold Text ON
        [footer appendString:@"\x1b\x45\x01"];
        [footer appendString:@"En caso de cambio o devolucion sera indispensable presentar este ticket \n\n"];
        //Bold Text OFF
        [footer appendString:@"\x1b\x45\x00"];
        [footer appendFormat:@"CLIENTE:  %@ \n \n",[self generateDate]];
        
        //HEX 1D 6B m n d1....dn
        [footer appendString:@"\x1d\x68\x3c"]; //height
        [footer appendString:@"\x1d\x77\x02"]; //width
        //[footer appendString:@"\x1d\x48\x31"]; //HRI chars
        [footer appendString:@"\x1d\x6b\x49\x2c"]; //command
        [footer appendFormat:@"%@\n\n",[self generateTicketGiftCodeBar:item :totalDiscounts]]; //data
        [footer appendString:@"\n\n\n"];
        
        NSString *ticketString=[[NSString alloc] init];
        ticketString=[ticketString stringByAppendingString:header];
        ticketString=[ticketString stringByAppendingString:subHeader];
        ticketString=[ticketString stringByAppendingString:saleData];
        ticketString=[ticketString stringByAppendingString:products];
        ticketString=[ticketString stringByAppendingString:footer];

        [ticketString retain];

        //descuentos se tienen que resetear para imprimir el siguiente ticket del producto de regalo
        totalDiscounts=0;
        DLog(@"este item TIENE tag %i",[item itemForGift]);
        if ([item itemForGift]) {
           
            float count=[[item itemCount] floatValue];
            //if the product has a count has decimal print one ticket gift
            if (count==floor(count)) {
                
                for (int x=0; x<count; x++) {
                    [PrinterQueue addPrintToQueue:ticketString];
                }

            }
            //if the product has a count even print X quantity of ticket gift
            else
            {
                [PrinterQueue addPrintToQueue:ticketString];
  
            }
        }
    }
	}
		
}
-(void)printCloseDataTicket:(CloseTerminalData*)closeData
{
    NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
	
	//tab settings
	//[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
	
	//LOGO
	//HEX	1B 66 00 0C
	[header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
    //[header appendString:[PrinterQueue getImageBitMapData]];

	//Center aligment
	[header appendString:@"\x1b\x61\x01"];
	
	//Left aligment
	[header appendString:@"\x1b\x61\x00"];
	
	NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
	//Center aligment
	[subHeader appendString:@"\x1b\x61\x01"];
	[subHeader appendFormat:@"%@ \n",[Session getStore]];
    
	//Left aligment
	[subHeader appendString:@"\x1b\x61\x00"];
	
	NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
	[saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
	[saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
    
    //Center aligment
	[saleData appendString:@"\x1b\x61\x01"];
    [saleData appendFormat:@"ATENDIO:%@  \n \n",[Session getUName]];
	
	NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];
	
    
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
    [footer appendFormat:@"COMPUTADOR\t %@ \n",[Tools amountCurrencyFormat:[closeData computador]]];
    [footer appendFormat:@"ENTREGADO\t %@ \n",[Tools amountCurrencyFormat:[closeData entregado]]];
    [footer appendFormat:@"DIFERENCIA\t %@ \n",[Tools amountCurrencyFormat:[closeData diferencia]]];
    [footer appendFormat:@"DEVOLUCION\t %@ \n",[Tools amountCurrencyFormat:[closeData devolucion]]];
    [footer appendFormat:@"PUNTOS RIFA\t %@ \n",[Tools amountCurrencyFormat:[closeData puntosRifa]]];
    [footer appendFormat:@"VALES PAPEL\t %@ \n",[Tools amountCurrencyFormat:[closeData valesPapel]]];
    
    //Center aligment
	[footer appendString:@"\x1b\x61\x01"];
    [footer appendFormat:@"***** %@ ***** \n \n \n",[closeData transGuardadas]];
	[footer appendString:@"*******TOTALES DE TERMINAL BORRADOS*******\n"];
    [footer appendString:@"***********TERMINAL CERRADA***************\n"];
	[footer appendFormat:@"TIENDA: %@ %@ \n \n",[closeData transGuardadas],[self generateDate]];
    
	//Center aligment
	[footer appendString:@"\x1b\x61\x01"];
    //Bold Text ON
	[footer appendString:@"\x1b\x45\x01"];
	[footer appendString:@"liverpool.com.mx  \n"];
	[footer appendString:@"Centro de atencion telefonica\n"];
	[footer appendString:@"01-800-713-5555 \n\n\n\n"];
    //Bold Text OFF
	[footer appendString:@"\x1b\x45\x00"];
    
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
    
	//COMPROBANT
    
    NSMutableString *comprobant=[[[NSMutableString alloc] init] autorelease];
    
    //LOGO
	//HEX	1B 66 00 0C
	[comprobant appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
    //[comprobant appendString:[PrinterQueue getImageBitMapData]];

    //Center aligment
	[comprobant appendString:@"\x1b\x61\x01"];
    [comprobant appendFormat:@"%@ \n",[Session getStore]];
    
    //Left aligment
	[comprobant appendString:@"\x1b\x61\x00"];
	[comprobant appendFormat:@"FECHA: %@ \n\n\n",[self generateDate]];
	[comprobant appendFormat:@"TERMINAL: %@ \n\n\n",[Session getTerminal]];
	[comprobant appendFormat:@"NO. DE TICKETS: %@ \n\n\n",[closeData transGuardadas]];
    
    //Center aligment
	[comprobant appendString:@"\x1b\x61\x01"];
    [comprobant appendString:@"FOLIOS: \n\n\n"];
    
    //Left aligment
	[comprobant appendString:@"\x1b\x61\x00"];
    [comprobant appendFormat:@"DEL: 1 AL %@ \n\n\n",[closeData transGuardadas]];
    
    //Center aligment
	[comprobant appendString:@"\x1b\x61\x01"];
    [comprobant appendString:@"REVISO: \n\n\n"];
    
    
    //Left aligment
	[comprobant appendString:@"\x1b\x61\x00"];
    [comprobant appendString:@"NOMBRE:___________________________________ \n\n\n\n\n"];
    [comprobant appendString:@"FIRMA:___________________________________ \n\n"];
    
    
    
	NSString *ticketString=[[NSString alloc] init];
	ticketString=[ticketString stringByAppendingString:header];
	ticketString=[ticketString stringByAppendingString:subHeader];
	ticketString=[ticketString stringByAppendingString:saleData];
	ticketString=[ticketString stringByAppendingString:footer];
    
    
    [PrinterQueue addPrintToQueue:ticketString];
    [PrinterQueue addPrintToQueue:comprobant];
    
    [self printComprobant];
    
}

-(void)printCancelDataTicket:(CancelTicketData*)cancelData;
{
	//cash/monedero doesnt generate autho code or payment object
    //---------------------------- EGLOBAL TICKET PRINT------------------------
    for (Card *cards in cardArray) {
        if ([[cards cardType]intValue]==10) { //if cancel is a eglobal/external
        
        //tab settings
        //[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
        NSMutableString *header=[[[NSMutableString alloc] init] autorelease];

        //Center aligment
        [header appendString:@"\x1b\x61\x01"];
            
        //LOGO
        //HEX	1B 66 00 0C
        [header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
        //[header appendString:[PrinterQueue getImageBitMapData]];
        
        
        //Left aligment
        [header appendString:@"\x1b\x61\x00"];
        
        NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
        //Center aligment
        [subHeader appendString:@"\x1b\x61\x01"];
        [subHeader appendFormat:@"%@ \n",[Session getStore]];
        
        //Left aligment
        [subHeader appendString:@"\x1b\x61\x00"];
        
        NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
        [saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
        [saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
        
        //Center aligment
        [saleData appendString:@"\x1b\x61\x01"];
        [saleData appendFormat:@"ATENDIO:%@  \n \n",[Session getUName]];
        
        NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];
        
        
        //Left aligment
        [footer appendString:@"\x1b\x61\x00"];
        [footer appendFormat:@"NO. ORIGINAL DE TERMINAL       %@ \n",[cancelData originalTerminal]];
        [footer appendFormat:@"NO. TRANSACCION CANCELADA       %@ \n",[cancelData originalDocto]];
        [footer appendFormat:@"MONTO TRANSAC. CANCEL       %@ \n\n\n\n",[Tools amountCurrencyFormat:[cancelData originalAmount]]];
        
        //writing line with the *type *AuthCode *card *
        NSString *eglobalCard=[cards cardNumber];
        DLog(@"printing eglobal line %@",eglobalCard);
        [footer appendFormat:@"*%@*%@ *%@ \x09 %@\n",[cards cardType],[self printAuthCodeForDilisaCancel:[cards cardType] :[cards authCode]],[Tools maskCreditCardNumber:eglobalCard],[Tools amountCurrencyFormat:[cards amountToPay]]];

        [footer appendFormat:@"\nTIENDA: %i %@ \n \n",[Tools getVoucherNumber],[self generateDate]];
	    
        NSString *ticketString=[[NSString alloc] init];
        ticketString=[ticketString stringByAppendingString:header];
        ticketString=[ticketString stringByAppendingString:subHeader];
        ticketString=[ticketString stringByAppendingString:saleData];
        ticketString=[ticketString stringByAppendingString:footer];
        
        
        [PrinterQueue addPrintToQueue:ticketString];
        } //end if
    }//end for
    
    
    //---------------------------------- CANCEL DATA TICKET----------------------------//
    NSMutableString *header=[[[NSMutableString alloc] init] autorelease];

	//tab settings
	//[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
	
    //Center aligment
	[header appendString:@"\x1b\x61\x01"];
	
	//LOGO
	//HEX	1B 66 00 0C
	[header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
    //[header appendString:[PrinterQueue getImageBitMapData]];

		//Left aligment
	[header appendString:@"\x1b\x61\x00"];
	
	NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
	//Center aligment
	[subHeader appendString:@"\x1b\x61\x01"];
	[subHeader appendFormat:@"%@ \n",[Session getStore]];
    
	//Left aligment
	[subHeader appendString:@"\x1b\x61\x00"];
	
	NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
	[saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
	[saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
    
    //Center aligment
	[saleData appendString:@"\x1b\x61\x01"];
    [saleData appendFormat:@"ATENDIO:%@  \n \n",[Session getUName]];
	
	NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];
	
    
	//Left aligment
	[footer appendString:@"\x1b\x61\x00"];
    [footer appendFormat:@"NO. ORIGINAL DE TERMINAL       %@ \n",[cancelData originalTerminal]];
    [footer appendFormat:@"NO. TRANSACCION CANCELADA       %@ \n",[cancelData originalDocto]];
    [footer appendFormat:@"MONTO TRANSAC. CANCEL       %@ \n\n\n\n",[Tools amountCurrencyFormat:[cancelData originalAmount]]];

    //writing line with the *type *AuthCode *card *

//    if ([[cancelData authorizationCode] length]>0) {
//        [footer appendFormat:@"*%@*      *%@\n\n",[cancelData bank],[cancelData authorizationCode]];
//        DLog(@"printing autho code cancel %@",[cancelData authorizationCode]);
//
//    }else{
        for (Card *cards in cardArray) {
            NSString *eglobalCard=[cards cardNumber];
            DLog(@"printing eglobal line %@",eglobalCard);
            [footer appendFormat:@"*%@*%@ *%@ \x09 %@\n",[cards cardType],[self printAuthCodeForDilisaCancel:[cards cardType] :[cards authCode]],[Tools maskCreditCardNumber:eglobalCard],[Tools amountCurrencyFormat:[cards amountToPay]]];

        }
//    }
    
   	[footer appendFormat:@"TIENDA: %i %@ \n \n",[Tools getVoucherNumber],[self generateDate]];
	    
    
	NSString *ticketString=[[NSString alloc] init];
	ticketString=[ticketString stringByAppendingString:header];
	ticketString=[ticketString stringByAppendingString:subHeader];
	ticketString=[ticketString stringByAppendingString:saleData];
	ticketString=[ticketString stringByAppendingString:footer];
    
    
    [PrinterQueue addPrintToQueue:ticketString];
    //---------------------------------- CANCEL DATA TICKET----------------------------//

    [self printComprobant];
        
    
}

-(NSString*) printAuthCodeForDilisaCancel:(NSString*)type :(NSString*)authCode
{
    NSString *line=@"";
    int cardType=[type intValue];
    
    if (![authCode isEqual:nil]||[authCode length]>0) //if authcode is valid
        if (cardType==11||cardType==8)  //only LPC/DILISA print this special line
            line=[NSString stringWithFormat:@"      %@*",authCode];
        
    return line;
}
-(void)printWithdrawalTicket:(WithdrawDataList*)drawList;
{
    NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
	
	//LOGO
	//HEX	1B 66 00 0C
	[header appendString:@"\t\x1b\x66\x00\x0c\n\n"]; //height
    //[header appendString:[PrinterQueue getImageBitMapData]];
    
	//Center aligment
	[header appendString:@"\x1b\x61\x01"];
    
    //Left aligment
	[header appendString:@"\x1b\x61\x00"];
	
	NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
	//Center aligment
	[subHeader appendString:@"\x1b\x61\x01"];
	[subHeader appendFormat:@"%@ \n",[Session getStore]];
    
	//Left aligment
	[subHeader appendString:@"\x1b\x61\x00"];
	
	NSMutableString *saleData=[[[NSMutableString alloc] init] autorelease];
	[saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
	[saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
    
    //Center aligment
	[saleData appendString:@"\x1b\x61\x01"];
    [saleData appendFormat:@"ATENDIO:%@\n\n",[Session getUName]];
	
	NSMutableString *table=[[[NSMutableString alloc] init] autorelease];
	
    
	//Left aligment
	[table appendString:@"\x1b\x61\x00"];
    float contado=0;
    float monto=0;
    
    //calculate the amounts and totals for the table to print
    for (WithdrawData *data in [drawList getWithdrawList]) {
        NSString *amountCalculated=[Tools calculateMultiplyValueAmount:data.amount :data.quantity];
        [table appendFormat:@"   CONTA  %@            %@           %@\n",data.amount,data.quantity,amountCalculated];

        contado+=[[data amount]floatValue];
        monto+=[ amountCalculated floatValue];
    }
    NSMutableString *footer=[[[NSMutableString alloc] init] autorelease];

    //Left aligment
	[footer appendString:@"\x1b\x61\x00"];
  	[footer appendString:@"\n\nRESUMEN DE CONTEO DE RETIRO\n\n"];
  	[footer appendString:@"      TIPO DE PAGO CNT       MONTO \n\n"];
    [footer appendFormat:@"      CONTADO %@       %@\n\n",[Tools amountCurrencyFormatFloat:contado],[Tools amountCurrencyFormatFloat:monto]];
    [footer appendFormat:@"CONTEO TOTAL DE RETIRO %@ \n\n",[Tools amountCurrencyFormatFloat:monto]];
    [footer appendFormat:@"TOTAL RETIRADO ACTUAL: %@ \n\n",[Tools amountCurrencyFormat:[drawList totalAmountWithdrawn]]];
   	[footer appendFormat:@"TIENDA: %i %@ \n \n",[Tools getVoucherNumber],[self generateDate]];
    
	NSString *ticketString=[[NSString alloc] init];
	ticketString=[ticketString stringByAppendingString:header];
	ticketString=[ticketString stringByAppendingString:subHeader];
    ticketString=[ticketString stringByAppendingString:saleData];
	ticketString=[ticketString stringByAppendingString:table];
	ticketString=[ticketString stringByAppendingString:footer];
    
    
    [PrinterQueue addPrintToQueue:ticketString];
    [PrinterQueue addPrintToQueue:ticketString];

    [self printComprobant];
    
}

//********************************************* MISC METHODS ******************************************************/
-(NSString*) getExtendedPrice:(FindItemModel*) item
{
   /* float qty=[item.itemCount floatValue];
    DLog(@"getExtendedPrice %@",item.priceExtended);
    NSString *price;
    if (qty!=1) {
        price=[[item priceExtended] copy];
    }
    else
        price=[[item price] copy];
*/
    NSString *price;
    DLog(@"PRICEEXTENDED %@",[item priceExtended] );
    price=[[item priceExtended] copy];

    price=[Tools amountCurrencyFormat:price];
    return price;
}
-(NSString*) getQuantityTicket:(FindItemModel*) item
{
    NSMutableString *qtyMessage=[[[NSMutableString alloc] init]autorelease];
    float qty=[item.itemCount floatValue];
    if (qty!=1) {
        [qtyMessage appendFormat:@"%@*%@",[item price],[item itemCount]];
    }
    DLog(@"getQuantityTicket %@",qtyMessage);

    return  qtyMessage;
}



-(NSString*) getSaleTypeHeader
{
    switch ([Session getSaleType]) {
        case NORMAL_CLIENT_TYPE:
        case SOMS_CLIENT_TYPE:
            return @"VENTA";
            break;
        //-----------------------
        case FOOD_CLIENT_TYPE:
            return @"ALIMENTOS";
            break;
        //-----------------------
        case SOMS_EMPLOYEE_TYPE:
        case NORMAL_EMPLOYEE_TYPE:
            return @"VENTA CASA";
        //-----------------------
            break;
        case REFUND_NORMAL_EMPLOYEE_TYPE:
        case REFUND_NORMAL_TYPE:
        case REFUND_SOMS_EMPLOYEE_TYPE:
        case REFUND_SOMS_TYPE:

            return @"DEVOLUCION";
        //-----------------------
            break;
        case DULCERIA_CLIENT_TYPE:



            return @"DULCERIA";
            //-----------------------
            break;
        default:
            return @"VENTA";
            break;
    }
}
//this methods return the date/description of the item
//the output result depends on the SOMS Type
//output example: "Cliente avisa", "a su arribo", "20122005"
-(NSString*)getItemDeliveryDate:(NSString*) somsDate
{
    DLog(@"getItemDeliveryDate: %@",somsDate);
    if (SOMSDeliveryType==1||SOMSDeliveryType==3||SOMSDeliveryType==4||SOMSDeliveryType==5) {
        return somsDate;
    }
    else
        return @"";
}
//this methods return the REFUND data of the sale
//if the sale is not a REFUND sales returns a empty line
-(NSString*) getRefundDataInfo
{
    NSMutableString *refundString=[[[NSMutableString alloc] init]autorelease];
    SaleType saleType=[Session getSaleType];

    if (saleType==REFUND_NORMAL_TYPE||saleType==REFUND_SOMS_EMPLOYEE_TYPE||saleType==REFUND_SOMS_TYPE) {
        //Left aligment
        [refundString appendString:@"\x1b\x61\x00"];
        [refundString appendFormat:@"FECHA DE VENTA :\t    %@ \n",[Tools getDateFormatRefundTicket:[refundData saleDate]]];
        [refundString appendFormat:@"TERMINAL :\t    %@ \n",[refundData originalTerminal]];
        [refundString appendFormat:@"BOLETA :\t    %@ \n",[refundData originalDocto]];
        [refundString appendFormat:@"TIENDA ORIGINAL :\t    %@ \n",[refundData originalStore]];
        [refundString appendFormat:@"CAUSA DEVOLUCION :\t    %@ \n",[refundData refundReason]];
        [refundString appendFormat:@"VENDEDOR ORIGINAL :\t    %@ \n\n",[refundData originalSeller]];
        
        return refundString;
    }
    else
        return @"";
}

//this methods return the warning message for the refund sale
//if the sale is not a REFUND sales returns a empty line
-(NSString*) getRefundDataWarning
{
    NSMutableString *refundString=[[[NSMutableString alloc] init]autorelease];
    SaleType saleType=[Session getSaleType];

    if (saleType==REFUND_NORMAL_TYPE||saleType==REFUND_SOMS_EMPLOYEE_TYPE||saleType==REFUND_SOMS_TYPE||saleType==REFUND_NORMAL_EMPLOYEE_TYPE) {
        //Center aligment
        [refundString appendString:@"\x1b\x61\x01"];
        //Bold Text ON
        [refundString appendString:@"\x1b\x45\x01"];
        [refundString appendString:@"*ESTE DOCTO NO ES VALIDO PARA COMPRAS* \n\n"];
        //Bold Text OFF
        [refundString appendString:@"\x1b\x45\x00"];
       
        return refundString;
    }
    else
        return @"";
}

//this methods return the user agreements of the SOMS sale
//if the sale is not a SOMS sales returns a empty line
-(NSString*) getSOMSAgreements
{
    NSMutableString *somsTerms=[[[NSMutableString alloc] init]autorelease];
    switch ([Session getSaleType]) {
        case SOMS_EMPLOYEE_TYPE:
        case SOMS_CLIENT_TYPE:
            if (SOMSDeliveryType==2) {
                [somsTerms appendString:@"Todos los articulos seran entregados\n"];
                [somsTerms appendFormat:@"El dia: %@ \n",[Tools getDateFromString:somsOrderDeliveryDate]];
                
            }else if (SOMSDeliveryType==4)
            {
                [somsTerms appendString:@"**************************************\n"];
                [somsTerms appendString:@"En esta fecha hago pedido del producto\n"];
                [somsTerms appendString:@"especificado en este mismo documento el cual se\n"];
                [somsTerms appendString:@"me informo que esta agotado por el momento y\n"];
                [somsTerms appendFormat:@"acepto entrar en fila de espera con el no.%@,\n",somsDeliveryNumber];
                [somsTerms appendString:@"con tiempo aproximado de ___ dias.\n"];
                [somsTerms appendString:@"recibi copia del presente.\n"];
                [somsTerms appendString:@"\n"];

            }
        
            [somsTerms appendString:@"*******************************************\n"];
            [somsTerms appendString:@"EL CLIENTE ACEPTA INICIAR LOS PAGOS DE\n"];
            [somsTerms appendString:@"LA MERCANCIA ADQUIRIDA INDEPENDIENTEMENTE\n"];
            [somsTerms appendString:@"DE LA FECHA DE ENTREGA\n"];
            [somsTerms appendString:@"*******************************************\n"];
            //Bold Text ON
            [somsTerms appendString:@"\x1b\x45\x01"];
            [somsTerms appendString:@"Gracias Por Su Visita !\n\n"];
            //Bold Text OFF
            [somsTerms appendString:@"\x1b\x45\x00"];
            [somsTerms appendString:@"*******************************************\n"];
            [somsTerms appendString:@"ESTE DOCUMENTO NO AMPARA LA SALIDA\n"];
            [somsTerms appendString:@"DE MERCANCIA DEL ALMACEN\n"];
            [somsTerms appendString:@"*******************************************\n\n"];

            return somsTerms;
            break;
        default:
            return @"";
            break;
    }
}
//this methods returns the corresponding line of the soms/comanda sale for printing, if the sale doesn't have
//a order returns an empty line
//output example: NO. ORDEN DE VENTA: 980011100
-(NSString*) getOrderNumber
{
    NSMutableString *orderMessage=[[[NSMutableString alloc] init]autorelease];
    switch ([Session getSaleType]) {
        case SOMS_EMPLOYEE_TYPE:
        case SOMS_CLIENT_TYPE:
            [orderMessage appendString:@"NO. ORDEN DE VENTA: "];
            [orderMessage appendFormat:@"%@\n\n",[Session getSomsOrder]];
            return orderMessage;
            break;
            //-----------------------
        case FOOD_CLIENT_TYPE:
        {
            NSString * comanda=[[Session getComandaOrder]copy];
            comanda=[Tools trimComandaNumber:comanda];
            [orderMessage appendString:@"NUMERO DE COMANDA: "];
            [orderMessage appendFormat:@"%@\n\n",comanda];
            return orderMessage;
        }
            break;
            //-----------------------
        case NORMAL_EMPLOYEE_TYPE:
        case NORMAL_CLIENT_TYPE:
            //-----------------------
            return @"";
            break;
        default:
            return @"";
            break;
    }

}
-(NSString*) generateDate
{
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEE d/MMM/yyyy HH:mm"];
	date = [[NSDate alloc] init];
	NSString *dateString = [dateFormat stringFromDate:date];
	dateString=[dateString uppercaseString];
	[dateFormat release];
	//[dateFormat setDateFormat:@"d/MM"];
	//expireDate = [dateFormat stringFromDate:date]; 	
	
	NSData *stringData = [dateString dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
	
	NSString *dateStr = [[[NSString alloc] initWithData: stringData encoding: NSASCIIStringEncoding] autorelease];
	return dateStr;
}
-(NSString*) generateTextualAmountDescription:(float) amount
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle: NSNumberFormatterSpellOutStyle];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"]autorelease];
	[formatter setLocale:locale]; // Set locale if you want to use something other then the current one
	NSString* numberString = [formatter stringFromNumber:[NSNumber numberWithInt: amount]];
	numberString=[numberString uppercaseString];
    
    double y = floor (amount);    
    double decimals = amount - y;
    decimals*=100;
    
	//numberString=[numberString stringByAppendingString:@" PESOS M.N."];
    numberString=[numberString stringByAppendingFormat:@" PESOS %02.0f/100  M.N.",decimals];

	[formatter release];
    numberString=[self stringWithoutAccentsFromString:numberString];
	return numberString;
}

//Remove accents from the string
-(NSString*)stringWithoutAccentsFromString:(NSString*)s
{
    if (!s) return nil;
    NSMutableString *result = [NSMutableString stringWithString:s];
    CFStringFold((CFMutableStringRef)result, kCFCompareDiacriticInsensitive, NULL);
    return result;
}
-(NSString*) generateTicketCodeBar
{
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyMMdd"];
	NSMutableString *ticketCodeBar = [NSMutableString stringWithString:[dateFormat stringFromDate:date]];
	[dateFormat release];
	DLog(@"1: %@",ticketCodeBar);
	
	
	NSString* idStore=[Session getIdStore];
	float floatIdStore=[idStore floatValue];
	
	NSString* terminal=[Session getTerminal];
	float floatTerminal=[terminal floatValue];
	
	NSString* docto=[Session getDocTo];
	float floatDocto=[docto floatValue];
	
	NSString* userName=[Session getUserName];
	float floatUserName=[userName floatValue];
	
	[ticketCodeBar appendFormat:@"%03.0f",floatIdStore];
	[ticketCodeBar appendFormat:@"%03.0f",floatTerminal];
	[ticketCodeBar appendFormat:@"%04.0f",floatDocto];
	//[ticketCodeBar appendString:@"0666"];
	//[ticketCodeBar appendString:@"10793777"];
	[ticketCodeBar appendFormat:@"%08.0f",floatUserName];
	DLog(@"CODEBAR FINAL: %@",ticketCodeBar);

	[date release];
	return ticketCodeBar;
	
}
-(NSString*) generateItemBarcodeWithZeros:(NSString*) codebar
{
//    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
//    [numberFormatter setPaddingCharacter:@"0"];
//    [numberFormatter setMinimumIntegerDigits:10];
    NSNumber *number = [NSNumber numberWithInt:[codebar intValue]];
    
   // double codebarf=[codebar doubleValue];
    codebar=[NSString stringWithFormat:@"%010d",[number intValue]];
    //codebar=[codebar stringby:10 withString:@"0" startingAtIndex:0];
   // codebar=[number stringValue];
    [codebar retain];
    DLog(@"generateItemBarcodeWithZeros: %@",codebar);
    return codebar;
}
-(NSString*) generateTicketGiftCodeBar:(FindItemModel*) item :(float) discount
{
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	//[dateFormat setDateFormat:@"ddMMyy"];
    [dateFormat setDateFormat:@"yyMMdd"];

    NSString *ds=[dateFormat stringFromDate:date];

	NSMutableString *ticketCodeBar = [NSMutableString stringWithString:ds];
	[dateFormat release];
	DLog(@"1: %@",ticketCodeBar);
	
	
	NSString* idStore=[Session getIdStore];
	float floatIdStore=[idStore floatValue];
	
	NSString* terminal=[Session getTerminal];
	float floatTerminal=[terminal floatValue];
	
	NSString* docto=[Session getDocTo];
	float floatDocto=[docto floatValue];
	
	NSString* userName=[Session getUserName];
	float floatUserName=[userName floatValue];
	
    NSString* sku=[item barCode];
    int floatSKU=[sku intValue];
    DLog(@"floatsku:%010i",floatSKU);

    NSString* finalPrice=[item price];
    float floatFinalPrice=[finalPrice floatValue];
    floatFinalPrice-=discount;
    floatFinalPrice*=100;
    DLog(@"finalprice:%010.0f",floatFinalPrice);

	[ticketCodeBar appendFormat:@"%03.0f",floatIdStore];
	[ticketCodeBar appendFormat:@"%03.0f",floatTerminal];
	[ticketCodeBar appendFormat:@"%04.0f",floatDocto];
	[ticketCodeBar appendFormat:@"%08.0f",floatUserName];
    [ticketCodeBar appendFormat:@"%010i",floatSKU];
    [ticketCodeBar appendFormat:@"%010.0f",floatFinalPrice];

	DLog(@"CODEBAR FINAL: %@",ticketCodeBar);
    
	[date release];
	return ticketCodeBar;
	
}

-(NSString*) getAuthorizationNumber:(Card*) cardData
{
	DLog(@"getAuthorizationNumber : %@",[cardData authNumber]);
    NSString *authLine;

    DLog(@"getEmployeeAccount:%@. - cardData authNumber:%@.",[Session getEmployeeAccount],[cardData authNumber]);
    if ([[Session getUserName]isEqualToString:[cardData authNumber]]) {
        authLine=@"D@1\t AUTORIZ POR LIMITE  ";
    }
    else{
        authLine=@"D@1\t AUTORIZACION  ";

    }
    
	if ([[cardData authNumber]length]>0) 
	{
		authLine=[authLine stringByAppendingString:[cardData authNumber]];
		return authLine;
	}
	else
		return @"";
}
/*
-(void)WriteToPrinter:(NSString*) stringToPrint
{
	// NOTE: comment this method to avoid compiling errors in SIMULATION MODE
	DLog(@"TAMAÑO DE LA IMPRESION: %i",stringToPrint);
	if (![Tools validatePrinterConfig]) 
		return;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	NSData* myEncodedObject = [defaults objectForKey:@"programIPAddres"];
	NSString* ipAddress = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	DLog(@"ipAddress: %@", ipAddress);
	
	myEncodedObject = [defaults objectForKey:@"programPortSettings"];
	NSString* portSettings = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
	DLog(@"portSettings: %@", portSettings);
	
	//stringToPrint = [NSString stringWithUTF8String:[stringToPrint cStringUsingEncoding:NSASCIIStringEncoding]];
	//stringToPrint = [NSString stringWithUTF8String:stringToPrint];
	DLog(@"string: %@", stringToPrint);
	
	int dataSize = [stringToPrint length] + 1 + C_LineFeedx6_Size + C_AutoCutterFullCut_Size;
	NSMutableData *dataToPrint = [NSMutableData dataWithCapacity:dataSize];
	
	[dataToPrint appendBytes:[stringToPrint UTF8String] length:[stringToPrint length]];
	
	if([portSettings isEqualToString:@"mini"])
	{
		[dataToPrint appendBytes:"\n" length:1];
		[dataToPrint appendBytes:C_LineFeedx6 length:C_LineFeedx6_Size];
		[dataToPrint appendBytes:C_AutoCutterFullCut length:C_AutoCutterFullCut_Size];
	}
	
	NSString * portName = @"TCP:";
	portName = [portName stringByAppendingString:ipAddress];
	
	Port * iOPort = [Port getPort:portName :portSettings :4000];
	if(iOPort == NULL)
	{
		[Tools displayAlert:@"Error de Impresora" message:@"Open port error"];
	}
	else
	{
		@try {
			int totalAmountWritten = 0;
			while(totalAmountWritten < [dataToPrint length])
			{
				totalAmountWritten += [iOPort writePort:[dataToPrint mutableBytes] :totalAmountWritten :[dataToPrint length] - totalAmountWritten];
			}
		}
		@catch (PortException * e) {
			[Tools displayAlert:@"Error de Impresora" message:@"Write error"];
		}
		@finally {
			[Port releasePort:iOPort];
		}
	}
	[pool release];
	
}*/

    /*
-(BOOL)GetOnlineStatus
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSData* myEncodedObject = [defaults objectForKey:@"programIPAddres"];
	NSString* ipAddress = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	
	myEncodedObject = [defaults objectForKey:@"programPortSettings"];
	NSString* portSettings = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	
	if ([ipAddress length]==0) 
		ipAddress=@"";
	
	if ([portSettings length]==0) 
		portSettings=@"";
	
	NSString * portName = @"TCP:";
	portName = [portName stringByAppendingString:ipAddress];
	
	Port * iOPort = [Port getPort:portName :portSettings :4000];
	
	if(iOPort == NULL)
	{
		[Tools displayAlert:@"Error de Impresora" message:@"Error en la configuracion del Puerto o impresora Apagada"];
		return NO;
	}
	else 
	{
		@try {
			if([iOPort getOnlineStatus] == SM_TRUE)
			{
				
				return YES;
			}
			else
			{
				[Tools displayAlert:@"La impresora no tiene papel" message:@""];
				return FALSE;
			}
		}
		@catch (PortException * e) {			
			[Tools displayAlert:@"Ocurrio un Error de Comunicacion Con la impresora" message:@""];
			return FALSE;
		}
		@finally {
			[Port releasePort:iOPort];
		}
	}
	[pool release];
	//[Tools stopActivityIndicator];

}*/

-(void) setPaymentType:(int) type
{
	switch (type) {
		case 0:
			pType=creditType;
			break;
		case 1:
			pType=LPCType;
			break;
		case 2:
			pType=dilisaType;
			break;
		case 3:
			pType=monederoType;
			break;
        case 4:
            pType=cashType;
		default:
			break;
	}
}
-(NSString*) getCardNumberMaskFormat:(NSString*) aCardNumber
{
	if (pType==monederoType) 
		return [Tools maskMonederoNumber:aCardNumber];
	else
		return [Tools maskCreditCardNumber:aCardNumber];
}
-(NSString*) getPaymentType:(Card*) aCard
{
	switch (pType) {
		case creditType:
			return [aCard bank];
            //return [@"TARJETA "stringByAppendingString:[Session getBank]];
			//return [@"CREDITO "];
			break;
		case LPCType:
			return @"PREMIUM CARD";
			break;
		case dilisaType:
			return @"DILISA";
			break;
		case monederoType:
			return @"MONEDERO";
			break;
        case cashType:
            return @"CONTADO";
            break;
		default:
			return @"";
			break;
	}
}


- (BOOL)checkPrinterStatus {
    BOOL canPrint=NO;
    @try {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        NSData* myEncodedObject = [defaults objectForKey:@"programIPAddres"];
        NSString* portName = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        DLog(@"ipAddress: %@", portName);
        
        myEncodedObject = [defaults objectForKey:@"programPortSettings"];
        NSString* portSettings = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
        DLog(@"portSettings: %@", portSettings);

        SMPort *starPort = nil;
        

        starPort = [SMPort getPort:portName :portSettings :2000];
        
        
        StarPrinterStatus_2 status;
        [starPort getParsedStatus:&status :2];
        
        NSString *statusMessage = @"";
        if (status.offline == SM_TRUE)
        {
            statusMessage = @"The printer is offline";
            if (status.coverOpen == SM_TRUE)
            {
                statusMessage = [statusMessage stringByAppendingString:@"\nCover is Open"];
            }
            else if (status.receiptPaperEmpty == SM_TRUE)
            {
                statusMessage = [statusMessage stringByAppendingString:@"\nOut of Paper"];
            }
            
        }
        else
        {
            statusMessage = @"The Printer is online";
            canPrint=YES;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Printer Status"
                                                        message:statusMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return canPrint;
    }
    @catch (PortException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Printer Error"
                                                        message:@"Get status failed"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    return canPrint;
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(IBAction) removeTicketTestView
{
	//[self.view  removeFromSuperview];
	//[self release];
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

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

#pragma mark - Extended Warranty Ticket

-(void)printExtendedWarrantyTicket
{
    NSMutableString *header=[[[NSMutableString alloc] init] autorelease];
    
    //tab settings
    //[header appendString:@"\x1b\x44\x06\x16\x26\x36\x46\x56\x66\x76\x00"];
    
    //LOGO
    //Center aligment
    
    [header appendString:@"\x1b\x61\x01"];
    
    //HEX	1B 66 00 0C
    [header appendString:@"\t\x1b\x66\x00\x0c\n\n"];

    NSMutableString *subHeader=[[[NSMutableString alloc] init] autorelease];
    //Center aligment
    [subHeader appendString:@"\x1b\x61\x01"];
    [subHeader appendString:[Session getStoreAddress]];
    [subHeader appendString:@"\n\n\n"];
    [subHeader appendString:@"PROGRAMA DE GARANTIA EXTENDIDA"];
    [subHeader appendString:@"\n\n\n"];
    NSMutableString *saleData = [[[NSMutableString alloc] init] autorelease];

    [saleData appendString:@"    TERM        DOCTO       TDA       VEND\n"];
    [saleData appendFormat:@"    %@         %@        %@       %@\n\n",[Session getTerminal],[Session getDocTo],[Session getIdStore],[Session getUserName]];
    //Left aligment
    [saleData appendString:@"\x1b\x61\x00"];
    [saleData appendFormat:@"ATENDIO: %@\n \n",[Session getUName]];
    
    [saleData appendString:@"\x1b\x45\x01"]; //Bold Text ON
    [saleData appendFormat:@"REFERENCIA: %@\n\n\n",[Session getReferenceWarranty]];
    [saleData appendString:@"\x1b\x45\x00"]; //Bold Text Off
    
    float total=0;
    float totalDiscounts=0;
    float totalAbonoMonedero=0;
    NSString *monthlyPaymentMessage=@"";
    NSString *installmentSelected=@"";
    NSMutableString *products=[[[NSMutableString alloc] init] autorelease];

    for (FindItemModel *item in productList) {
        
        [Tools calculateSuccesiveDiscounts:item];
        
        //backup lines no muestran cantidad
        //[products appendFormat:@"%@\t         SECC %@\n ",item.description,item.department];
        //[products appendFormat:@"%@         %@\n ",[self generateItemBarcodeWithZeros:item.barCode],[self getExtendedPrice:item]];
        
        [products appendFormat:@"%@                 SECC %@\n ",item.description,item.department];
        [products appendFormat:@"%@       %@          %@\n ",[self generateItemBarcodeWithZeros:item.barCode],[self getQuantityTicket:item],[self getExtendedPrice:item]];
        
        if (item.warranty.warrantyId != NULL) {

            [products appendFormat:@"%@                 SECC %@\n ",item.warranty.detail,item.warranty.department];
            [products appendFormat:@"%@       %@          %@\n ",[item.warranty.sku substringFromIndex:8],[NSNumber numberWithInt:1],item.warranty.cost];
        }
        
        float baseAmount=0;
        for (Promotions *promo in item.discounts) {
            
            //if the promotion is payment plan print the format . else print the format of percentage discount
            if ([promo.promoInstallment length]>0||promo.promoType==1)  //print promotion installmetn
            {
                DLog(@"promoValue----%@ %@",[promo promoValue],[promo promoDiscountPercent]);
                DLog(@"promoBaseAmount ---%@",[promo promoBaseAmount]);
                //                [products appendFormat:@"     %@ %@ \n",[Tools calculateDiscountValuePercentage:[promo promoBaseAmount] :promo.promoDiscountPercent] ,[promo promoDescription]];
                //                    totalAbonoMonedero+=[[Tools calculateDiscountValuePercentage:[promo promoBaseAmount] :promo.promoDiscountPercent] floatValue];
                
                baseAmount=[[item priceExtended]floatValue]-baseAmount;
                DLog(@"BASE AMOUNT Rest %f",baseAmount);
                
                NSString *baseAmountS=[NSString stringWithFormat:@"%.02f",baseAmount];
                //[products appendFormat:@"     %@ %@ \n",[Tools calculateDiscountValuePercentage:baseAmountS :promo.promoDiscountPercent] ,[promo promoDescription]];
                [products appendFormat:@"     %@ MONEDERO %%%@ \n",[Tools calculateDiscountValuePercentage:baseAmountS :promo.promoDiscountPercent] ,[promo promoDiscountPercent]];
                
                totalAbonoMonedero+=[[Tools calculateDiscountValuePercentage:baseAmountS :promo.promoDiscountPercent] floatValue];
                
            }
            else
            {	if (promo.promoType==3) //print promotion by key with %
            {
                //promo.promoValue=[Tools calculateDiscountValuePercentage:[item price]:[promo promoDiscountPercent]];
                
                [products appendFormat:@"     %@ %@%%      %@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoValue]]];
                totalDiscounts+=[promo.promoValue floatValue];
                baseAmount+=[[promo promoValue]floatValue];
                DLog(@"BASE AMOUNT %f",baseAmount);
                
                
            }
            else if(promo.promoType==4) //print promotion by key with fixed amount
            {
                [products appendFormat:@"     %@ $%@      %@- \n",[promo promoDescription],[promo promoDiscountPercent],[Tools amountCurrencyFormat:[promo promoDiscountPercent]]];
                totalDiscounts+=[promo.promoDiscountPercent floatValue];
                baseAmount+=[[promo promoDiscountPercent]floatValue];
                DLog(@"BASE AMOUNT %f",baseAmount);
                
                
            }else //if([promo.promoTypeBenefit isEqualToString:@"PaymentPlanBenefit"])
            {
                //installmentSelected=[promo.promoInstallmentSelected copy];
                //DLog(@"promoinstallment selected ticket:%@",promo.promoInstallmentSelected);
                //[products appendFormat:@"\t%@ %@ \n",installmentSelected,[promo promoDescription]];
                //[products appendFormat:@"\t %@ \n",[promo promoDescription]];
                for (Card* cards in cardArray) {
                    DLog(@"TICKETPRING planid @@@@ %@",[cards planId]);
                    if( [[cards planId]length]>=1) //patch 1.4.5 rev1
                    {
                        installmentSelected=[cards.planInstallment copy];
                        //DLog(@"promoinstallment selected ticket:%@",promo.promoInstallmentSelected);
                        //[products appendFormat:@"     %@ %@ \n",installmentSelected,[cards planDescription]];
                        [products appendString:[self getInstallmentsText:cards]];
                        //[products appendFormat:@"\t %@ \n",[promo promoDescription]];
                        [installmentSelected release];
                    }
                }
                
                
            }
            }
        }
        //soms deliveryDate
        [products appendString:[self getItemDeliveryDate:[item deliveryDate]]];
        
        
        [products appendString:@"\n"];
        
        total+=[item.priceExtended floatValue];
    }
    NSMutableString *footer = [[[NSMutableString alloc] init] autorelease];
    //Left aligment
    [footer appendString:@"\x1b\x61\x00"];
    [footer appendString:@"\n \n \n"];
    [footer appendString:[NSString stringWithFormat:@"VENTA DE COMPRA GTIA.  %@",[self generateDate]]];
    [footer appendString:@"\n\n\n"];
    
    //////////////////////put the ticke in the printer QUEUE/////////////////////////////////////
    NSString *ticketString=[[NSString alloc] init];
    ticketString = [ticketString stringByAppendingString:header];
    ticketString=[ticketString stringByAppendingString:subHeader];
    ticketString=[ticketString stringByAppendingString:saleData];
    ticketString=[ticketString stringByAppendingString:products];
    ticketString=[ticketString stringByAppendingString:footer];
    [PrinterQueue addPrintToQueue:ticketString];
}


- (void)dealloc {
	//productList =nil;
    [RFCCode release];
    [somsOrderDeliveryDate release];
    //[somsDeliveryNumber release];
	[txtAProducts release];
    [super dealloc];
}

@end
