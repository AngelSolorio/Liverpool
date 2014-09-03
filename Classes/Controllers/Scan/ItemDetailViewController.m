//
//  ItemDetailViewController.m
//  CardReader
//


#import "ItemDetailViewController.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"
#import "Promotions.h"
#import "Tools.h"
#import "ProjectConstants.h"

@implementation ItemDetailViewController
@synthesize aTableView;
@synthesize lblOriginalPrice;
@synthesize btnQuantity;
@synthesize lblProductName,lblBarcode,lblPrice,lblDepartment,lblBgDepartment,lblBgDiscount;
@synthesize btnDiscount,btnPromotions,itemModel,lblDiscount,lblBackground,btnGift;
@synthesize scrollView,lblQuantity,lblBgModifiers;
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
	//testArray=[NSMutableArray arrayWithObjects:@"Promocion verano 20%",@"Venta Nocturna 10%",@"Promocion por tecla 5%",nil];
	//[testArray retain];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    [[self navigationController] setNavigationBarHidden:NO];
	self.title=@"Producto";
	//[Styles bgGradientColorPurple:scrollView];
	[Styles cornerView:lblBgDiscount];
	[Styles cornerView:lblBgDepartment];
    [Styles cornerView:lblBgModifiers];
    
    //[Styles cornerView:self.view];
    
	/*[Styles cornerView:lblProductName];
     [Styles cornerView:lblBarcode];
     [Styles cornerView:lblPrice];
     [Styles cornerView:lblDepartment];*/
	
	[Styles purpleLabelBackground:lblProductName];
	[Styles purpleLabelBackground:lblBarcode];
	[Styles purpleLabelBackground:lblPrice];
	[Styles purpleLabelBackground:lblDepartment];
	[Styles purpleLabelBackground:lblBgDiscount];
	[Styles purpleLabelBackground:lblDiscount];
    [Styles purpleLabelBackground:lblQuantity];
	[Styles cornerView:lblBackground];
	
    [scrollView setContentSize:CGSizeMake(320, 720)];
    
    [super viewDidLoad];

}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}
-(void) viewDidAppear:(BOOL)animated{
    DLog(@"itemmodel discounts %i",[[itemModel discounts] count]);
    [self displayItemInfo:itemModel];
    [super viewDidAppear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


//----------------------------------------
//            TABLE VIEW MANAGEMENT
//----------------------------------------
#pragma mark -
#pragma mark TABLE VIEW MANAGEMENT
//-(NSString *)tableView:(UITableView *)tableView
//titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return NSLocalizedString(@"¿Borrar?", @"Erase confirmation");
//}
-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"draw cells detailvie");
    static NSString *simpleTableIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
   	
	Promotions *promo=[itemModel.discounts objectAtIndex:indexPath.row];
	NSString *discountDescription;
    NSString *discountPercentage;
    NSString *discountValue;
	if ([promo.promoDiscountPercent length]!=0)
		if (promo.promoType==3) //promo % discount
            {
                discountDescription=promo.promoDescription;
                discountPercentage=[NSString stringWithFormat:@"%@ %%",promo.promoDiscountPercent];
                discountValue=[NSString stringWithFormat:@"-%@",[Tools amountCurrencyFormat:[promo promoValue]]];
            }
    if (promo.promoType==4)  //promo $ fixed amount
            {
                discountDescription=promo.promoDescription;
                discountPercentage=@"$";
                discountValue=[NSString stringWithFormat:@"-%@",[Tools amountCurrencyFormat:[promo promoDiscountPercent]]];
            }
//	else
//		//promos already have the number of mounts ALERT
//		//discountDescription=[NSString stringWithFormat:@"%@ MESES %@",promo.promoInstallmentSelected,promo.promoDescription];
//		if ([promo.promoDescription length]>0)
//		{	discountDescription=[NSString stringWithFormat:@"%@",promo.promoDescription];
//            
//        }
//		else
//		{	discountDescription=[NSString stringWithFormat:@"%@",promo.promoDescriptionPrinter];
//            
//        }
    
    
	//[cell.textLabel setText:discountDescription];
        [[cell lblType]setText:discountDescription];
        [[cell lblAmount]setText:@""];
        [[cell lblQuantity]setText:discountPercentage];
        [[cell lblTotal]setText:discountValue];
    
	return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellImage;
	NSString *cellImageSelected;
    // first cell check
    if ([indexPath length]==1) {
        cellImage=@"oneCell.png";
        cellImageSelected=@"oneCell.ong";
    }
    else if (indexPath.row == 0) {
        cellImage=@"topTable.png";
        cellImageSelected=@"topTable.png";
        
    }
    // last cell check
    else if (indexPath.row ==[aTableView numberOfRowsInSection:indexPath.section] - 1) {
        cellImage=@"bottomTable.png";
        cellImageSelected=@"bottomTable.png";
        // middle cells
    } else {
        cellImage=@"middleTable1.png";
        cellImageSelected=@"bottomTable.png";
    }
    
    UIImageView *backgroundNormal;
    UIImageView *backgroundSelected;
    
    backgroundNormal = [[UIImageView alloc] initWithImage:
                        [UIImage imageNamed:cellImage]];
    
    backgroundSelected = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:cellImageSelected]];
    
    [cell setBackgroundView:backgroundNormal];
    [cell setSelectedBackgroundView:backgroundSelected];
    
    [backgroundNormal release];
    [backgroundSelected release];
    
    //    UIImage *imageNormal = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:cellImage ofType:@"png"]] ;
    //    cell.backgroundView = [[[UIImageView alloc] init] autorelease];
    //    ((UIImageView *)cell.backgroundView).image = imageNormal;
    //    ((UIImageView *)cell.backgroundView).clipsToBounds=YES;
    //    //[Styles cornerView:((UIImageView *)cell.backgroundView)];
    //
    //    UIImage *imageSelected = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:cellImageSelected ofType:@"png"]] ;
    //    cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
    //    ((UIImageView *)cell.selectedBackgroundView).image = imageSelected;
    //    ((UIImageView *)cell.selectedBackgroundView).clipsToBounds = YES;
    //    //[Styles cornerView:((UIImageView *)cell.selectedBackgroundView)];
    //    
    
}


-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    DLog(@"[itemModel.discounts count] #%d",[itemModel.discounts count]);
	return [itemModel.discounts count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35;
}
//-(void)tableView:(UITableView *)tableView
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	if (editingStyle == UITableViewCellEditingStyleDelete) {
//		
//		[itemModel.discounts removeObjectAtIndex:indexPath.row];
//		
//		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//						 withRowAnimation:UITableViewRowAnimationFade];
//		[tableView reloadData];
//		
//		if ([itemModel.discounts count]>0)
//			[self displayItemInfo:itemModel];
//		else
//			lblDiscount.text=@"";
//	}
//	
//	if ([tableView numberOfRowsInSection:indexPath.section] == 0) {
//        
//		itemModel.promo=FALSE;
//	}
//	
//}


-(void) displayItemInfo:(FindItemModel*) item
{

	itemModel=item;
    [lblOriginalPrice setText:[Tools amountCurrencyFormat:itemModel.price]];
	lblPrice.text=[Tools amountCurrencyFormat:itemModel.price];
	lblBarcode.text=itemModel.barCode ;
	lblProductName.text=itemModel.description ;
	lblDepartment.text=itemModel.department;
    lblQuantity.text=itemModel.itemCount;
	[btnGift setSelected:itemModel.itemForGift];
	if ([itemModel.discounts count]>0) {
		
		if ([[itemModel.discounts objectAtIndex:0] promoType]==3) {
			lblDiscount.text=[[itemModel.discounts objectAtIndex:0] promoDiscountPercent];
            
		}
		if ([[itemModel.discounts objectAtIndex:0] promoType]==4) {
			lblDiscount.text=[[itemModel.discounts objectAtIndex:0] promoDiscountPercent];
			
		}
	}
    //[aTableView setFrame:CGRectMake(0, 0, 280, 280)];
    [aTableView setFrame:CGRectMake(20, 320, 280, 100)];
    
    [aTableView reloadData];
    [btnQuantity setExclusiveTouch:YES];

}
-(IBAction) promotionScreen
{
	//[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) itemPromotionScreen:itemModel];
    
}
-(IBAction) manualDiscountScreen
{
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) itemDiscountScreen:itemModel];
    
}
-(IBAction) itemForGift:(id)sender
{
    itemModel.itemForGift=itemModel.itemForGift==TRUE?FALSE:TRUE;
    [btnGift setSelected:itemModel.itemForGift];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeDiscountScreen];
    
}

-(IBAction) setQuantityForItem:(id)sender{
    DLog(@"ASDASDASDASDASDASD");
    GenericDialogViewController *dialog=[[GenericDialogViewController alloc]initWithNibName:@"GenericDialogViewController" bundle:nil];
    // [self presentModalViewController:dialog animated:YES];
    [self presentViewController:dialog animated:YES completion:nil];
    
    [dialog release];
    [dialog initView:@"Favor de introducir la cantidad del producto" :itemOptionsQuantity:NO];
    dialog.title=@"Cantidad de Producto";
    dialog.delegate=self;
    
    
    //you cannot set the quantity with a price modifier, therefore the modifier must be reset
}
-(IBAction) setModifierForItem:(id)sender
{
    GenericDialogViewController *dialog=[[GenericDialogViewController alloc]initWithNibName:@"GenericDialogViewController" bundle:nil];
    //[self presentModalViewController:dialog animated:YES];
    [self presentViewController:dialog animated:YES completion:nil];
    
    [dialog release];
    [dialog initView:@"Favor de introducir el decimal" :itemOptionsModifier:NO];
    dialog.title=@"Precio por decimal";
    dialog.delegate=self;
    
    //you cannot set the price modifiear with quantity, therefore the quantity must be reset to 1
    //   itemModel.itemCount=@"1";
    
}
//-------------------------DELEGATE
-(void) performAction:(NSString*) txtData : (ActionType) actionType
{
    //verify the input data
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setMaximumFractionDigits:2];
    [f setRoundingMode: NSNumberFormatterRoundUp];
    
    NSNumber * myNumber = [f numberFromString:txtData];
    
    if (myNumber==nil) {
        [Tools displayAlert:@"Error" message:@"Debe introducir una cantidad valida"];
        return;
    }
    
    if (actionType==itemOptionsQuantity) {
        if ([txtData isEqualToString:@""]||[myNumber isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [Tools displayAlert:@"Error" message:@"Debe introducir una cantidad valida"];
        }
        else {
            
            itemModel.itemCount=[f stringFromNumber:myNumber];
            itemModel.priceExtended=[[Tools calculateQuantityExtendedPrice:itemModel] copy];
            [Tools calculateSuccesiveDiscounts:itemModel];
            DLog(@"precio extendido :%@",[itemModel priceExtended]);
            [self dismissViewControllerAnimated:YES completion:nil];
            [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeDiscountScreen];
            DLog(@"ok valor de modificador");
        }
    }
    /*if (actionType==itemOptionsModifier) {
     if ([txtData isEqualToString:@""]||[myNumber isEqualToNumber:[NSNumber numberWithInt:0]]) {
     [Tools displayAlert:@"Error" message:@"Debe introducir un decimal valido"];
     }
     else {
     //the price must be calculated by the decimal modifier input
     float decimal=[txtData floatValue];
     decimal=decimal/100;
     
     itemModel.itemCount=[[NSString stringWithFormat:@"%.02f", decimal] copy];
     itemModel.priceExtended=[[Tools calculateQuantityExtendedPrice:itemModel] copy];
     
     DLog(@"modifier item.count:%@",itemModel.itemCount);
     DLog(@"modifier extendedPrice:%@",itemModel.priceExtended);
     DLog(@"modifier Price:%@",itemModel.price);
     
     [self dismissModalViewControllerAnimated:YES];
     
     }
     }*/
    [f release];
    
}
-(void) performExitAction
{
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
- (void)dealloc {
    [lblBgModifiers release], lblBgModifiers=nil;
    [lblQuantity release], lblQuantity=nil;
    [scrollView release], scrollView=nil;
    [btnGift release], btnGift=nil;
	[lblProductName release];lblProductName=nil;
	[lblBarcode release];lblBarcode=nil;
	[lblPrice release];lblPrice=nil;
	[lblDepartment release];lblDepartment=nil;
	[lblBgDepartment release];lblBgDepartment=nil;
    [lblBgDiscount release];lblBgDiscount=nil;
	[btnDiscount release]; btnDiscount=nil;
	[btnPromotions release];btnPromotions=nil;
	[lblDiscount release]; lblDiscount=nil;
	itemModel =nil;
	[lblBackground release], lblBackground = nil;
	[super dealloc];
}


@end
