//
//  PaymentPlanViewController.m
//  CardReader
//


#import "PaymentPlanViewController.h"
#import "Promotions.h"
#import "Styles.h"
#import "CardReaderAppDelegate.h"

@implementation PaymentPlanViewController
@synthesize filteredPlanGroup;
@synthesize promotionGroup;
@synthesize aTableView;
@synthesize payView;


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
	DLog(@"PAYMENTPLANVIEWCONTROLLER :%@",filteredPlanGroup);
    [super viewDidLoad];
	
	[filteredPlanGroup addObject:@"PRESUPUESTO"];
    
    if ([filteredPlanGroup count]<=1) {
        [self hasMonederoPromotion];
    }else{
       	[aTableView reloadData];
        [Styles bgGradientColorPurple:self.view];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:NO]; 

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
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	
	
	if ([[filteredPlanGroup objectAtIndex:indexPath.row] isKindOfClass:[Promotions class]]) { 
		Promotions *promo=[filteredPlanGroup objectAtIndex:indexPath.row];
		
		if ([[promo promoDescription]length]==0) 
		{	NSString* description=[promo.promoDescriptionPrinter copy];
			
			description=[description stringByAppendingFormat:@" %@",([promo.promoBank length]>0 ? promo.promoBank : @"")];
			[cell.textLabel setText:description];
		}
		else  
		{	NSString* description=[promo.promoDescription copy];
			description=[description stringByAppendingFormat:@" %@",([promo.promoBank length]>0 ? promo.promoBank : @"")];
			[cell.textLabel setText:description];
		}		[cell setUserInteractionEnabled:YES];
		
	}
	else { 
		NSString* description=[filteredPlanGroup objectAtIndex:indexPath.row];
		[cell.textLabel setText:description];
	}

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
    else if (indexPath.row ==[tableView numberOfRowsInSection:indexPath.section] - 1) {
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
- (NSInteger)tableView:(UITableView *)table
 numberOfRowsInSection:(NSInteger)section {
	return [filteredPlanGroup count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	 //select a promotion from the list and save it.
	 promotionIndex=[indexPath copy];  // Ruben
	
	// Cambio Ruben - 18/enero/2012
	
	if (indexPath.row == [filteredPlanGroup indexOfObject:[filteredPlanGroup lastObject]]) {
		DLog(@"Se eligio la ultima opcion");
        [self hasMonederoPromotion];
	}
	else {
		[self isPromoWithInstallment];
	}
	
}

//if the promo has installments, show the next view 
-(void) isPromoWithInstallment
{
	Promotions *promo=[filteredPlanGroup objectAtIndex:promotionIndex.row];
	DLog(@"Promoinstallment: %@",promo.promoInstallment);
	DLog(@"promotionGroup add %@",promotionGroup);
	[promotionGroup addObject:promo];
   
    NSString *instString=promo.promoInstallment;
    NSArray  *installmentArray=[instString componentsSeparatedByString:@","];
    [installmentArray retain];

    //if there is only one installment auto select it 
    if ([installmentArray count]==1)
    {
        promo.promoInstallmentSelected=[[installmentArray objectAtIndex:0] copy];
        [Session setPlanId:promo.planId];
        [Session setPlanInstallment:promo.promoInstallmentSelected];
        [Session setPlanDescription:promo.promoDescription];
        
        //if the sale had a monedero and is not paying with the same monedero, it have to wait to read the monedero before calling the payment request
        [self hasMonederoPromotion];
        
    }
	//patch 1.4.5 
    else if ([promo.promoInstallment length]>1)
    {
        //[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) installmentsScreen:promo];

        GenericOptionsViewController *optionsView=[[GenericOptionsViewController alloc]initWithNibName:@"GenericOptionsViewController" bundle:nil];
        [self presentViewController:optionsView animated:NO completion:nil];
        [optionsView release];
  
        
        DLog(@"installment array values: %@",installmentArray);
        optionsView.optionsArray=installmentArray;
        optionsView.title=@"Plan de Pago";
        optionsView.delegate=self;
    }
    else //has no installments
		[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) promoScreen:promo];
    

}

//check is the promotion group has a monedero promotion
//TRUE: calls the monederoView to read the monedero number
//FALSE:start the payment request and remove the present view
-(void) hasMonederoPromotion
{
    //if the sale had a monedero and is not paying with the same monedero, it have to wait to read the monedero before calling the payment request
    if([Tools isMonederoPromotion:promotionGroup]&&[[Session getMonederoNumber] length]==0)
    {
        DLog(@"Tiene monedero");
        GenericDialogViewController *monederoView=[[GenericDialogViewController alloc]initWithNibName:@"GenericDialogViewController" bundle:nil];
        [self presentViewController:monederoView animated:NO completion:nil];
        //[aNavigationControllerLogin pushViewController:promoInstallment animated:YES];
        
        [monederoView release];
        [monederoView initView:@"Escanee el monedero" :monederoRead :YES];
        monederoView.title=@"Numero de cuenta a emitir";
        monederoView.delegate=self;
    }else
    {
        //start request
        [payView startRequest];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removePaymentPlanScreen];
        
    }
    
}

//-------------------------GENERIC VIEW DELEGATE---------
-(void) performAction:(NSString*) txtData : (ActionType) actionType{

    if ([txtData length]>0 && [txtData length]<=13) {
        [Session setMonederoNumber:txtData];
        //start request
        [payView startRequest];
        [self dismissViewControllerAnimated:YES completion:nil];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removePaymentPlanScreen];

    }
    else{
        [Tools displayAlert:@"Aviso" message:@"Favor de introducir el monedero"];
        
    }
    
}

//patch 1.4.5 you cant continue if you cancel the monedero reading.
//canceling the reading take you back to the scanview
-(void) performExitAction
{
    [Session setMonederoNumber:@""];
    [self dismissViewControllerAnimated:NO completion:nil];
    [payView dismissSelfToLogin];//void the payment if there is one
    //[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeScreensToSaleView];
}


//genericOption
-(void) performOptionAction:(int) index :(NSString*) value
{
    DLog(@"performOptionAction %i %@",index,value);
    
    Promotions *promo=[filteredPlanGroup objectAtIndex:promotionIndex.row];
    promo.promoInstallmentSelected=[value copy];
	[Session setPlanId:promo.planId];
	[Session setPlanInstallment:promo.promoInstallmentSelected];
	[Session setPlanDescription:promo.promoDescription];

    
    DLog(@"setPlanId %@",promo.planId);
    DLog(@"setPlanInstallment %@",promo.promoInstallmentSelected);
    DLog(@"setPlanDescription %@",promo.promoDescription);
    
    //if the sale had a monedero and is not paying with the same monedero, it have to wait to read the monedero before calling the payment request
    [self hasMonederoPromotion];
}


//if the promo has installments, show the next view
//-(void) isPromoWithInstallment
//{
//	Promotions *promo=[filteredPlanGroup objectAtIndex:promotionIndex.row];
//	DLog(@"Promoinstallment: %@",promo.promoInstallment);
//	DLog(@"promotionGroup add %@",promotionGroup);
//	[promotionGroup addObject:promo];
//	if ([promo.promoInstallment length]>1)
//		[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) installmentsScreen:promo];
//	//patch 1.4.5 auto select if the promotion is a fixed month payment
//    
//    else
//		[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) promoScreen:promo];
//	
//}
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
//

- (void)dealloc {
	DLog(@"dealloc paymentplanview");
	//[filteredPlanGroup release];
	[aTableView release];aTableView=nil;
    [super dealloc];
}


@end
