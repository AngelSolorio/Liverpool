//
//  SaleOptionsViewController.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 03/07/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "SaleOptionsViewController.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
#import "Session.h"
#import "Tools.h"
#import "LiverPoolRequest.h"

@interface SaleOptionsViewController()
@property (strong,nonatomic) GenericDialogViewController *somsDialog;
@end

@implementation SaleOptionsViewController

@synthesize btnNormal,btnMesaRegalo,btnSOMS,btnRestaurant,btnDulceria,isRefound;
@synthesize somsDialog = _somsDialog;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(GenericDialogViewController *)somsDialog
{
    if(!_somsDialog) _somsDialog = [[GenericDialogViewController alloc]initWithNibName:@"GenericDialogViewController" bundle:nil];
    return _somsDialog;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    [Styles bgGradientColorPurple:self.view];
	[Styles menuTransactionButtonStyle:btnMesaRegalo];
	[Styles menuTransactionButtonStyle:btnNormal];
	[Styles menuTransactionButtonStyle:btnSOMS];
    [Styles menuTransactionButtonStyle:btnRestaurant];
    [Styles menuTransactionButtonStyle:btnDulceria];

//	[Styles silverButtonStyle:btnBalance];
//	[Styles silverButtonStyle:btnQuerySKU];
//    [Styles silverButtonStyle:btnCloseStore];
    // Do any additional setup after loading the view from its nib.
    [self setLayout];
    dismissNavBar=YES;
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Volver" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

}
//- (void)viewDidUnload
//{
//        [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:dismissNavBar animated:NO];
    

}
-(void) dismissSelf
{
    [self.navigationController popViewControllerAnimated:YES];
    dismissNavBar=NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setLayout
{
    
    //if the sale is employee type disable the restaurant option
    if ([Session getIsEmployeeSale]){
        [btnRestaurant setHidden:YES];
        [btnDulceria setHidden:YES];
    }
//    //if the sale is client type enable the corresponding buttons
//    else
//    {
//        [btnRestaurant setHidden:NO];
//        
//    }
    if (isRefound) {
        [btnRestaurant setHidden:YES];
        
    }
    
}
-(IBAction) saleNormal
{

    //if the sale is refund type
    if (isRefound) {
        if ([Session getIsEmployeeSale])
            [Session setSaleType:REFUND_NORMAL_EMPLOYEE_TYPE];
        else
            [Session setSaleType:REFUND_NORMAL_TYPE];
        
       
        GenericDialogViewController *codebarView=[[GenericDialogViewController alloc]initWithNibName:@"GenericDialogViewController" bundle:nil];
        [self presentViewController:codebarView animated:YES completion:nil];
        [codebarView initView:@"Favor de leer el codigo de barras del ticket" :refundType :YES];
        [codebarView release];
        codebarView.delegate=self;
        


    }
    else //if sale type
    {   //if the sale is employee type
        if ([Session getIsEmployeeSale])
            [Session setSaleType:NORMAL_EMPLOYEE_TYPE];
        else
            [Session setSaleType:NORMAL_CLIENT_TYPE];
        
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) ticketGiftScreen];
    }
}
-(IBAction) saleDulceria
{
    [Session setSaleType:DULCERIA_CLIENT_TYPE];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) ticketGiftScreen];
}
-(IBAction) saleMesaRegalo
{
	//[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) consultSKUScreen];
    
}
-(IBAction) saleSOMS
{
    self.somsDialog = [[GenericDialogViewController alloc]initWithNibName:@"GenericDialogViewController" bundle:nil];
    //[self presentModalViewController:dialog animated:YES];
    [self presentViewController:self.somsDialog animated:YES completion:nil];

    [self.somsDialog release];
    [self.somsDialog initView:@"Favor de introducir el numero de orden SOMS" :somsSaleType :NO];
    self.somsDialog.title=@"SOMS";
    self.somsDialog.delegate=self;
    
    if (isRefound) {
        if ([Session getIsEmployeeSale])
            [Session setSaleType:REFUND_SOMS_EMPLOYEE_TYPE];
        else
            [Session setSaleType:REFUND_SOMS_TYPE];
    }
    else
        if ([Session getIsEmployeeSale]) 
            [Session setSaleType:SOMS_EMPLOYEE_TYPE];
        else 
            [Session setSaleType:SOMS_CLIENT_TYPE];
}
-(IBAction) saleRestaurant
{
    GenericDialogViewController *dialog=[[GenericDialogViewController alloc]initWithNibName:@"GenericDialogViewController" bundle:nil];
    //[self presentModalViewController:dialog animated:YES];
    [self presentViewController:dialog animated:YES completion:nil];

    [dialog release];
    [dialog initView:@"Favor de introducir el numero de Comanda" :foodSaleType:YES];
    dialog.title=@"Restaurant";
    dialog.delegate=self;
    
    [Session setSaleType:FOOD_CLIENT_TYPE];
    
}

-(void)didReceiveSomsListNotification:(NSNotification *)notification
{
    [Tools stopActivityIndicator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GETSOMSLIST_NOTIFICATION object:nil];
    NSDictionary *dicInfo = [notification userInfo];
    NSLog(@"Dic info %@",dicInfo);
    BOOL success = [[dicInfo objectForKey:@"success"] boolValue];
    
    if (success ==YES) {
        //Send to the soms screen
        [self dismissViewControllerAnimated:YES completion:nil];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) somsScreen:[dicInfo objectForKey:@"soms_list"]];
    } else {
        [Tools displayAlert:@"Error" message:[dicInfo objectForKey:@"message"] withDelegate:self];
    }
}

-(void) performAction:(NSString*) txtData : (ActionType) actionType
{
    //verify the input data for SOMS
    if (actionType==somsSaleType) {
        if ([txtData isEqualToString:@""]||[txtData length]<=9) {
            [Tools displayAlert:@"Error" message:@"Debe introducir un numero de orden de SOMS Valido"];
        }
        else {
            [Tools startActivityIndicator:self.somsDialog.view];
            [Session setSomsOrder:txtData];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSomsListNotification:) name:GETSOMSLIST_NOTIFICATION object:nil];
            [[LiverPoolRequest sharedInstance] requestDataType:SOMSListRequest withParameters:nil];
        }
    }
    if (actionType==foodSaleType) {
        if ([txtData isEqualToString:@""]||[txtData length]<26||[txtData length]>26) {
            [Tools displayAlert:@"Error" message:@"Debe introducir un numero de orden de Comanda Valido"];
    }
    else {
            [Session setComandaOrder:txtData];
            //[self dismissModalViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];

            [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) mainScreen];
        
        }
    }
    else if (actionType==refundType) {
        if ([txtData isEqualToString:@""]||[txtData length]<24||[txtData length]>24) {
            [Tools displayAlert:@"Error" message:@"Debe introducir un Codigo de barras Valido"];

        }
        else
        {
            [self dismissViewControllerAnimated:NO completion:nil];
            DLog(@"displayRefundReasonView");
            [Session setRefundCodeBar:txtData];
            [self displayRefundReasonView];
   
        }
    }
}
-(void) displayRefundReasonView
{
            GenericOptionsViewController *refound=[[GenericOptionsViewController alloc]initWithNibName:@"GenericOptionsViewController" bundle:nil];
            NSArray *refundChoices=[NSArray arrayWithObjects:@"1- Devolucion por talla o color dif. Pre",
                                    @"2- Devolucion por estilo",
                                    @"3- Devolucion por defecto",
                                    @"4- Devolucion por que no le gusto",
                                    @"5- Devolucion por regalo Duplicado",
                                    @"6- Cambio por mercancia de igual precio",
                                    nil];
            [refound setOptionsArray:refundChoices];
    
            [self presentViewController:refound animated:YES completion:nil];
    
            [refound release];
            refound.title=@"Seleccionar Motivo";
            refound.delegate=self;
}
-(void) performOptionAction:(int) index :(NSString*) value ;
{
    [Session setRefundCauseNumber:index];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) mainScreen];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) performExitAction
{
 //   [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}


-(void) dealloc
{
    [super dealloc];
    [btnDulceria release];
    [btnRestaurant release];
    [btnNormal release];
    [btnMesaRegalo release];
    [btnSOMS release];
}

@end
