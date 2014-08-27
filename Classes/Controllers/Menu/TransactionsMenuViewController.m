//
//  TransactionsMenu.m
//  CardReader
//

#import "TransactionsMenuViewController.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
#import "EmployeeSaleViewController.h"
#import "Session.h"
#import "Tools.h"
@implementation TransactionsMenuViewController
@synthesize btnWithdrawCash;
@synthesize btnClientSale,btnEmployeeSale,/*btnBalance,*/btnQuerySKU,btnAirTime,btnBalance,btnCloseStore,btnCancelTicket;
@synthesize btnEmployeeRefund,btnClientRefund;
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
	
	[Styles bgGradientColorPurple:self.view];
	[Styles menuTransactionButtonStyle:btnClientSale];
	[Styles menuTransactionButtonStyle:btnAirTime];
	[Styles menuTransactionButtonStyle:btnEmployeeSale];
	[Styles menuTransactionButtonStyle:btnBalance];
	[Styles menuTransactionButtonStyle:btnQuerySKU];
    [Styles menuTransactionButtonStyle:btnCloseStore];
    [Styles menuTransactionButtonStyle:btnCancelTicket];
    [Styles menuTransactionButtonStyle:btnClientRefund];
    [Styles menuTransactionButtonStyle:btnEmployeeRefund];
    [Styles menuTransactionButtonStyle:btnWithdrawCash];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Volver" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
-(IBAction) clientSaleTransact
{
	[Session setIsEmployeeSale:NO];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) saleOptionScreen];
	
	[Session setEmployeeAccount:@""];
}
-(IBAction) refundTransact
{
	[Session setIsEmployeeSale:NO];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) saleOptionRefundScreen];
	
	[Session setEmployeeAccount:@""];
}

-(IBAction) refundEmployeeTransact
{
	[Session setIsEmployeeSale:YES];
    
	//[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) employeeSaleScreen];
	EmployeeSaleViewController *employeeView=[[EmployeeSaleViewController alloc] initWithNibName:@"EmployeeSaleViewController" bundle:nil];
	employeeView.title=@"Venta Empleado";
	//[self presentModalViewController:employeeView animated:YES];
    [self presentViewController:employeeView animated:YES completion:nil];
    
	[employeeView release];
}

-(IBAction) SKUQueryTransact
{
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) consultSKUScreen];

}
//-(IBAction) AirTimeTransact
//{
//	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) airTimeScreen];
//
//}
-(IBAction) BalanceQueryTransact
{
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) transactionBalanceScreen];
}
-(IBAction) EmployeeSale
{
	[Session setIsEmployeeSale:YES];

	//[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) employeeSaleScreen];
	EmployeeSaleViewController *employeeView=[[EmployeeSaleViewController alloc] initWithNibName:@"EmployeeSaleViewController" bundle:nil];
	employeeView.title=@"Venta Empleado";
	//[self presentModalViewController:employeeView animated:YES];
    [self presentViewController:employeeView animated:YES completion:nil];

	[employeeView release];
}
-(IBAction) logout
{
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];

}
-(IBAction) closeTerminal:(id)sender
{
    //[Tools restartVoucherNumber];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) closeTerminalScreen];

}
-(IBAction) cancelTicket:(id)sender
{
    //[Tools restartVoucherNumber];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) cancelTicketScreen];
    [Session setSaleType:CANCEL_TYPE];

    
}

-(IBAction) withDrawAction:(id)sender
{
    //[Tools restartVoucherNumber];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) withdrawScreen];
    [Session setSaleType:WITHDRAW_CASH_ACTION_TYPE];
    
    
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

- (void)dealloc {
    [btnCancelTicket release];
    [btnCloseStore release];
	[btnClientSale release];
	/*[btnEmployeeSale release];
	[btnBalance release];*/
	[btnQuerySKU release];
	[btnAirTime release];
	[btnBalance release];

    [super dealloc];
}


@end
