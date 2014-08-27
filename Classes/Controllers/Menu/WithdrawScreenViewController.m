//
//  WithdrawScreenViewController.m
//  CardReader
//
//  Created by Jonathan Esquer on 20/09/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "WithdrawScreenViewController.h"
#import "CustomCell.h"
@interface WithdrawScreenViewController ()

@end

@implementation WithdrawScreenViewController
@synthesize txtAmount;
@synthesize txtQuantity;
@synthesize btnWithdraw;
@synthesize btnAddAmount;
@synthesize numberKeyPad;
@synthesize btnExit;
@synthesize pckDraws;
@synthesize lblWithdrawAlert;
@synthesize scrollView;
@synthesize contentView;
@synthesize aTableView;
@synthesize btnTableExit;
@synthesize btnViewTable;
@synthesize btnViewTableBack;

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
    // Do any additional setup after loading the view from its nib.

    [self.view addSubview:self.contentView];
    ((UIScrollView *)self.view).contentSize = self.contentView.frame.size;
    UIScrollView *scroll=(UIScrollView*)self.view;
    scroll.delegate=self;
    [contentView release];
    
    //[Styles bgGradientColorPurple:contentView];
    [Styles purpleButtonStyle:btnAddAmount];
    [Styles purpleButtonStyle:btnExit];
    [Styles purpleButtonStyle:btnTableExit];
    [Styles purpleButtonStyle:btnWithdraw];
    [Styles purpleButtonStyle:btnViewTable];
    [Styles purpleButtonStyle:btnViewTableBack];


    drawList=[[WithdrawDataList alloc] init];
    amountList=[[NSArray alloc]initWithObjects:
                @"0.10",@"0.20",@"0.50",@"1.00",@"2.00",@"5.00",
                @"10.00",@"20.00",@"50.00",@"100.00",
                @"200.00",@"500.00",@"1000.00",nil];
    quantityList=[[NSArray alloc]initWithObjects:@"1",
                  @"2",
                  @"3",
                  @"4",
                  @"5",
                  @"6",
                  @"7",
                  @"8",
                  @"9",
                  @"10",
                  @"11",
                  @"12",
                  @"13",
                  @"14",
                  @"15",
                  @"16",
                  @"17",
                  @"18",
                  @"19",
                  @"20",
                  @"21",
                  @"22",
                  @"23",
                  @"24",
                  @"25",
                  @"26",
                  @"27",
                  @"28",
                  @"29",
                  @"30",
                  @"31",
                  @"32",
                  @"33",
                  @"34",
                  @"35",
                  @"36",
                  @"37",
                  @"38",
                  @"39",
                  @"40",
                  @"41",
                  @"42",
                  @"43",
                  @"44",
                  @"45",
                  @"46",
                  @"47",
                  @"48",
                  @"49",
                  @"50",nil];
    strQuantity=@"1";
    strAmount=@"0.10";
    
    //run the first request to check if there is a withdraw
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startWithdrawTransactionRequest:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addWithdrawToList:(id)sender {
 
    //DLog(@"withdrawList %@",[drawList withdrawList]);
    
    [drawList addWithdrawToList:strAmount:strQuantity];
    [self showWithdrawAlert];
    [aTableView reloadData];
 
}
-(void) showWithdrawAlert
{
    NSString *amount=[Tools amountCurrencyFormat:strAmount];
    [lblWithdrawAlert setText:[NSString stringWithFormat:@"%@ x %@ Retiro Agregado",amount,strQuantity]];
    
    [UIView animateWithDuration:0.5f
                          delay:0.2f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //lblWithdrawAlert.center = CGPointMake(381, 410);
                         lblWithdrawAlert.alpha = 1.0;
                     }
                     completion:^(BOOL fin) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.2f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              //lblWithdrawAlert.center = CGPointMake(381, 410);
                                              lblWithdrawAlert.alpha = 0.0;
                                          }
                                          completion:^(BOOL fin) {
                                          }];
                     }];
}

- (IBAction)viewDrawList:(id)sender {

    UIScrollView *scroll=(UIScrollView*)self.view;

    CGFloat xOffset = scroll.contentOffset.x;
    CGFloat yOffset = scroll.contentOffset.y;
    
    DLog(@"xoffset:%f",xOffset);
    DLog(@"yoffset:%f",yOffset);
    
    if (scroll.contentOffset.x != 0)
    {
        [scroll setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
    else
    {
        [scroll setContentOffset:CGPointMake(320, yOffset) animated:YES];
 
    }
    DLog(@"%@",scroll);
    DLog(@"%@",self.view);
}
#pragma mark -
#pragma mark REQUEST HANDLERS

- (IBAction)startRequest:(id)sender {
    if ([[drawList getWithdrawList]count]==0) {
        [Tools displayAlert:@"Error" message:@"No existen retiros"];
        return;
    }
    
    [self startWithdrawTransactionRequest:NO];
}
-(void) startWithdrawTransactionRequest:(BOOL) cancelFlag
{
	[Tools startActivityIndicator:self.view];
    
	LiverPoolRequest *liverpoolRequest=[[LiverPoolRequest alloc] init];
    liverpoolRequest.delegate=self;
    
	//seller object
    Seller *seller=[[Seller alloc] init];
    seller.password=[Session getPassword];
    seller.userName=[Session getUserName];
    
    //Type of Sale
    NSString *type=[self selectWithdrawType];
  
    //Tender Type Cash
    NSString *tender=@"1";
    NSArray *pars;

    for (WithdrawData *data in [drawList withdrawList]) {
        DLog(@"Amount:%@ QTY:%@ ",[data amount],[data quantity]);
    }
    if ([[drawList withdrawList]count]==0) {
        [drawList addWithdrawToList:@"1" :@"1"];
    }
    NSString *flag=(cancelFlag)?@"true":@"false";
    
    pars=[NSArray arrayWithObjects:drawList,tender,seller,flag,nil];
    [liverpoolRequest sendRequest:type forParameters:pars forRequestType:withdraw_Request];
    
    [liverpoolRequest release];
    [seller release];
  
    //falta agregar el pago
}


-(NSString*) selectWithdrawType
{
    SaleType sType=[Session getSaleType];
    NSString *type=@"";
    if (sType==WITHDRAW_CASH_ACTION_TYPE)
        type=@"retiroEfectivo";
    return type;
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	if (requestType==withdraw_Request)
		[self withdrawRequestParsing:receivedData];
	
}
-(void) withdrawRequestParsing:(NSData*) data
{
    [Tools stopActivityIndicator];
	PaymentParser *payParser=[[PaymentParser alloc] init];
	[payParser startParser:data];
	DLog(@"RESULTADO DE RETIRO %@", [payParser getMessageResponse]);
    DLog(@"RESULTADO DE RETIRO %@", payParser.payment.totalAmountWithdrawn);

	//if the transaction was succesful.
	if ([payParser getStateOfMessage]) {
		
        //pending message means the transaction was only called to check if there is a pending withdraw.
        if ([[payParser getMessageResponse]isEqualToString:@"PENDING" ]) {
                [[drawList withdrawList] removeAllObjects];
            return;
        }
        
        [Session setDocTo:payParser.payment.docto];
        [drawList setTotalAmountWithdrawn:[payParser.payment.totalAmountWithdrawn copy]];
        [self printTicket];
        
        //set the total parsed in the drawlist
        
        //when the close is done but the printer is not ready, the button print ticket will become active
        [btnWithdraw removeTarget:nil
                     action:NULL
           forControlEvents:UIControlEventAllEvents];
        
        [btnWithdraw addTarget:self
                        action:@selector(printTicket)
              forControlEvents:UIControlEventTouchUpInside];
        [btnWithdraw setTitle:@"Imprimir" forState:UIControlStateNormal];
        
	}
	else
	{
        NSString *message=[Tools getShortErrorMessage:[payParser getMessageResponse]];
		[Tools displayAlert:@"Error" message:message];
        

        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];

	}
	
	[payParser release];
}

//ERROR DE TOTALAMOUNTWITHDRAWN RELEASE
-(IBAction) printTicket
{
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [Tools startActivityIndicator:self.view];
        [btnAddAmount setHidden:YES];

        DLog(@"apunto de imprimir %@ ,%@",[drawList getWithdrawList],drawList.totalAmountWithdrawn);
        TicketGeneratorViewController *tk=[[TicketGeneratorViewController alloc]init];
        [tk printWithdrawalTicket:drawList];
        DLog(@"antes de cancelar Data");
        [tk release];
}

- (IBAction)exitAction:(id)sender {
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removewithdrawScreen];

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
    
    
   // if (![textField isEqual:txtField1]) {
		/*
		 Show the numberKeyPad
		 */
		if (!self.numberKeyPad) {
			self.numberKeyPad = [NumberKeypadDecimalPoint keypadForTextField:textField];
		}else {
			//if we go from one field to another - just change the textfield, don't reanimate the decimal point button
			self.numberKeyPad.currentTextField = textField;
		}
	//}
    
	
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


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //amount column
    if (component==0) {
         strAmount=[amountList objectAtIndex:row];
    }else
        strQuantity=[quantityList objectAtIndex:row];
    
    DLog(@"Selected value: %@/%@",strAmount,strQuantity);
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //DLog(@"numberOfRowsInComponent %@",amountList);
    if (component==0) 
        return [amountList count];
    else
        return [quantityList count];

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;//Or return whatever as you intend
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //amount column
    if (component==0) {
        return [amountList objectAtIndex:row];
    }else
        return [quantityList objectAtIndex:row];
}
- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return 0;
}

//----------------------------------------
//            TABLE VIEW MANAGEMENT
//----------------------------------------
#pragma mark -
#pragma mark TABLE VIEW MANAGEMENT

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *simpleTableIdentifier = @"Cell";
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    WithdrawData *data=[[drawList getWithdrawList] objectAtIndex:indexPath.row];
    
    [[cell lblAmount]setText:[data amount]];
    [[cell lblQuantity]setText:[data quantity]];
    [[cell lblTotal]setText:[Tools calculateMultiplyValueAmount:[data amount] :[data quantity]]];

    DLog(@"adding row to table");
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    DLog(@"rows in section");
	return [[drawList getWithdrawList] count];
}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[self editItemForTransaction:indexPath];
	}
	
}

-(void)tableView:(UITableView *)tableView
willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	//[self turnOnEditing];
}

-(BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

-(NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NSLocalizedString(@"¿Borrar?", @"Erase confirmation");
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		  editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    float total=0;
	for (WithdrawData *data in [drawList withdrawList]) {
     
     NSString *preTotal=[Tools calculateMultiplyValueAmount:[data amount] :[data quantity]];
     total += [preTotal floatValue];
     
     }
	UILabel *lblTotal=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
	lblTotal.text=[Tools amountCurrencyFormat:[NSString stringWithFormat:@"%.02f",total]];
	lblTotal.text=[NSString stringWithFormat:@"Total: %@",lblTotal.text];
	lblTotal.backgroundColor=[UIColor clearColor];
	lblTotal.textColor=[UIColor blackColor];
    [lblTotal setTextAlignment:NSTextAlignmentCenter];
    
	
	UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)] autorelease];
	[footer setBackgroundColor:[UIColor whiteColor]];
	[footer addSubview:lblTotal];
	[lblTotal release];
	return footer;
	
}
-(void) editItemForTransaction:(NSIndexPath*) indexPath
{
    DLog(@"editItemForTransaction");
    [[drawList getWithdrawList] removeObjectAtIndex:indexPath.row];
    [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                    withRowAnimation:UITableViewRowAnimationFade];
                //[self turnOffEditing];
    [aTableView reloadData];
    
}


-(void) dealloc{
    DLog(@"withdraw dealloc");
    [drawList release];
    [amountList release];
    [quantityList release];
    [super dealloc];

}

@end
