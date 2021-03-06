//
//  PromotionInstallmentViewController.m
//  CardReader

#import "PromotionInstallmentViewController.h"
#import "CardReaderAppDelegate.h"
#import "Styles.h"
#import "Tools.h"
#import "Session.h"
@implementation PromotionInstallmentViewController
@synthesize installmentArray,aTableView,lblBg,lblPromoName,lblPromoPrice,promo;
@synthesize lblPromoDiscount,lblPromoFinalPrice,lblDescription,btnReturn;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	aTableView.backgroundColor =[UIColor clearColor];
	[Styles bgGradientColorPurple:self.view];
	[Styles purpleLabelBackground:lblPromoName];
	
	[Styles purpleLabelBackground:lblPromoPrice];
	[Styles purpleLabelBackground:lblPromoDiscount];
	[Styles purpleLabelBackground:lblPromoFinalPrice];
	
	[Styles purpleLabelBackground:lblDescription];
	[Styles cornerView:lblBg];
	[Styles silverButtonStyle:btnReturn];
	/*[Styles cornerView:lblBg];
	[Styles cornerView:lblPromoName];
	[Styles cornerView:lblPromoPrice];
	[Styles cornerView:lblPromoDiscount];
	[Styles cornerView:lblPromoFinalPrice];*/

	[self showPromoDescription];
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) showPromoDescription
{
	if ([promo.promoTypeBenefit isEqualToString:@"factorLoyaltyBenefit"]) {
		
		float base=[promo.promoBaseAmount floatValue];
		float disc=[promo.promoValue floatValue];
		float total=base-disc;
		
		NSString *discount=[NSString stringWithFormat:@"%.2f",total];
		NSString *promoValue=[Tools calculateDiscountValuePercentage:promo.promoBaseAmount :promo.promoDiscountPercent];
		
		if ([promo.promoDescription length]>0)
			lblPromoName.text=promo.promoDescription;
		else 
			lblPromoName.text=promo.promoDescriptionPrinter;

		lblPromoPrice.text=[Tools amountCurrencyFormat:promo.promoBaseAmount];
		lblPromoDiscount.text=[Tools amountCurrencyFormat: promoValue];
		lblPromoFinalPrice.text=[Tools amountCurrencyFormat:discount];
	}
	else {
	
		float base=[promo.promoBaseAmount floatValue];
		float disc=[promo.promoValue floatValue];
		float total=base-disc;
		
		NSString *discount=[NSString stringWithFormat:@"%.2f",total];
		
		if ([promo.promoDescription length]>0)
			lblPromoName.text=promo.promoDescription;
		else 
			lblPromoName.text=promo.promoDescriptionPrinter;
		
		lblPromoPrice.text=[Tools amountCurrencyFormat: promo.promoBaseAmount];
		lblPromoDiscount.text=[Tools amountCurrencyFormat:promo.promoValue];
		lblPromoFinalPrice.text=[Tools amountCurrencyFormat: discount];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [installmentArray count];
}


// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView 
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:@"Cell"]autorelease];
	}else{//MPSA
        for (UIView* subview in [cell.contentView subviews]) {
			// if (subview.tag!=0) {
			[subview removeFromSuperview];
            //}
        }
    }
	cell.textLabel.textColor=[UIColor whiteColor];
	cell.textLabel.backgroundColor=[UIColor clearColor];
	[cell.textLabel setText:[installmentArray objectAtIndex:indexPath.row]];
	//cell.textLabel.textAlignment = UITextAlignmentCenter;
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];

	
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */

	promo.promoInstallmentSelected=[[installmentArray objectAtIndex:indexPath.row] copy];
	[Session setPlanId:promo.planId];
	[Session setPlanInstallment:promo.promoInstallmentSelected];
	[Session setPlanDescription:promo.promoDescription];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeInstallmentsScreen];
    
  
//remove view method
	
}
//----------------------------------------
//            UTILITY METHODS
//----------------------------------------

//  separates the values contained in the installment string of the item, creates an array 
// and load it as its data source, then is showed in the tableview
-(void) showInstallmentsTable
{
	NSString *instString=promo.promoInstallment;
	installmentArray=[instString componentsSeparatedByString:@","];
	[installmentArray retain];
	DLog(@"installment array values: %@",installmentArray);
	[aTableView reloadData];
}

-(IBAction) goBack
{
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removePromoScreen];

}


//-------------------------GENERIC VIEW DELEGATE---------
-(void) performAction:(NSString*) txtData : (ActionType) actionType{
    
    [Session setMonederoNumber:txtData];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removePaymentPlanScreen];
}

//patch 1.4.5 you cant continue if you cancel the monedero reading.
//canceling the reading take you back to the scanview
-(void) performExitAction
{
    [Session setMonederoNumber:@""];
    [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeScreensToSaleView];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
	DLog(@"dealloc promotion installmentview");

    
	[aTableView release]; aTableView=nil;
	[lblBg release];
	[installmentArray release];
	[lblPromoName release];
	[lblPromoPrice release];
	[lblPromoDiscount release];
	[lblPromoFinalPrice release];
	[lblDescription release], lblDescription = nil;
	[btnReturn release], btnReturn = nil;
	
	[super dealloc];
}


@end

