//
//  CardReaderAppDelegate.m
//  CardReader
//

#import "CardReaderAppDelegate.h"
#import "ItemDetailViewController.h"
#import "ItemDiscountsViewController.h"
#import "ConsultSKUViewController.h"
#import "LoginViewController.h"
#import "TransactionsMenuViewController.h"
#import "AirtimeViewController.h"
#import "PromotionInstallmentViewController.h"
#import "BalanceViewController.h"
#import "Tools.h"
#import "PaymentPlanViewController.h"
#import "PaymentViewController.h"
#import "Session.h"
#import "TicketGiftViewController.h"
#import "SaleOptionsViewController.h"
#import "CloseTerminalViewController.h"
#import "CancelTicketViewController.h"
#import "GenericOptionsViewController.h"
#import "WithdrawScreenViewController.h"
@implementation CardReaderAppDelegate

@synthesize window;
@synthesize loginViewController,transactionMenu;
@synthesize aTabBarController/*,aNavigationControllerLogin*/,aNavigationControllerConfig,aNavigationControllerRecord;
@synthesize aNavigationControllerLogin;
@synthesize scanViewController;
@synthesize aTabBar;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
	[self loginScreen];
    [self.window makeKeyAndVisible];


	return YES;
}
-(void) loginScreen
{
	[scanViewController removeProductsFromList];
	[aNavigationControllerLogin popToRootViewControllerAnimated:NO];
    self.window.rootViewController=aNavigationControllerLogin;    
    UIViewController *lg=[aNavigationControllerLogin visibleViewController];
    [lg setTitle:@"Login"];
    [lg viewWillAppear:YES];

    [Session resetValues];

}
-(void) mainScreen{
    
    
//	//[aNavigationControllerLogin.view removeFromSuperview];
//    self.window.rootViewController=aTabBarController;
//
//	[[[[aTabBarController tabBar] items] objectAtIndex:0]
//	 setTitle:NSLocalizedString(@"Escaner",@"Tabbar item 1")];
//	[[[[aTabBarController tabBar] items] objectAtIndex:1] 
//	 setTitle:NSLocalizedString(@"Configuración",@"Tabbar item 2")];
//	[[[[aTabBarController tabBar] items] objectAtIndex:2] 
//	 setTitle:NSLocalizedString(@"Salir",@"Tabbar item 3")];
//		
//	[aTabBarController.view removeFromSuperview];
//	[self.window addSubview:aTabBarController.view];
//
//    //[scanViewController viewDidLoad];
//

    [aNavigationControllerLogin pushViewController:aTabBarController animated:YES];
    [scanViewController startRequestForTransaction];
    //[scanViewController setLayoutForTransaction];
    [aTabBarController setSelectedIndex:0];
    //[aTabBarController release]; // <<< breakpoint

}

-(void) ticketGiftScreen{
    TicketGiftViewController *ticket=[[TicketGiftViewController alloc] initWithNibName:@"TicketGiftViewController" bundle:nil];
    //[aNavigationControllerLogin presentModalViewController:ticket animated:NO];
    [aNavigationControllerLogin presentViewController:ticket animated:NO completion:nil];

    // [aNavigationControllerLogin pushViewController:ticket animated:YES];
    [ticket release];


}
-(void) removeMainScreen{
   // [aTabBarController removeFromParentViewController];
    [aNavigationControllerLogin popViewControllerAnimated:YES];
    
}
-(void) removeTicketGiftScreen{
    //[aNavigationControllerLogin dismissModalViewControllerAnimated:NO];
    [aNavigationControllerLogin dismissViewControllerAnimated:NO completion:nil];

    //[aNavigationControllerLogin popViewControllerAnimated:NO];
}
//-(void) refundScreen{
//    GenericOptionsViewController *refound=[[GenericOptionsViewController alloc] initWithNibName:@"GenericOptionsViewController" bundle:nil];
//    NSArray *refundChoices=[NSArray arrayWithObjects:@"1- Devolucion por talla o color dif. Pre",
//                            @"2- Devolucion por estilo",
//                            @"3- Devolucion por defecto",
//                            @"4- Devolucion por que no le gusto",
//                            @"5- Devolucion por regalo Duplicado",
//                            @"6- Cambio por mercancia de igual precio",
//                                                nil];
//    [refound setOptionsArray:refundChoices];
//    [aNavigationControllerLogin presentViewController:refound animated:NO completion:nil];
//    
//    [refound release];
//    
//    
//}
-(void) removeRefundScreen{
    //[aNavigationControllerLogin dismissModalViewControllerAnimated:NO];
    [aNavigationControllerLogin dismissViewControllerAnimated:NO completion:nil];
    
    //[aNavigationControllerLogin popViewControllerAnimated:NO];
}

-(void) consultSKUScreen
{
	ConsultSKUViewController *sku=[[ConsultSKUViewController alloc] initWithNibName:@"ConsultSKUViewController" bundle:nil];
	[aNavigationControllerLogin pushViewController:sku animated:YES];
    [sku setTitle:@"Consulta SKU"];
    
	//[transactionMenu presentModalViewController:sku animated:YES];
	[sku release];	
}
-(void) removeConsultSKUScreen
{
	//[transactionMenu dismissModalViewControllerAnimated:YES];
	[aNavigationControllerLogin popViewControllerAnimated:YES];
}
-(void) airTimeScreen
{
	AirtimeViewController *airTime=[[AirtimeViewController alloc] initWithNibName:@"AirtimeViewController" bundle:nil];
	//[transactionMenu presentModalViewController:airTime animated:YES];
    [transactionMenu presentViewController:airTime animated:YES completion:nil];

	[airTime release];
}
-(void) removeAirTimeScreen
{
	//[transactionMenu dismissModalViewControllerAnimated:YES];
    [transactionMenu dismissViewControllerAnimated:YES completion:nil];
	
}
-(void) transactionMenuScreen
{
	transactionMenu=[[TransactionsMenuViewController alloc] initWithNibName:@"TransactionsMenuViewController" bundle:nil];	
	[aNavigationControllerLogin pushViewController:transactionMenu animated:YES];
    [transactionMenu setTitle:@"Practicas de Servicio"];
	[transactionMenu release];
}

-(void) saleOptionScreen
{
	SaleOptionsViewController *sale=[[SaleOptionsViewController alloc] initWithNibName:@"SaleOptionsViewController" bundle:nil];	
	[aNavigationControllerLogin pushViewController:sale animated:YES];
    [sale setTitle:@"Ventas"];
	[sale release];
}
-(void) saleOptionRefundScreen
{
	SaleOptionsViewController *sale=[[SaleOptionsViewController alloc] initWithNibName:@"SaleOptionsViewController" bundle:nil];
    [sale setIsRefound:YES];
	[aNavigationControllerLogin pushViewController:sale animated:YES];
	[sale release];
}
-(void) removeSaleOptionScreen
{
    [aNavigationControllerLogin popViewControllerAnimated:YES];

}
-(void) transactionBalanceScreen
{
	BalanceViewController* balance=[[BalanceViewController alloc] initWithNibName:@"BalanceViewController" bundle:nil];
	//[transactionMenu presentModalViewController:balance animated:YES];
	[aNavigationControllerLogin pushViewController:balance animated:YES];
    [balance setTitle:@"Saldos"];
	[balance release];
}
-(void) removeTransactionMenuScreen
{
	[aNavigationControllerLogin popViewControllerAnimated:YES];
}
-(void) transactionF5MenuScreen
{
	transactionMenu=[[TransactionsMenuViewController alloc] initWithNibName:@"TransactionsF5MenuViewController" bundle:nil];	
	[aNavigationControllerLogin pushViewController:transactionMenu animated:YES];
    [transactionMenu setTitle:@"Consultas Disponibles"];
	[transactionMenu release];

}
-(void) detailItemScreen:(FindItemModel*) itemModel
{
	//[aNavigationControllerLogin popViewControllerAnimated:YES];
	ItemDetailViewController *itemDetailViewController=[[ItemDetailViewController alloc] initWithNibName:@"ItemDetailViewController" bundle:nil];
	[aNavigationControllerLogin pushViewController:itemDetailViewController animated:YES];
	[itemDetailViewController displayItemInfo:itemModel];
	[itemDetailViewController release];
}
-(void) itemDiscountScreen:(FindItemModel*) itemModel
{
	ItemDiscountsViewController *itemDiscViewController=[[ItemDiscountsViewController alloc] initWithNibName:@"ItemDiscountsViewController" bundle:nil];
	itemDiscViewController.title=@"Descuento Manual";
	[itemDiscViewController setItemModel:itemModel];
	[aNavigationControllerLogin pushViewController:itemDiscViewController animated:YES];
	[itemDiscViewController release];
}
-(void) removeDiscountScreen
{
	[aNavigationControllerLogin popViewControllerAnimated:YES];
}
-(void) itemPromotionScreen:(NSMutableArray*) aProductList
{
	ItemDiscountsViewController *itemDiscViewController=[[ItemDiscountsViewController alloc] initWithNibName:@"ItemPromotionsViewController" bundle:nil];
	itemDiscViewController.title=@"Promociones";
	[itemDiscViewController setItemModel:[aProductList lastObject]];
	[itemDiscViewController setProductList:aProductList];
	[itemDiscViewController startPromoRequest];
	[aNavigationControllerLogin pushViewController:itemDiscViewController animated:YES];
	[itemDiscViewController release];
}
-(void) installmentsScreen:(Promotions*) promo
{
	PromotionInstallmentViewController *promoInstallment=[[PromotionInstallmentViewController alloc] initWithNibName:@"PromotionInstallmentViewController" bundle:nil];
	promoInstallment.title=@"Plazos";
	[promoInstallment setPromo:promo];
	[promoInstallment showInstallmentsTable];
	[aNavigationControllerLogin pushViewController:promoInstallment animated:YES];
	//[aNavigationControllerLogin pushViewController:promoInstallment animated:YES];  // Ruben

	[promoInstallment release];
}
-(void) removeInstallmentsScreen
{
	[aNavigationControllerLogin popViewControllerAnimated:NO];	
	[aNavigationControllerLogin popViewControllerAnimated:YES];

	//[aNavigationControllerLogin popViewControllerAnimated:YES];  // Ruben

}
-(void) promoScreen:(Promotions*) promo
{
	PromotionInstallmentViewController *promoInstallment=[[PromotionInstallmentViewController alloc] initWithNibName:@"PromotionInstallmentDescription" bundle:nil];
	promoInstallment.title=@"Plazos";
	[promoInstallment setPromo:promo];
	[aNavigationControllerLogin pushViewController:promoInstallment animated:YES];
	//[aNavigationControllerLogin pushViewController:promoInstallment animated:YES];  // Ruben
	
	[promoInstallment release];
}
-(void) removePromoScreen
{
	[aNavigationControllerLogin popViewControllerAnimated:YES];
	//[aNavigationControllerLogin popViewControllerAnimated:YES];  // Ruben
}

-(void) paymentPlanScreen:(NSMutableArray*)originalPromotions :(NSMutableArray*) filteredPromotions :(PaymentViewController*) payView
{
	PaymentPlanViewController *payPlan=[[PaymentPlanViewController alloc] initWithNibName:@"PaymentPlanViewController" bundle:nil];
	payPlan.title=@"PaymentPlan";
    payPlan.payView=payView;
    
	[payPlan setPromotionGroup:originalPromotions]; 
	[payPlan setFilteredPlanGroup:filteredPromotions];//release after

	[aNavigationControllerLogin pushViewController:payPlan animated:NO];
	[payPlan release];
}
-(void) removePaymentPlanScreen
{
	[aNavigationControllerLogin popViewControllerAnimated:YES];
	//[aNavigationControllerLogin popViewControllerAnimated:YES];  // Ruben
}
-(void) paymentScreen:(NSMutableArray*)aProductList :(NSMutableArray*)aPromoGroup
{
    DLog(@"inserting Payment screen");
	NSString *paymentNib; 
	
	if ([Session getIsEmployeeSale]) { 
		paymentNib = @"PaymentView";
        //paymentNib = @"EmployeePaymentView";

        DLog(@"paymentScreenn ISEMPLOYEE");

	}
	else {
		paymentNib = @"PaymentView";
        DLog(@"paymentScreen isCLIENT");

	}
	
	PaymentViewController *pay = [[PaymentViewController alloc] initWithNibName:paymentNib bundle:nil];
	pay.title=@"Pago";
	[pay setProductList:aProductList];
	[pay setPromotionGroup:[aPromoGroup mutableCopy]];
	[pay setFilteredPlanGroup:[aPromoGroup mutableCopy]];//release after
	[pay setOriginalPromotionGroup:[aPromoGroup mutableCopy]];//release after

	[aNavigationControllerLogin pushViewController:pay animated:YES];
	[pay release];
}
-(void) removePaymentScreen
{
	[aNavigationControllerLogin popViewControllerAnimated:YES];
	//[aNavigationControllerLogin popViewControllerAnimated:YES];  // Ruben
}
-(void) closeTerminalScreen
{
    CloseTerminalViewController* close=[[CloseTerminalViewController alloc] initWithNibName:@"CloseTerminalViewController" bundle:nil];
	//[transactionMenu presentModalViewController:balance animated:YES];
	[aNavigationControllerLogin pushViewController:close animated:YES];
	[close release];
    
}
-(void) removeCloseTerminalScreen
{
    [aNavigationControllerLogin popViewControllerAnimated:YES];
}
-(void) cancelTicketScreen
{
    
    CancelTicketViewController* cancel=[[CancelTicketViewController alloc] initWithNibName:@"CancelTicketViewController" bundle:nil];
	//[transactionMenu presentModalViewController:balance animated:YES];
	[aNavigationControllerLogin pushViewController:cancel animated:YES];
	[cancel release];
    
}
-(void) removeCancelTicketScreen
{
    [aNavigationControllerLogin popViewControllerAnimated:YES];
}

-(void) withdrawScreen
{
    
    WithdrawScreenViewController* draw=[[WithdrawScreenViewController alloc] initWithNibName:@"WithdrawScreenViewController" bundle:nil];
	//[transactionMenu presentModalViewController:balance animated:YES];
	[aNavigationControllerLogin pushViewController:draw animated:YES];
    [transactionMenu setTitle:@"Retiro de Efectivo"];
	[draw release];
    
}
-(void) removewithdrawScreen
{
    [aNavigationControllerLogin popViewControllerAnimated:YES];
}

-(void) removeScreensToSaleView
{
	[aNavigationControllerLogin popToViewController:aTabBarController animated:YES];
}


-(void) hideTabBar
{
	aTabBar.hidden=(aTabBar.hidden==TRUE)?FALSE:TRUE;
	BOOL hiddenTabBar=!aTabBar.hidden;
	
	//[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:0.1];
	
	for(UIView *view in aTabBarController.view.subviews)
	{
		
		if([view isKindOfClass:[UITabBar class]])
		{
			
			if (hiddenTabBar) {
				[view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
			} else {
				[view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
			}
		} else {
			if (hiddenTabBar) {
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
			} else {
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
			}
			
		}
	}
	
	//[UIView commitAnimations];

}
-(void)applicationWillResignActive:(UIApplication *)application
{
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{

    DLog(@"applicationDidEnterBackground");

}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
 
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"DidBecomeActive");

    // Your processing to be performed on this thread.
    //first we get the reference to the actual view controller
    Linea *scanDevice = [Linea sharedDevice];
    
    //reference to the actual view
    topView=[aNavigationControllerLogin visibleViewController];
    DLog(@"REFERENCE VIEW %@",topView);
    [scanDevice removeDelegate:topView];
    [scanDevice setDelegate:self];
    


 
}

-(void)applicationWillTerminate:(UIApplication *)application
{
	// load the last printer used
	//[Tools savePrinter];
	
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	int newIndex=self.aTabBarController.selectedIndex;
	DLog(@"selecciono view %i",self.aTabBarController.selectedIndex);
	if (newIndex==1) {
		//[scanViewController logout];
		//[aTabBarController setSelectedIndex:0];
        [self loginScreen];
	}	
}

//- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    cBReady = false;
//    switch (central.state) {
//        case CBCentralManagerStatePoweredOff:
//            NSLog(@"CoreBluetooth BLE hardware is powered off");
//            break;
//        case CBCentralManagerStatePoweredOn:
//            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
//            cBReady = true;
//            break;
//        case CBCentralManagerStateResetting:
//            NSLog(@"CoreBluetooth BLE hardware is resetting");
//            break;
//        case CBCentralManagerStateUnauthorized:
//            NSLog(@"CoreBluetooth BLE state is unauthorized");
//            break;
//        case CBCentralManagerStateUnknown:
//            NSLog(@"CoreBluetooth BLE state is unknown");
//            break;
//        case CBCentralManagerStateUnsupported:
//            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
//            break;
//        default:
//            break;
//    }
//}

//---------------------------------------------
//        Bluetooth printer connection status
//---------------------------------------------
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self connect];
}

//---------------------------------------------
//        Battery Reader status
//---------------------------------------------
-(void)updateBattery
{
    DLog(@"Delegate Updating battery charge info.......");
    NS_DURING {
        Linea *scanDevice = [Linea sharedDevice];
		int percent;
        float voltage;
		[scanDevice getBatteryCapacity:&percent voltage:&voltage error:nil];
		if (percent < 5) {
			
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery0" ofType:@"png"]]];
            //[btton setImage:[UIImage imageNamed:@"Battery0.png"] forState:UIControlStateNormal];
            [self displayBatteryAnimation:@"BatteryH0.png" :YES];
            DLog(@"battery charge info....... <5%%");
            
		} else if (percent < 10) {
			
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery10" ofType:@"png"]]];
            //[btton setImage:[UIImage imageNamed:@"Battery10.png"] forState:UIControlStateNormal];
            [self displayBatteryAnimation:@"BatteryH10.png" :YES];

            DLog(@"battery charge info....... <10%%");
            
		} else if(percent < 40) {
			
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery40" ofType:@"png"]]];
            //[btton setImage:[UIImage imageNamed:@"Battery40.png"] forState:UIControlStateNormal];
            [self displayBatteryAnimation:@"BatteryH40.png" :NO];

            DLog(@"battery charge info....... <40%%");
            
		} else if(percent < 60) {
            
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery60" ofType:@"png"]]];
            //[btton setImage:[UIImage imageNamed:@"Battery60.png"] forState:UIControlStateNormal];
            [self displayBatteryAnimation:@"BatteryH60.png" :NO];

            DLog(@"battery charge info....... <60%%");
            
		} else if(percent < 80) {
            
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery80" ofType:@"png"]]];
            //[btton setImage:[UIImage imageNamed:@"Battery80.png"] forState:UIControlStateNormal];
            [self displayBatteryAnimation:@"BatteryH80.png" :NO];

            DLog(@"battery charge info....... <80%%");
            
		} else {
            
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery100" ofType:@"png"]]];
            //[btton setImage:[UIImage imageNamed:@"Battery100.png"] forState:UIControlStateNormal];
            [self displayBatteryAnimation:@"BatteryH100.png" :NO];

            DLog(@"battery charge info....... 100%%");
            
		}
		
    } NS_HANDLER {
        
		//[barButtonRight setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Disconnected" ofType:@"png"]]];
		
    } NS_ENDHANDLER
    
}

-(void) displayBatteryAnimation:(NSString*) image :(BOOL) soundOn
{
    DLog(@"image :%@ soundOn:%i",image,soundOn);
    
    //BatteryTabView *tab=[[BatteryTabView alloc] initwith]
    BatteryTabView *tab = [[[NSBundle mainBundle] loadNibNamed:@"BatteryTabView" owner:self options:nil] objectAtIndex:0];
    [tab.batteryView setImage:[UIImage imageNamed:image]];
    //[tab release];
    tab.frame = CGRectMake( -90, 230, tab.frame.size.width, tab.frame.size.height ); // set new position exactly
    [self.window addSubview:tab];
    
    // Set up your completion animation in a block
    
    //when the sound and animation ends, we must return the delegate to the currentview
    Linea *scanDevice = [Linea sharedDevice];
    [scanDevice removeDelegate:self];
    [scanDevice addDelegate:topView];
    [topView viewDidAppear:YES];
    DLog(@"removed delegate");
    
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // other animations here
                         tab.frame = CGRectMake( 0, 230, tab.frame.size.width, tab.frame.size.height ); // set new position exactly
                         
                                              }
                     completion:^(BOOL finished){
                         // ... completion stuff
                         //play the sound when the view reach the middle position
                         if (soundOn) {
                             Linea *scanDevice = [Linea sharedDevice];
                             /// int sound[] = {2730,150,0,30,2730,150};
                             int sound[] = {800,200,2,200,800,200,2,200};
                             
                             [scanDevice playSound:100
                                          beepData:sound
                                            length:sizeof(sound)
                                             error:nil];
                         }

                         
                         [UIView animateWithDuration:.5
                                               delay:.3
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              // other animations here
                                              tab.frame = CGRectMake( -90, 230, tab.frame.size.width, tab.frame.size.height ); // return position 
                                          }
                                          completion:^(BOOL finished){
                                              // ... completion stuff
                                              [tab removeFromSuperview];
                                              
                                              //hay que revisar como pasar el delegate de la vista al APPDELEGATE y regresarlo una vez que se termino la animacion

                                          }
                          ];

                     }
     ];

}


-(void)connectionState:(int)state
{
    DLog(@"connectionState APPDELEGATE");
	switch (state) {
            
		case CONN_DISCONNECTED:
            
		case CONN_CONNECTING:
			
			//[self setBarbuttonImage:barButtonDisconnected];
			break;
            
		case CONN_CONNECTED:
			NS_DURING {
                
		
                [self updateBattery];
                
			} NS_HANDLER {
				
				DLog(@"%@", [localException name]);
				DLog(@"%@", [localException reason]);
                
			} NS_ENDHANDLER
			
			break;
	}
}
//----------------------------------------
//            APPLICATION'S DOCUMENTS DIRECTORY
//----------------------------------------
#pragma mark -
#pragma mark APPLICATION'S DOCUMENTS DIRECTORY

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
												   inDomains:NSUserDomainMask] lastObject];
}

//----------------------------------------
//            APPLICATION'S MEMORY MANAGMENT
//----------------------------------------
- (void)dealloc {
	[aTabBar release];
	scanViewController=nil;
	[window release], window =nil;
	[aTabBarController release],aTabBarController=nil;
	[aNavigationControllerLogin release],aNavigationControllerLogin=nil;
	[aNavigationControllerRecord release],aNavigationControllerRecord=nil;
	[aNavigationControllerConfig release],aNavigationControllerConfig=nil;
	[loginViewController release],loginViewController=nil;
	[transactionMenu release]; transactionMenu=nil;
	[aNavigationControllerLogin release]; aNavigationControllerLogin=nil;
    [super dealloc];
}


@end
