//
//  CloseTerminalViewController.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "CloseTerminalViewController.h"
#import "Session.h"
#import "Styles.h"
#import "Tools.h"
#import "Seller.h"
#import "CloseTerminalData.h"
#import "CloseTerminalParser.h"
#import "TicketGeneratorViewController.h"
#import "CardReaderAppDelegate.h"
@implementation CloseTerminalViewController
@synthesize lblComp;
@synthesize lblRefund;
@synthesize lblDifference;
@synthesize lblDelivery; 
@synthesize btnCancel; 
@synthesize btnCloseTerminal;
@synthesize lblStore;
@synthesize lblTerminal;
@synthesize lblDate;
@synthesize lblPoints;
@synthesize lblPaperVoucher;

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
    
    [self startCloseTerminalRequest:@"false"];
    toPrint=NO;
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    [self startClock];
    [self refreshLabelData];
    
    [Styles bgGradientColorPurple:self.view];
	[Styles silverButtonStyle:btnCancel];
	[Styles silverButtonStyle:btnCloseTerminal];
}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) refreshLabelData{
	lblStore.text=[Session getStore];
	lblTerminal.text=[@"T #: "stringByAppendingString:[Session getTerminal]];
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
	dateTimer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
	
}
-(IBAction)closeTerminalRequest:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Presione OK para borrar y deshabilitar la terminal" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancelar",nil];
    [alert show];
    [alert release];

}
-(IBAction)cancel:(id)sender
{
    [dateTimer invalidate];
    //the timer retains the entire class, before closing the view it must be invalidated
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeCloseTerminalScreen];
    

}



//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS
-(void) startCloseTerminalRequest:(NSString*) cerrarTerm
{
	//*** find item request code ***/
    [Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;

	//seller object
    Seller *seller=[[Seller alloc] init];
    seller.password=[Session getPassword];
    seller.userName=[Session getUserName];

    //NSString *cerrarTerm=@"false";

    NSArray *pars=[NSArray arrayWithObjects:seller,cerrarTerm,nil];
	[liverPoolRequest sendRequest:@"cerrarTerminal" forParameters:pars forRequestType:closeTerminalRequest]; //cambiar a localized string
	[liverPoolRequest release];
}

-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
    [Tools stopActivityIndicator];

	CloseTerminalParser *closeParser=[[CloseTerminalParser alloc] init];
	DLog(@"antes de empezar");
	[closeParser startParser:receivedData];
	 closeData=[closeParser returnCloseData];	
    [closeData retain];
    [Session setDocTo:closeData.cierreDocto];
    
    if ([closeData isError]) {
        [Tools displayAlert:@"Error" message:[closeData message]];
    }
    else {
        //if the flag is marked as true, must print the ticket 
        if (toPrint) {
            [self printCloseTerminalTicket];
            [Tools restartVoucherNumber];

            //when the close is done but the printer is not ready, the button print ticket will become active
            [btnCloseTerminal removeTarget:nil 
                                    action:NULL 
                          forControlEvents:UIControlEventAllEvents];
            
            [btnCloseTerminal addTarget:self 
                                 action:@selector(printCloseTerminalTicket)
                       forControlEvents:UIControlEventTouchUpInside];
            
            [btnCloseTerminal setTitle:@"Imprimir" forState:UIControlStateNormal];
        }
        
        NSString *comp=[Tools amountCurrencyFormat:[closeData computador]];
        NSString *delivery=[Tools amountCurrencyFormat:[closeData entregado]];
        NSString *difference=[Tools amountCurrencyFormat:[closeData diferencia]];
        NSString *refund=[Tools amountCurrencyFormat:[closeData devolucion]];
        NSString *voucher=[Tools amountCurrencyFormat:[closeData valesPapel]];
        NSString *points=[Tools amountCurrencyFormat:[closeData puntosRifa]];

            lblComp.text= comp;
            lblDelivery.text= delivery;
            lblDifference.text= difference;
            lblRefund.text= refund;
            lblPaperVoucher.text=voucher;
            lblPoints.text=points;
        
    }
    //printData
    
    [closeParser release];
	
}
-(void) printCloseTerminalTicket
{
    [Tools startActivityIndicator:self.view];
    TicketGeneratorViewController *tk=[[TicketGeneratorViewController alloc]init];
    [tk printCloseDataTicket:closeData];
    
    [btnCancel setHidden:YES];
    [tk release];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for OK button
        [self startCloseTerminalRequest:@"true"];
        toPrint=YES;
    }
    if (buttonIndex == 1)
    {
        //code for NO button
    }
}
-(void) dealloc
{
    DLog(@"closeterminalview dealloc");
    [super dealloc];
    [closeData release];
    [lblPoints release];
    [lblPaperVoucher release];
    [lblStore release];
    [lblTerminal release];
    [lblDate release];
    [lblComp release];
    [lblRefund release];
    [lblDifference release];
    [lblDelivery release]; 
    [btnCancel release]; 
    [btnCloseTerminal release];
}
@end
