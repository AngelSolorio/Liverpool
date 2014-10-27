//
//  ScanViewController.m
//  CardReader
//


#import "ScanViewController.h"
#import "ProjectConstants.h"
#import "PaymentViewController.h"
#import "FindItemParser.h"
#import "FindItemModel.h"
#import "CardReaderAppDelegate.h"
#import "Promotions.h"
#import "Styles.h"
#import "Tools.h"
#import "Session.h"
#import "Seller.h"
#import "CardReaderAppDelegate.h"
#import "SomsListParser.h"
#import "Rules.h"
#import "WarrantyViewController.h"

@implementation ScanViewController

@synthesize textDescription;
@synthesize btnScan;
@synthesize btnPay;
@synthesize barButtonLeft;
@synthesize barButtonRight;
@synthesize aTableView;
@synthesize txtSKUManual;
@synthesize lblSKU;

typedef enum {
	
	barButtonDisconnected = 0,
	barButtonConnected,
	barButtonScanning,
	barButtonCharge,
	barButtonUnknown

} barButtonImageLoad;

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    DLog(@"Viewdidload scanviewcontroller");
	[self setTitle:@"Liverpool"];

	status = [[NSMutableString alloc] init];
	debug = [[NSMutableString alloc] init];
	
	selectedItemIndex=-1;
	
#if (TARGET_IPHONE_SIMULATOR)
	[btnScan setTitle:NSLocalizedString(@"Registro", @"Connect accessory to iPhone/iPod")
			 forState:UIControlStateNormal];
	[btnPay setHidden:YES];
#else
	[btnScan setTitle:NSLocalizedString(@"Conectar el Dispositivo", @"Connect accessory to iPhone/iPod")
			 forState:UIControlStateNormal];
	[btnPay setHidden:NO];
#endif
		
	[self setBarbuttonImage:barButtonDisconnected];
	[Styles bgGradientColorPurple:self.view];	
	[Styles silverButtonStyle:btnPay];
	[Styles silverButtonStyle:btnScan];
	
	[Tools validatePrinterConfig];
    //[self setLayoutForTransaction];

    //setting the battery charge icon
    btton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btton setFrame:CGRectMake(0, 0, 30, 30)];
    [btton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btton setImage:[UIImage imageNamed:@"Battery100.png"] forState:UIControlStateNormal];
    [btton setEnabled:NO];
    
    barButtonLeft = [[UIBarButtonItem alloc] initWithCustomView:btton];
    //barButtonLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Battery100.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:barButtonLeft animated:NO];
    [barButtonLeft release];
    
}

//this method set the layout of the view for the specific transaction
//NORMAL has all the options active, scanner is on
//SOMS cannot add more items to the ticket for example , scanner is off in this mode, manual input of barcode is off
//Restaurant cannot add more items to the ticket, scanner is off, promotions off, can add tips.
-(void) setLayoutForTransaction
{
    SaleType type=[Session getSaleType];
    if (type==NORMAL_CLIENT_TYPE||type==NORMAL_EMPLOYEE_TYPE) {
        DLog(@"NORMAL_CLIENT_TYPE");
        //manual input barcode ON
        txtSKUManual.hidden=NO;
        btnScan.hidden=NO;
        lblSKU.hidden=YES;
        lblSKU.text=@"SKU";
        lblSKU.hidden=NO;

        
        //set the default action for scan button
        [btnScan setTitle:@"SKU" forState:UIControlStateNormal];
        [btnScan removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
        
        [btnScan addTarget:self
                    action:@selector(stopScanBarCode:)
          forControlEvents:UIControlEventTouchUpInside];
        
        //set the default action for payButton
        [btnPay removeTarget:nil
                      action:NULL
            forControlEvents:UIControlEventAllEvents];
        
        [btnPay addTarget:self
                   action:@selector(payItems:)
         forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (type==SOMS_CLIENT_TYPE||type==SOMS_EMPLOYEE_TYPE)
    {
        DLog(@"SOMS_CLIENT_TYPE");

        //scanner off
        [self setBarbuttonImage:barButtonDisconnected];
        [scanDevice removeDelegate:self];
        [scanDevice disconnect];
        scanDevice = nil;
            
        //manual input barcode off
        txtSKUManual.hidden=YES;
        btnScan.hidden=YES;
        lblSKU.hidden=YES;
        
        //set the default action for scan button
        [btnScan setTitle:@"SKU" forState:UIControlStateNormal];
        [btnScan removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
        
        [btnScan addTarget:self
                    action:@selector(stopScanBarCode:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
        //set the default action for payButton
        [btnPay removeTarget:nil
                      action:NULL
            forControlEvents:UIControlEventAllEvents];
        
        [btnPay addTarget:self
                   action:@selector(payItems:)
         forControlEvents:UIControlEventTouchUpInside];
        
        

        //get the SOMS ORDER
       // [self startSOMSRequest];
    }else if(type==FOOD_CLIENT_TYPE)
    {
        DLog(@"FOOD_CLIENT_TYPE");
        
        //scanner off
        [self setBarbuttonImage:barButtonDisconnected];
        [scanDevice removeDelegate:self];
        [scanDevice disconnect];
        scanDevice = nil;
        
        txtSKUManual.hidden=NO;
        btnScan.hidden=NO;
        lblSKU.hidden=YES;
        lblSKU.text=@"Propina";
        lblSKU.hidden=NO;

        //change the action of the buttons for Restaurant
        [btnScan setTitle:@"Propina" forState:UIControlStateNormal];
        [btnScan removeTarget:nil 
                                action:NULL 
                      forControlEvents:UIControlEventAllEvents];
        
        [btnScan addTarget:self 
                             action:@selector(addTipToTicket:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //Skip the Promotion view, Restaurant doesnt apply promotions
        [btnPay removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
        
        [btnPay addTarget:self
                    action:@selector(payItemsRestaurant:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
       //[self startComandaRequest];
        
    }
    //set the layout for the refund transaction
    else if(type==REFUND_NORMAL_EMPLOYEE_TYPE||type==REFUND_NORMAL_TYPE)
    {
        DLog(@"REFUND TYPE NORMAL");
                
        txtSKUManual.hidden=YES;
        lblSKU.hidden=NO;
        lblSKU.text=@"SKU";
        lblSKU.hidden=YES;
        
        //change the action of the buttons for Restaurant
        btnScan.hidden=YES;
        [btnScan setTitle:@"SKU" forState:UIControlStateNormal];
        [btnScan removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
        
        [btnScan addTarget:self
                    action:@selector(addSKURefund:)
          forControlEvents:UIControlEventTouchUpInside];
        btnScan.hidden=NO;

        
        
        //Skip the Promotion view, Restaurant doesnt apply promotions
        [btnPay removeTarget:nil
                      action:NULL
            forControlEvents:UIControlEventAllEvents];
        
        [btnPay addTarget:self
                   action:@selector(payItemsRestaurant:)
         forControlEvents:UIControlEventTouchUpInside];
        
        
        // [self startComandaRequest];
        
    }
    else if (type==DULCERIA_CLIENT_TYPE) {
        DLog(@"DULCERIA_CLIENT_TYPE");
        //manual input barcode ON
        txtSKUManual.hidden=NO;
        btnScan.hidden=NO;
        lblSKU.hidden=YES;
        lblSKU.text=@"SKU";
        lblSKU.hidden=NO;
        
        
        //set the default action for scan button
        [btnScan setTitle:@"SKU" forState:UIControlStateNormal];
        [btnScan removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
        
        [btnScan addTarget:self
                    action:@selector(stopScanBarCode:)
          forControlEvents:UIControlEventTouchUpInside];
        
        //set the default action for payButton
        [btnPay removeTarget:nil
                      action:NULL
            forControlEvents:UIControlEventAllEvents];
        
        [btnPay addTarget:self
                   action:@selector(payItemsRestaurant:)
         forControlEvents:UIControlEventTouchUpInside];
        
    }

}
-(void) startRequestForTransaction
{
    //this method initiates the request associated with SOMS and RESTAURANT (which must be loaded before the view is loaded)
    SaleType type=[Session getSaleType];
    if (type==NORMAL_CLIENT_TYPE||type==NORMAL_EMPLOYEE_TYPE) {
        DLog(@"NORMAL_CLIENT_TYPE");
    }
    else if (type==SOMS_CLIENT_TYPE||type==SOMS_EMPLOYEE_TYPE)
    {
        DLog(@"SOMS_CLIENT_TYPE");
        //get the SOMS ORDER
        [self startSOMSRequest];
    }else if(type==FOOD_CLIENT_TYPE)
    {
        DLog(@"FOOD_CLIENT_TYPE");
        [self startComandaRequest];
    }
    else if(type==REFUND_NORMAL_TYPE)
    {
        DLog(@"REFUND_NORMAL_TYPE");
    }
    else if(type==REFUND_NORMAL_EMPLOYEE_TYPE)
    {
        DLog(@"REFUND_NORMAL_EMPLOYEE_TYPE");
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	DLog(@"viewwilldisappear scan");

	[scanDevice removeDelegate:self];
	[scanDevice disconnect];
	scanDevice = nil;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"viewDidappear scan");
 
    //cardreader SDK
	scanDevice = [Linea sharedDevice];
    [scanDevice setDelegate:self];
	[scanDevice connect];
    

    
}
-(void)viewWillAppear:(BOOL)animated
{
	DLog(@"viewwillappear scan");
	[super viewWillAppear:animated];
   
    txtSKUManual.text=@"";
    txtSKUManual.inputAccessoryView=[Tools inputAccessoryView:txtSKUManual];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationItem.hidesBackButton = YES;
    

	if([productList count]==0) [btnPay setHidden:YES];
	[aTableView reloadData];
    
    [self setLayoutForTransaction];
    [[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) aNavigationControllerLogin] setNavigationBarHidden:YES];

	
}

//-(void)viewDidUnload
//{
//	[scanDevice removeDelegate:self];
//	[scanDevice disconnect];
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
//            TABLE VIEW MANAGEMENT
//----------------------------------------
#pragma mark -
#pragma mark TABLE VIEW MANAGEMENT

-(UITableViewCell *)tableView:(UITableView *)tableView 
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:@"Cell"]autorelease];
        CGRect size=CGRectMake(0,0,aTableView.frame.size.width, cell.frame.size.height);
        cell.frame=size;
	}else{
        for (UIView* subview in [cell.contentView subviews]) {
           // if (subview.tag!=0) {
                [subview removeFromSuperview];
            //}
        }
    }
	//cell.textLabel.textColor=[UIColor whiteColor];
	//cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	//[cell.textLabel setText:[[tableData objectAtIndex:indexPath.row] objectForKey:@"Text"]];
	//[cell.detailTextLabel setText:[[tableData objectAtIndex:indexPath.row] objectForKey:@"DetailText"]];
	//[cell.imageView setImage:[[tableData objectAtIndex:indexPath.row] objectForKey:@"Image"]];
	
    //FindItemModel *item=[productList objectAtIndex:indexPath.row];
    id item = [productList objectAtIndex:indexPath.row];
    
	UILabel *aLabelNumberRow = [[UILabel alloc] initWithFrame:
					   CGRectMake(cell.frame.size.width - 310, 
								  cell.frame.size.height - 44, 
								  60, 40)];
	[aLabelNumberRow setText:[NSString stringWithFormat:@"%i",indexPath.row+1]];
	[aLabelNumberRow setFont:[UIFont boldSystemFontOfSize:16]];
	//[aLabelNumberRow setFont:[UIFont boldSystemFontOfSize]];
	[aLabelNumberRow setTextColor:[UIColor whiteColor]]; 
	[aLabelNumberRow setBackgroundColor:[UIColor clearColor]];
	[aLabelNumberRow setAdjustsFontSizeToFitWidth:YES];
	[aLabelNumberRow setTextAlignment:NSTextAlignmentCenter];
	[[cell contentView] addSubview:aLabelNumberRow];
	[aLabelNumberRow release];
	
	
	UILabel *aLabelName = [[UILabel alloc] initWithFrame:
					   CGRectMake(cell.frame.size.width - 260, 
								  cell.frame.size.height - 44, 
								  220, 22)];
	[aLabelName setFont:[UIFont boldSystemFontOfSize:16]];
	[aLabelName setBackgroundColor:[UIColor clearColor]];
	[aLabelName setTextColor:[UIColor whiteColor]]; 
	[aLabelName setAdjustsFontSizeToFitWidth:YES];
	[[cell contentView] addSubview:aLabelName];
	[aLabelName release];
	
	UILabel *aLabelDescription = [[UILabel alloc] initWithFrame:
					   CGRectMake(cell.frame.size.width - 260, 
								  cell.frame.size.height - 22, 
								  110, 22)];
	[aLabelDescription setBackgroundColor:[UIColor clearColor]];
	[aLabelDescription setTextColor:[UIColor whiteColor]]; 
	[aLabelDescription setAdjustsFontSizeToFitWidth:YES];
	[[cell contentView] addSubview:aLabelDescription];
	[aLabelDescription release];
	
	
	//----
	UILabel *aLabel = [[UILabel alloc] initWithFrame:
					   CGRectMake(cell.frame.size.width - 70, 
								  cell.frame.size.height - 50, 
								  70, 30)];
	[aLabel setFont:[UIFont boldSystemFontOfSize:16]];
	[aLabel setBackgroundColor:[UIColor clearColor]];
	[aLabel setTextColor:[UIColor whiteColor]]; 
	[aLabel setAdjustsFontSizeToFitWidth:YES];
	[[cell contentView] addSubview:aLabel];
	[aLabel release];
	
	UILabel *aLabelDiscount = [[UILabel alloc] initWithFrame:
					   CGRectMake(cell.frame.size.width - 50,
								  cell.frame.size.height - 30, 
								  50, 30)];
	[aLabelDiscount setBackgroundColor:[UIColor clearColor]];
	[aLabelDiscount setTextColor:[UIColor whiteColor]]; 
	[aLabelDiscount setAdjustsFontSizeToFitWidth:YES];
	[[cell contentView] addSubview:aLabelDiscount];
	[aLabelDiscount release];
    
    //------
    UILabel *aLabelQuantity = [[UILabel alloc] initWithFrame:
                               CGRectMake(cell.frame.size.width - 90,
                                          cell.frame.size.height - 30,
                                          30, 30)];
	[aLabelQuantity setBackgroundColor:[UIColor clearColor]];
	[aLabelQuantity setTextColor:[UIColor whiteColor]];
	[aLabelQuantity setAdjustsFontSizeToFitWidth:YES];
	[[cell contentView] addSubview:aLabelQuantity];
	[aLabelQuantity release];
    
    if ([item isKindOfClass:[FindItemModel class]]) {
        if ([item itemForGift]) {
            UIImageView *aImageView=[[UIImageView alloc]initWithFrame:
                                     CGRectMake(cell.frame.size.width - 320,
                                                cell.frame.size.height - 34,
                                                30, 30)];
            [aImageView setImage:[UIImage imageNamed:@"boxgift.png"]];
            [[cell contentView] addSubview:aImageView];
            [aImageView release];
            
            
        }
        [aLabelName setText:[item description]];
        [aLabelDescription setText:[item barCode]];
        [aLabel setText:[Tools amountCurrencyFormat:[item price]]];
        NSLog(@"Disconut");
        [aLabelDiscount setText:[self displayPromotionDiscount:indexPath.row]];
        [aLabelQuantity setText:[Tools maskQuantityFormat:[item itemCount]]];
    } else if ([item isKindOfClass:[Warranty class]]){
        NSLog(@"Warranty found");
        [aLabelName setText:[item detail]];
        [aLabelDescription setText:[item sku]];
        [aLabel setText:[Tools amountCurrencyFormat:[item cost]]];
        [aLabelQuantity setText:[Tools maskQuantityFormat:@"1"]];
    }

	
	return cell;
}
-(NSString*) displayPromotionDiscount:(int) index
{   NSLog(@"Display promotions");
	NSString *discountAmount=@"";
	FindItemModel *item=[productList objectAtIndex:index];
	if (item.promo&&[item.discounts count]>0) {
		Promotions *promo=[item.discounts objectAtIndex:0];
		
		if (promo.promoType==3) // % discount by key
		{	discountAmount=[NSString stringWithFormat:@"-%@",promo.promoValue]; 
			[Tools amountCurrencyFormat:discountAmount];
			return discountAmount;
		}else
			if(promo.promoType==4) // fixed amount by key discount
			{	discountAmount=[NSString stringWithFormat:@"-%@",promo.promoDiscountPercent]; 
				[Tools amountCurrencyFormat:discountAmount];
				return discountAmount;
			}else
				//return @"PLAZOS";
				return @"";
	}
	else 
		return @"";

}
-(NSInteger)tableView:(UITableView *)tableView 
numberOfRowsInSection:(NSInteger)section
{
	return [productList count];
}

-(void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[self editItemForTransaction:indexPath];
	}
	
	if ([tableView numberOfRowsInSection:indexPath.section] == 0) {
		
		[btnPay setHidden:YES];
		
	}
}
/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}*/

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
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)] autorelease];
	[header setBackgroundColor:[UIColor grayColor]];
	return header;
	
}*/
-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (total != 0) {
		
		total = 0;
		
	}
	
	/*for (FindItemModel *item in productList) {
		
		DLog(@"Title for footer:%@",item);
		DLog(@"Price:%i",total);
		total += [[item price] floatValue];
		
	}*/
	total=[[Tools calculateAmountToPay:productList] floatValue];
    
	UILabel *lblTotal=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
	lblTotal.text=[Tools amountCurrencyFormat:[NSString stringWithFormat:@"%.02f",total]];
	lblTotal.text=[NSString stringWithFormat:@"SubTotal: %@",lblTotal.text];
	lblTotal.backgroundColor=[UIColor clearColor];
	lblTotal.textColor=[UIColor blackColor];
	
	UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)] autorelease];
	[footer setBackgroundColor:[UIColor whiteColor]];
	[footer addSubview:lblTotal];
	[lblTotal release];
	return footer;
	
}
/*-(NSString *)tableView:(UITableView *)tableView 
titleForFooterInSection:(NSInteger)section
{
	if (total != 0) {
		 
		total = 0;
		
	}
	
	for (NSDictionary *aDic in tableData) {
	
		DLog(@"Title for footer:%@",aDic);
		DLog(@"Price:%i",total);
		total += [[aDic objectForKey:@"Price"] intValue];
		
	}
	
	return [NSString stringWithFormat:@"Total: $%i",total];
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //disable the discounts view if the sale is of type: restaurant
    if ([Session getSaleType]!=FOOD_CLIENT_TYPE) 
        if (selectedItemIndex==indexPath.row) {
            //detail item
            FindItemModel *item=[productList objectAtIndex:indexPath.row];
            [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) detailItemScreen:item];
            
            NSIndexPath *indexP=[NSIndexPath indexPathWithIndex:selectedItemIndex];
            [tableView deselectRowAtIndexPath:indexP animated:YES];
            selectedItemIndex=-1;
        }
	selectedItemIndex=indexPath.row;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];
	UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
	//bg.backgroundColor = UIColorFromRGBWithAlpha(0X66224F,1);
	bg.backgroundColor = UIColorFromRGBWithAlpha(0XC235A5,0.5);
	cell.backgroundView = bg;
	cell.backgroundColor = [UIColor clearColor];
	[bg release];
}
//----------------------------------------
//            SCAN DEVICE HANDLER
//----------------------------------------
#pragma mark -
#pragma mark SCAN DEVICE HANDLER

-(void)buttonPressed:(int)whichButton
{
	[self setBarbuttonImage:barButtonScanning];
}

-(void)buttonReleased:(int)which
{
	[self setBarbuttonImage:barButtonConnected];
}

-(void)connectionState:(int)state
{
	switch (state) {

		case CONN_DISCONNECTED:
		
		case CONN_CONNECTING:
			
			[self setBarbuttonImage:barButtonDisconnected];
			break;
		
		case CONN_CONNECTED:
			
			[self setBarbuttonImage:barButtonConnected];
			
			NS_DURING {

				[scanDevice msEnable:nil];
				//[scanDevice setBarcodeTypeMode:BARCODE_TYPE_EXTENDED];
				[self enableCharging];
                [self updateBattery];

//				[btnScan setTitle:NSLocalizedString(@"Registro", @"Scan with accessory to iPhone/iPod") 
//						 forState:UIControlStateNormal];
//				[btnScan setUserInteractionEnabled:YES];
				
			} NS_HANDLER {
				
				DLog(@"%@", [localException name]);
				DLog(@"%@", [localException reason]);
			
			} NS_ENDHANDLER
			
			break;
	}
}

-(void)enableCharging
{
	NS_DURING {
		
		[scanDevice setCharging:YES error:nil];
    
	} NS_HANDLER {
		
	} NS_ENDHANDLER
}

-(void)updateBattery
{
    DLog(@"Updating battery charge info.......");
    NS_DURING {
		int percent;
        float voltage;
		[scanDevice getBatteryCapacity:&percent voltage:&voltage error:nil];
		if (percent < 5) {
			
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery0" ofType:@"png"]]];
            [btton setImage:[UIImage imageNamed:@"Battery0.png"] forState:UIControlStateNormal];
            DLog(@"battery charge info....... <5%%");

		} else if (percent < 10) {
			
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery10" ofType:@"png"]]];
            [btton setImage:[UIImage imageNamed:@"Battery10.png"] forState:UIControlStateNormal];
            DLog(@"battery charge info....... <10%%");

		} else if(percent < 40) {
			
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery40" ofType:@"png"]]];
            [btton setImage:[UIImage imageNamed:@"Battery40.png"] forState:UIControlStateNormal];
            DLog(@"battery charge info....... <40%%");

		} else if(percent < 60) {
		
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery60" ofType:@"png"]]];
            [btton setImage:[UIImage imageNamed:@"Battery60.png"] forState:UIControlStateNormal];
            DLog(@"battery charge info....... <60%%");

		} else if(percent < 80) {
	
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery80" ofType:@"png"]]];
            [btton setImage:[UIImage imageNamed:@"Battery80.png"] forState:UIControlStateNormal];
            DLog(@"battery charge info....... <80%%");

		} else {
		
			//[barButtonLeft setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Battery100" ofType:@"png"]]];
            [btton setImage:[UIImage imageNamed:@"Battery100.png"] forState:UIControlStateNormal];
            DLog(@"battery charge info....... 100%%");

            

		}
		
    } NS_HANDLER {

		[barButtonRight setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Disconnected" ofType:@"png"]]];
		
    } NS_ENDHANDLER
  
}

//----------------------------------------
//            BARCODE ANALYSIS
//----------------------------------------
#pragma mark -
#pragma mark BARCODE ANALYSIS

-(void)barcodeData:(NSString *)barcode 
			  type:(int)type 
{	

	[status setString:@""];
	[status appendFormat:@"Type: %d\n",type];
	[status appendFormat:@"Type text: %@\n",[scanDevice barcodeType2Text:type]];
	[status appendFormat:@"Barcode: %@",barcode];
	DLog(@"%@", status);
	
	[self startRequest:barcode];

	NS_DURING {
		
		[self updateBattery];
	
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
	[status setString:@""];
	
//	financialCard card;
//	
//	if([scanDevice msProcessFinancialCard:&card 
//								   track1:track1 
//								   track2:track2]) {
//		
//		lastCardName=[card.cardholderName copy];
//		lastCardNumber=[card.accountNumber copy];
//		if(card.exirationYear!=0)
//			lastExpDate=[[NSString stringWithFormat:@"%d/%d\n",card.exirationMonth,card.exirationYear] retain];
//		
//		
//		if(card.cardholderName!=NULL)
//			[status appendFormat:@"Name: %@\n",card.cardholderName];
//		if(card.accountNumber!=NULL)
//			[status appendFormat:@"Number: %@\n",card.accountNumber];
//		if(card.exirationYear!=0)
//			[status appendFormat:@"Expiration: %d/%d\n",card.exirationMonth,card.exirationYear];
//		[status appendString:@"\n"];
//	}
	
	if(track1 != nil) {
	
		[status appendFormat:@"Track1: %@\n",track1];
		
	}
	
	if(track2 != nil) {
		
		[status appendFormat:@"Track2: %@\n",track2];
		
	}
	
	if(track3 != nil) {
		
		[status appendFormat:@"Track3: %@\n",track3];
		
	}
	
	DLog(@"%@",status);
	
	int sound[] = {2730,150,0,30,2730,150};
	[scanDevice playSound:100 
				 beepData:sound 
				   length:sizeof(sound)
                    error:nil];
	[self updateBattery];
}

//----------------------------------------
//            ADITIONALS VIEW
//----------------------------------------
#pragma mark -
#pragma mark ADITIONAL VIEW


//----------------------------------------
//            ACTIONS
//----------------------------------------
#pragma mark -
#pragma mark ACTIONS


-(IBAction)stopScanBarCode:(id)sender
{

	NSString *skuManual=[txtSKUManual.text copy];
    txtSKUManual.text=@"";
	if ([skuManual length]==0) {
        [scanDevice removeDelegate:self];
		[Tools displayAlert:@"Aviso" message:@"Favor de introducir un SKU valido" withDelegate:self];
		return;
	}
	[self startRequest:skuManual];
	[self.view endEditing:YES];
	[self setBarbuttonImage:barButtonConnected];
    [skuManual release];

}

-(IBAction)payItems:(id)sender
{
	/*DLog(@"Pay items");
	PaymentViewController *pay = [[PaymentViewController alloc] init];
	pay.scanView=self;
	[self presentModalViewController:pay
							animated:YES];
	[pay release];

	DLog(@"payment retain:%i",[pay retainCount]);
	[pay setProductList:productList];
	[pay changeTotalValue:total];*/
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) itemPromotionScreen:productList];

}

//skip the promotion view 
-(IBAction)payItemsRestaurant:(id)sender
{
	DLog(@"payItemsRestaurant/Dulceria");
    NSMutableArray *promos=[[NSMutableArray alloc]init];
    /*Promotions *promo=[[Promotions alloc]init];
    promo.promoDescription=@"promoDescription";
	promo.promoDescriptionPrinter=@"promoDescription";
	promo.promoDiscountPercent=@"promoDescription";
	promo.promoAplicationMethod=@"promoDescription";
	promo.promoBaseAmount=@"promoDescription";
	promo.promoMagnitude=@"promoDescription";
	promo.promoQty=@"promoDescription";
	promo.promoValue=@"promoDescription";
	promo.promoProrationMethod=@"promoDescription";
	promo.promoTypeBenefit=@"promoDescription";
	promo.promoInstallment=@"promoDescription";
	promo.promoInstallmentSelected=@"promoDescription";
	promo.header=@"promoDescription";
	promo.promoType=1; //deprecated.
	promo.planId=@"promoDescription";
	promo.promoTypeMonedero=@"promoDescription";
	promo.promoPrefixs=@"promoDescription";
	promo.promoExcludePrefixs=@"promoDescription";
	promo.promoTender=@"promoDescription";
	promo.promoBank=@"promoDescription";
    
    [promos addObject:promo];
    [promo release];*/
    DLog(@"productLIST: %@",productList);
    DLog(@"promos: %@",promos);

	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) paymentScreen:productList :promos];
    
}

-(void) removeProductsFromList
{
	[productList removeAllObjects];
	[self viewWillDisappear:NO];

}
-(IBAction) logout
{
	DLog(@"scanview logout");
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) loginScreen];
}

-(IBAction)addTipToTicket:(id)sender
{
    if ([Rules isTipAdded:productList]) 
    {
        [scanDevice removeDelegate:self];
        [Tools displayAlert:@"Error" message:@"Solo se permite una propina por transaccion" withDelegate:self];
        return;
    }
    //AGREGAR PROPINA AL TICKET
    NSString *tipAmount=[txtSKUManual text];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:tipAmount];
    
    [f release];
    if (myNumber==nil) {
        [scanDevice removeDelegate:self];
        [Tools displayAlert:@"Error" message:@"Cantidad invalida" withDelegate:self];
    }
    else
       // [self startComandaRequest];
    {
        
        FindItemModel *tip= [[FindItemModel alloc]init];
        [tip setBarCode:@"0009999990"];
        [tip setPrice:tipAmount];
        [tip setDescription:@"Propina"];
        [tip setDepartment:@"0000000897"];
        [tip setPriceExtended:tipAmount];

        
        if (productList == nil) {
			productList = [[NSMutableArray alloc] init];
		}
        
		[productList addObject:tip];
        [self setDataIntoArray:tip];
        [tip release];
        [self.view endEditing:YES];
    }
    [txtSKUManual setText:@""];
}
-(IBAction)addSKURefund:(id)sender
{

//    //AGREGAR PROPINA AL TICKET
//    NSString *sku=[txtSKUManual text];
//    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//    [f setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSNumber * myNumber = [f numberFromString:sku];
//    
//    [f release];
//    if (myNumber==nil) {
//        [Tools displayAlert:@"Error" message:@"SKU invalida"];
//    }
//    else
//    {
//        [self startRequest:sku];
//        
//
//    }
    
    GenericCancelViewController *cancel=[[GenericCancelViewController alloc]initWithNibName:@"GenericCancelViewController" bundle:nil];
    [self presentViewController:cancel animated:YES completion:nil];
    [cancel initView:@"SKU" :@"Precio" :refundActionType];
    [cancel setDelegate:self];
}

-(void) performAction:(NSString*) txtData1 :(NSString*) txtData2 : (CancelType) actionType
{
    //replacing the last item price
    
    
    if ([txtData1 length]!=0 || [txtData2 length]!=0) {
        DLog(@"txtData1 : %@ txtData2: %@",txtData1, txtData2);
        [self startRequestWithPrice:txtData1 :txtData2];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [scanDevice removeDelegate:self];
        [Tools displayAlert:@"Error" message:@"Favor de introducir correctamente los el SKU y el precio" withDelegate:self];
    }
}
//----------------------------------------
//            MISC METHODS
//----------------------------------------
#pragma mark -
#pragma mark MISC METHODS

-(void)setBarbuttonImage:(int)imageToLoad
{
	UIImage *image = nil;
	
	switch (imageToLoad) {
		case barButtonConnected: {
			
			image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Connected" ofType:@"png"]];
			break;
		
		} case barButtonScanning: {
			
			image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Scaning" ofType:@"png"]];
			
			break;

		} case barButtonCharge: {
			
			[self updateBattery];
			break;
			
		} case barButtonDisconnected: {
			
			image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Disconnected" ofType:@"png"]];
			break; 
			
		} default: {
			
			image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Disconnected" ofType:@"png"]];
			break; 
			
		}
	}
	
	UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
	[barButtonRight setCustomView:imgView];
	[imgView release];
}
/*
-(void)turnOnEditing
{
	if (barButtonLeft == nil) {

		barButtonLeft = [[UIBarButtonItem alloc] 
						 initWithTitle:NSLocalizedString(@"Terminar", @"Done left bar button")
						 style:UIBarButtonItemStyleBordered
						 target:self 
						 action:@selector(turnOffEditing)];
		
	} else {
		
		[barButtonLeft setStyle:(UIBarButtonItemStyle)UIBarButtonSystemItemDone];
		[barButtonLeft setTarget:self];
		[barButtonLeft setAction:@selector(turnOffEditing)];
		[barButtonLeft setTitle:NSLocalizedString(@"Terminar", @"Done left bar button")];
		
	}
	
	self.navigationItem.leftBarButtonItem = barButtonLeft;
	[aTableView setEditing:YES
				  animated:YES];
}

-(void)turnOffEditing
{
	if (barButtonLeft == nil) {
		
		barButtonLeft = [[UIBarButtonItem alloc] 
						 initWithTitle:NSLocalizedString(@"Editar", @"Edit left bar button")
						 style:UIBarButtonItemStyleBordered
						 target:self 
						 action:@selector(turnOnEditing)];
		
	} else {
		
		[barButtonLeft setStyle:(UIBarButtonItemStyle)UIBarButtonSystemItemEdit];
		[barButtonLeft setTarget:self];
		[barButtonLeft setAction:@selector(turnOnEditing)];
		[barButtonLeft setTitle:NSLocalizedString(@"Editar", @"Edit left bar button")];
		
	}
	
	self.navigationItem.leftBarButtonItem = barButtonLeft;
	[aTableView setEditing:NO 
				  animated:YES];
}
*/
-(void)totalAddition:(id)object
{
	if ([object respondsToSelector:@selector(length)]) {
		
		NSString *aStr = (NSString *)object;
		total += [aStr intValue];
		
	}
}

-(void)setDataIntoArray:(FindItemModel *)itemObject
{
	
//	if (tableData == nil) {
//		
//		tableData = [[NSMutableArray alloc] init];
//		
//	}
//	int i = arc4random() % 11;  //reemplazo
//	
//	if (i < 0) {
//		
//		i *= -1;
//		
//	}
//	
//
//	NSString* path = [[NSBundle mainBundle] pathForResource:@"Images"
//										   ofType:@"plist"];
//	NSArray* allProducts = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Products"];
//	NSString *imageName = [allProducts objectAtIndex:i];
//	
//	NSDictionary *aDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//						  itemObject.description, @"Text",
//						  itemObject.barCode, @"DetailText",
//						  [UIImage imageNamed:imageName], @"Image", 
//						  itemObject.price, @"Price",nil];
//	
//	[tableData addObject:aDic];
//	[aDic release];
	[aTableView reloadData];
	
	if ([productList count] >= 1) {
		
		//[self turnOffEditing];
		[btnPay setHidden:NO];
		
	}
}

-(void)reloadTableViewWithData:(NSMutableArray *)pList
{
    productList = pList;
    [aTableView reloadData];
	if ([productList count] >= 1) {
		[btnPay setHidden:NO];
	}
    NSLog(@"Hdden %i",btnPay.hidden);
}



//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS
-(void) startRequest:(NSString*) barCode
{
	//*** find item request code ***/
    [Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
    NSString  *terminal=[Session getTerminal];
    warrantiesEnabled = [NSNumber numberWithBool:YES];
	NSArray *pars=[NSArray arrayWithObjects:barCode,@"",terminal,warrantiesEnabled,nil];
	[liverPoolRequest sendRequest:@"buscaProducto" forParameters:pars forRequestType:findRequest]; //cambiar a localized string
	[liverPoolRequest release];
    
    //stop the reading
    //[scanDevice disconnect];
    [scanDevice removeDelegate:self];

}
-(void) startRequestWithPrice:(NSString*) barCode :(NSString*) price
{
	//*** find item request code ***/
    [Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
    NSString  *terminal=[Session getTerminal];
	NSArray *pars=[NSArray arrayWithObjects:barCode,price,terminal,nil];
	[liverPoolRequest sendRequest:@"buscaProducto" forParameters:pars forRequestType:findRequest]; //cambiar a localized string
	[liverPoolRequest release];
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
    //reconnect the device
   // [scanDevice connect];
    [scanDevice addDelegate:self];

    if (requestType==findRequest)
        [self findItemRequestParsing:receivedData];
    if (requestType==SOMSListRequest) 
        [self somsItemsRequestParsing:receivedData];
    if (requestType==restaurantListRequest)
        [self comandaItemsRequestParsing:receivedData];
}

-(void) findItemRequestParsing:(NSData*) data
{
	FindItemParser *findParser=[[FindItemParser alloc] init];
	DLog(@"antes de empezar");
	[findParser startParser:data];
	DLog(@"termino");
	FindItemModel *findItemModel=findParser.findItemModel;
    NSLog(@"Find warranty %@",findItemModel.warranty);
    findItemModel.itemForGift=[Session getIsTicketGift];
    DLog(@"finditemparsing item state %i",[Session getIsTicketGift]);
	if ([findItemModel.description isEqualToString:@"No encontrado"] ) {
        [scanDevice removeDelegate:self];
		[Tools displayAlert:@"Error" message:@"Articulo no encontrado" withDelegate:self];
	}else {
		
		if (productList == nil) {
			productList = [[NSMutableArray alloc] init];
		}
        if ([findParser.warrantiesList count]>0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSelectedWarranty:) name:WARRANTYSELECTED_NOTIFICATION object:nil];
            WarrantyViewController *warrantyVC = [[WarrantyViewController alloc] initWithNibName:@"WarrantyViewController" bundle:nil];
            [warrantyVC setWarrantiesList:findParser.warrantiesList];
            [self presentViewController:warrantyVC animated:YES completion:nil];
        }
        if ([self isValidSKU:findItemModel]) {
            [productList addObject:findItemModel];
            [self applyPromotionsToProducts:findItemModel];
            //[self isSKUSameSection:findItemModel];
            [self setDataIntoArray:findItemModel];
        }
	}
	
	[findParser release];
	[Tools stopActivityIndicator];
}

-(void) somsItemsRequestParsing:(NSData*) data
{
    SomsListParser *somsParser=[[SomsListParser alloc] init];
	[somsParser startParser:data];
	
	//if the transaction was succesful.
	if ([somsParser getStateOfMessage]) {
		[productList release];
		DLog (@"sucess sale payparser */*/*/*");
		productList=[somsParser returnSaleProductList];
        [productList retain];
		DLog (@"sucess sale payparser productListWithPromos %@",productList);
        
        
        for (FindItemModel *item  in productList) {
            [self setDataIntoArray:item];
        }
	}
	else 
	{
        [scanDevice removeDelegate:self];
		[Tools displayAlert:@"Error" message:[somsParser getMessageResponse] withDelegate:self];
	
	}
	[aTableView reloadData];
	[Tools stopActivityIndicator];
	[somsParser release];
}
-(void) startSOMSRequest
{
    if ([[Session getSomsOrder] isEqualToString:@""]) 
        return;
    
	//*** SOMS request code ***/
    [Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
    NSString  *somsOrder=[Session getSomsOrder];
    
    //SELLER
    //seller object
    Seller *seller=[[Seller alloc] init];
    seller.password=[Session getPassword];
    seller.userName=[Session getUserName];

    //Account employee
	NSString *accountEmployee=[Session getEmployeeAccount];

	DLog(@"accountemployee %@",accountEmployee);
    
	NSArray *pars=[NSArray arrayWithObjects:somsOrder,seller,accountEmployee,nil];
	[liverPoolRequest sendRequest:@"listaSOMS" forParameters:pars forRequestType:SOMSListRequest]; 
	[liverPoolRequest release];
    [seller release];
    
}

//**************************************************RESTAURANT******************************************** //
-(void) startComandaRequest
{
    DLog(@"restaurant starcomandarequest2");

    if ([[Session getComandaOrder] isEqualToString:@""])
        return;
    
	//*** SOMS request code ***/
    [Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
    NSString  *comanda=[Session getComandaOrder];
    
    //SELLER
    //seller object
    Seller *seller=[[Seller alloc] init];
    seller.password=[Session getPassword];
    seller.userName=[Session getUserName];
    
	NSArray *pars=[NSArray arrayWithObjects:comanda,seller,nil];
	[liverPoolRequest sendRequest:@"listaAlimentos" forParameters:pars forRequestType:restaurantListRequest]; 
	[liverPoolRequest release];
    [seller release];
    
    //[Session setComandaOrder:@""];
}
-(void) comandaItemsRequestParsing:(NSData*) data
{
    DLog(@"restaurant parser");
    SomsListParser *comandaParser=[[SomsListParser alloc] init];
	[comandaParser startParser:data];
	
	//if the transaction was succesful.
	if ([comandaParser getStateOfMessage]) {
		[productList release];
		DLog (@"sucess sale payparser */*/*/*");
		productList=[NSMutableArray arrayWithArray:[comandaParser returnSaleProductList]];
        [productList retain];
		DLog (@"sucess sale payparser productList %@",productList);
                
        for (FindItemModel *item  in productList) {
            [self setDataIntoArray:item];
        }
	}
	else
	{
        [scanDevice removeDelegate:self];
		[Tools displayAlert:@"Error" message:[comandaParser getMessageResponse] withDelegate:self];
        //return to the previous windows 1.4.5 rev8
        [Session setComandaOrder:@""];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeMainScreen];

	}
	[aTableView reloadData];
	[Tools stopActivityIndicator];
	[comandaParser release];
}

-(void) dealloc
{
    DLog(@"Scanview dealloc");
	[txtSKUManual release],txtSKUManual=nil;
	[textDescription release], textDescription=nil;
	[btnScan release], btnScan=nil;
	[btnPay release], btnPay=nil;
	//[barButtonLeft release],barButtonLeft=nil;
	[barButtonRight release],barButtonRight=nil;
    [barButtonLeft release];
	[aTableView release],aTableView=nil;
	[super dealloc];
}

///********************************************************************************************
-(BOOL) isValidSKU:(id)item
{
    float sku=[item isKindOfClass:[FindItemModel class]] ? [[item barCode] floatValue] : [item isKindOfClass:[Warranty class]] ? [[item sku] floatValue] : 0;
    bool isValid=NO;
    if (sku==0) {
        [scanDevice removeDelegate:self];
        [Tools displayAlert:@"Error" message:@"Articulo no encontrado" withDelegate:self];
        isValid=NO;
    }
    else
        isValid=[self isValidRefundChange:item];
    
    return isValid;
}
//if the transact is a refund type , it can only have two skus and have to be of the same price
-(BOOL) isValidRefundChange:(FindItemModel*) item
{
    FindItemModel *item2=[productList lastObject];
    //6(refund change) is a special transaction when you can only scan two items of the same price
    if ([Session getRefundCauseNumber]==6) {
         if ([productList count]==1) {
            BOOL flag=[Tools compareNumbers:item.price :item2.price];
            if (!flag) {
                [scanDevice removeDelegate:self];
                [Tools displayAlert:@"Error" message:@"Los importes deben ser iguales" withDelegate:self];
            }
            return flag;

        }
        else if ([productList count]>1)
        {    return NO;
            [scanDevice removeDelegate:self];
            [Tools displayAlert:@"Error" message:@"Esta operacion solo acepta dos SKU's" withDelegate:self];

        }
        else
        {
            return YES;
        }
    }
    else
    {
       return YES;
    }

}
-(void) editItemForTransaction:(NSIndexPath*) indexPath
{
    //this method verify is the type of transaction can delete the item in the list
    //FOOD_TYPE can only delete the tips
    //SOMS_TYPE cannot delete the products from the list
    //NORMAL_TYPE & EMPLOYEE_TYPE has not delete restrictions.

    switch ([Session getSaleType]) {
        case SOMS_EMPLOYEE_TYPE:
        case SOMS_CLIENT_TYPE:
        {
            DLog(@"no se puede alterar la lista en la venta de SOMS");
            [Tools displayAlert:@"Error" message:@"Accion no permitida"];
        }
            break;
        case FOOD_CLIENT_TYPE:
        {
            DLog(@"solo se pueden borrar propinas");
            FindItemModel *item=[productList objectAtIndex:indexPath.row];
            if ([item.description isEqualToString:@"Propina"]) {
                [productList removeObjectAtIndex:indexPath.row];
                
                [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                //[self turnOffEditing];
                [aTableView reloadData];
            }
            else
                [Tools displayAlert:@"Error" message:@"Accion no permitida"];
  
        }
            break;
        case REFUND_NORMAL_EMPLOYEE_TYPE:
        case REFUND_NORMAL_TYPE:
        case NORMAL_CLIENT_TYPE:
        case NORMAL_EMPLOYEE_TYPE:
        case DULCERIA_CLIENT_TYPE:
            [productList removeObjectAtIndex:indexPath.row];
            [Session verifyWarrantyPresence:productList];
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            //[self turnOffEditing];
            [aTableView reloadData];
            DLog(@"venta normal sin restricciones de borrado");
            break;
        default:
            DLog(@"no se hace nada");
            break;
    }

}


-(void) applyPromotionsToProducts:(FindItemModel*) aItemWithPromo
{
	DLog(@"applyPromotionsToProducts");
/*
	NSMutableArray *productListCopy=[[[NSMutableArray alloc] initWithArray:productList] autorelease];
	
	//NSMutableArray *productListCopy = [[NSMutableArray alloc] initWithArray:productList copyItems:YES];
	
		if (aItemWithPromo.promo&&[productListCopy count]>0) 
			for (FindItemModel *item in productListCopy) {
				if ([aItemWithPromo.department isEqualToString:[item department]]) {
					[productList replaceObjectAtIndex:[productList indexOfObject:item] withObject:aItemWithPromo];
					DLog(@"se reemplazo promo item!");
				}
			}
	
		else 
			for (FindItemModel *item in productListCopy) {
				if ([aItemWithPromo.department isEqualToString:[item department]]) {
					[productList replaceObjectAtIndex:[productList indexOfObject:aItemWithPromo] withObject:item];
					DLog(@"se reemplazo promo item Nuevo!");
					return;
				}
			}
	*/
}
//----------------------------------------
//            ALERTVIEW DELEGATE
//----------------------------------------


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"alertviewdelegate");
    if (buttonIndex == 0)
    {
        //Code for OK button
        [scanDevice addDelegate:self];
    }
    if (buttonIndex == 1)
    {
        //Code for download button
    }
}
//----------------------------------------
//            TEXTFIEL DELEGATE
//----------------------------------------

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; 
	
	CGPoint textFieldCord=textField.center;
	
	CGRect viewCords=self.view.frame;
	
	viewCords.origin.y=viewCords.origin.y-textFieldCord.y+140;
	
	self.view.frame=viewCords;
    [UIView commitAnimations];
	
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
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	
}

#pragma mark - WarrantySelectionDelegate
-(void)didReceiveSelectedWarranty:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WARRANTYSELECTED_NOTIFICATION object:nil];
    NSLog(@"Did receive notification warranty");
    FindItemModel *findItem = [productList lastObject];
    Warranty *warranty = (Warranty *)[notification object];
    findItem.warranty = warranty;
    NSLog(@"Find item war %@",findItem.warranty.cost);
    [productList addObject:warranty];
    [Session verifyWarrantyPresence:productList];
    [self setDataIntoArray:nil];
}
@end

