//
//  ItemDiscountsViewController.m
//  CardReader
//

#import "ItemDiscountsViewController.h"
#import "Styles.h"
#import "FindItemModel.h"
#import "Tools.h"
#import "Promotions.h"
#import "PromotionListParser.h"
#import "CardReaderAppDelegate.h"
#import "MonederoCardViewController.h"
#import "Session.h"
#import "PaymentViewController.h"
#import "Seller.h"
@implementation ItemDiscountsViewController
@synthesize aTableView,btnOk,txtDiscount,ctrlFixedDiscounts,itemModel,ctrlDiscountType,lblSign;
@synthesize productList;
@synthesize txtOption;
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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
	aTableView.backgroundColor=[UIColor clearColor];
	[Styles bgGradientColorPurple:self.view];
	[Styles cornerView:txtDiscount];
	[Styles silverButtonStyle:btnOk];
	
	[ctrlDiscountType setSelectedSegmentIndex:0];
	txtDiscount.inputAccessoryView=[Tools inputAccessoryView:txtDiscount];
    
  

}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
	
	[super viewWillDisappear:animated];
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
	cell.selectionStyle=UITableViewCellSelectionStyleNone;//
	NSArray* optionArray=[testArrayDisplay objectAtIndex:indexPath.section];
	promotionIndex=[indexPath copy]; //rev 8
    
	Promotions *promo=[optionArray objectAtIndex:indexPath.row];
	NSString *cellInfo=[self displayPromoInfoCell:promo];
    [cell.textLabel setText:cellInfo];
    [cell setUserInteractionEnabled:YES];
    
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
    

}
-(NSString*) displayPromoInfoCell :(Promotions*) promo
{
    NSString *description;
    //employee discount or normal discount
    
    if ([promo.promoTypeBenefit isEqualToString:@"percentageDiscount"]) {
        
        if ([[promo promoDescription]isEqualToString:@"ADICIONAL DILISA"]) {
            description=@"";
            description=[description stringByAppendingFormat:@"%@%% DESC x PROM DILISA/LPC",[promo promoDiscountPercent]];
            //setting the extended discount for lpc/dilisa special promo
            promo.extraPercentagePromo=2;
        }
        else if ([[promo promoDescriptionPrinter]isEqualToString:@"DESC. CASA"]){
                //if DESC CASA search for other % discount
                //patch 1.4.5 rev8 tentative promo, rule #2 if there is a previous discount "DESC CASA" default to 10%.
                NSMutableArray* optionArray=[testArrayDisplay objectAtIndex:promotionIndex.section];
                if ([Tools isDiscountPromotionInGroup:optionArray]) {
                    promo.promoDiscountPercent=@"10.00";
                    DLog(@"DESCUENTO---- promo.promoBaseAmount %@ : promo.promoDiscountPercent %@",promo.promoBaseAmount,promo.promoDiscountPercent);
                }
                //---
        }
        description =@"DESCUENTO ";
        NSString*porcentaje= [Tools calculateDiscountValuePercentage:promo.promoBaseAmount :promo.promoDiscountPercent];
        porcentaje=[Tools amountCurrencyFormat:porcentaje];
        description=[description stringByAppendingString:porcentaje];
    }
    //monedero
    //1.4.5 rev8 check if there is special rule for extra monedero
    else if ([promo.promoTypeBenefit isEqualToString:@"factorLoyaltyBenefit"]) {
        
        if ([[promo promoDescription]isEqualToString:@"5% Recarga Monedero"]) {
            description=@"";
            description=[description stringByAppendingFormat:@"%@%% MONEDERO CON DILISA/LPC",[promo promoDiscountPercent]];
            
            //setting the extended discount for lpc/dilisa special promo
            promo.extraPercentagePromo=1;
            NSMutableArray* optionArray=[testArrayDisplay objectAtIndex:promotionIndex.section];
            [Tools addExtraMonedero:optionArray:promo.promoDiscountPercent];
            //------
        }
        else{
            description =@"MONEDERO ";
            NSString*porcentaje= [Tools calculateDiscountValuePercentage:promo.promoBaseAmount :promo.promoDiscountPercent];
            porcentaje=[Tools amountCurrencyFormat:porcentaje];
            description=[description stringByAppendingString:porcentaje];
        }
    }
    else {
        description=([promo.promoDescription length]>0? [promo.promoDescription copy]: [promo.promoDescriptionPrinter copy]);
        description=[description stringByAppendingFormat:@" %@",([promo.promoBank length]>0 ? promo.promoBank : @"")];
    }
   
    return description;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [testArrayDisplay count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, -30, 300.0, 44.0)] autorelease];
	
	// create the button object
	UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	NSString *optionTitle = [[[NSString alloc] init] autorelease];
	optionTitle=[optionTitle stringByAppendingFormat:@"Seleccionar grupo de promocion %i",section+1];
	
	headerLabel.text = optionTitle;
	[customView addSubview:headerLabel];
    
    NSMutableArray *optionArray=[testArrayDisplay objectAtIndex:section];
    if ([optionArray count]==0) 
        customView=nil;
    
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 44.0;
}

- (NSInteger)tableView:(UITableView *)table
numberOfRowsInSection:(NSInteger)section {
	NSMutableArray *optionArray=[testArrayDisplay objectAtIndex:section];
	return [optionArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	promotionIndex=[indexPath copy];
	DLog(@"Section selected :%i",indexPath.section);
	promotionGroupSelected=[[testArray objectAtIndex:indexPath.section]copy];
	DLog(@"promotionGroupSelected %@",promotionGroupSelected);
    DLog(@"promotionGroupSelected testarray %@",[testArray objectAtIndex:indexPath.section]);
    DLog(@"promotionGroupSelected testarraydisplay %@",[testArrayDisplay objectAtIndex:indexPath.section]);

	[Session setIndexPromoGroup:indexPath.section];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) paymentScreen:productList :promotionGroupSelected];
	
	
	/*DLog(@"Pay items");
	 PaymentViewController *pay = [[PaymentViewController alloc] init];
	 [self presentModalViewController:pay
	 animated:YES];
	 [pay release];
	 
	 DLog(@"payment retain:%i",[pay retainCount]);
	 [pay setProductList:productList];
	[pay setPromotionGroupSelected:promotionGroupSelected];*/
}

//----------------------------------------
//            TEXT FIELD MANAGEMENT
//----------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([self isValidDiscount:textField]) {
		[textField resignFirstResponder];
		return YES;
	}
	else {
		[Tools displayAlert:@"Error" message:@"Descuento No Valido"];
		return NO;
	}
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self isValidDiscount:textField];

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self isValidDiscount:textField];
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([Tools isValidNumber:string]) 
		 if ([textField.text length]<10 ||[string isEqualToString:@""])
			return YES;
		 else 
			return NO;
	else
		 return NO;
}
-(BOOL) isValidDiscount:(UITextField*) discount
{
	if ([[discount text]length]==0) {
        discount.backgroundColor=[UIColor redColor];
        return NO;
    }
    
	int discountValue=[discount.text floatValue];
	if (ctrlDiscountType.selectedSegmentIndex==0){

        if (discountValue>=100)
        {
            discount.backgroundColor=[UIColor redColor];
            return NO;
        }
        else
        {
            discount.backgroundColor=[UIColor whiteColor];
            return YES;
        }
        
    }
	else if (ctrlDiscountType.selectedSegmentIndex==1) 
		if (discountValue>=[itemModel.priceExtended floatValue])
		{
			discount.backgroundColor=[UIColor redColor];
			return NO;
		}
		else
		{
			discount.backgroundColor=[UIColor whiteColor];
			return YES;
		}
	else
		return YES;
}
//----------------------------------------
//            OTHER COMPONENTS
//----------------------------------------



- (IBAction) discountSelected{

	switch ([ctrlFixedDiscounts selectedSegmentIndex]) {
		case 0:
			DLog(@"Descuento 10%%");
			txtDiscount.text=@"10";
			break;
		case 1:
			DLog(@"Descuento 20%%");
			txtDiscount.text=@"20";

			break;
		case 2:
			DLog(@"Descuento 30%%");
			txtDiscount.text=@"30";

			break;
		default:
			break;
	}
}
-(IBAction) savetoDiscountList
{
	//validate if the amount is correct
	
	if (![self isValidDiscount:txtDiscount]) {
		[Tools displayAlert:@"Error" message:@"Valor Invalido"];
		return;
	}
	if (![Tools validateManualDiscounts:itemModel :[self assignDiscountType]]) {
        [Tools displayAlert:@"Aviso" message:@"Demasiados Descuentos"];
        return;
    }
	itemModel.promo=YES;
	NSString *discount=txtDiscount.text;
	float price=[discount floatValue];
	discount=[NSString stringWithFormat:@"%.02f", price];
	
	//NSString *priceWithDiscount=[self calculateDiscounts];
	
	Promotions *promo=[[Promotions alloc] init];	
	promo.promoType=[self assignDiscountType];
	promo.promoTypeBenefit=[self assignDiscountTypeName];
	DLog(@"promo-typebenefit %@", promo.promoTypeBenefit);
	promo.promoDescription=@"DESC x TECLA";
	promo.promoDiscountPercent=[discount copy];
	//promo.promoValue=[priceWithDiscount copy];
	[itemModel.discounts addObject:promo];
	[self calculateSuccesiveDiscounts]; 
	
	[promo release];
	[Tools displayAlert:@"Aviso" message:@"Descuento Agregado"];
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeDiscountScreen];
	
}
/*
-(IBAction) savetoPromoList
{
	itemModel.promo=YES;
	if (promotionIndex) {
		Promotions *promo=[testArray objectAtIndex:promotionIndex.row];
		// Ruben
		
		if ([self isDuplicatedPromotion:promo]) {
			[Tools displayAlert:@"Error" message:@"La promoción ya fue agregada"];
		}
		else {
			//[promotionList addObject:promo];
			//[itemModel.discounts addObject:promo];
			[promo release];
			[self assignPromoType];
			//[self isMonederoPromotion];
			[Tools displayAlert:@"Aviso" message:@"Promocion Agregada"];
		}
	}
	else 
		[Tools displayAlert:@"Error" message:@"Seleccione Una Promocion"];
}



-(BOOL)isDuplicatedPromotion:(Promotions*)promotion  // Ruben
{
	if ([itemModel.discounts count]>0) {
		BOOL regresar = FALSE;
		for (int i=0; i<[itemModel.discounts count]; i++) 
		{
			Promotions *promoActual=[itemModel.discounts objectAtIndex:i];
			
			if ([promotion isEqual:promoActual] ) {
				regresar = TRUE;
				break;
			}
		}
		return regresar;
	}
	else {
		return FALSE;
	}
}
*/
-(void) assignPromoType
{
	Promotions *promo=[testArray objectAtIndex:promotionIndex.row];

	if ([promo.promoInstallment length]>0) 
		promo.promoType=2;//promo with installment
	else
		promo.promoType=1; //promo 
}	
-(int) assignDiscountType
{
	if(ctrlDiscountType.selectedSegmentIndex==0)
		return 3; //promo manual percentage
	else if(ctrlDiscountType.selectedSegmentIndex==1)
		return 4; //promo manual fixed amount
	else 
		return 0;
}
-(NSString*) assignDiscountTypeName
{
	if(ctrlDiscountType.selectedSegmentIndex==0)
		return @"descuentoTeclaPorcentaje"; //promo manual percentage
	else if(ctrlDiscountType.selectedSegmentIndex==1)
		return @"descuentoTeclaMonto"; //promo manual fixed amount
	else 
		return @"";
}

-(NSString*) calculateDiscounts:(NSString*) aPrice
{
	NSString *discount=txtDiscount.text;
	if(ctrlDiscountType.selectedSegmentIndex==0)
		return [Tools calculateDiscountValuePercentage:aPrice:discount];
	else if(ctrlDiscountType.selectedSegmentIndex==1)
		//return [Tools calculateDiscountValueAmount:aPrice:discount];
		return discount;
	else 
		return @"";
}

-(void) calculateSuccesiveDiscounts
{
	NSMutableArray *discountCopy=[[[NSMutableArray alloc] initWithArray:itemModel.discounts] autorelease];
	Promotions *lastPromo=[discountCopy lastObject];
	DLog(@"discountCopy %@ , count %i",discountCopy,[discountCopy count]);
	DLog(@"itemModel.price %@ ",itemModel.price);
	
	if ([discountCopy count]>1) 
	{		
		int index=[discountCopy count]-2;
		DLog(@"index: %i",index);
		Promotions *previousPromo=[discountCopy objectAtIndex:index];
		
		if ([previousPromo.promoDescription isEqualToString:@"DESC x TECLA"]) {
			DLog(@"antes de aplicar descuento sucesivo lastpromo.promovalue:%@",previousPromo.promoValue);
			
			NSString *amountPreviousDiscount=[Tools calculateRestValueAmount:[itemModel priceExtended] :previousPromo.promoValue];
			DLog(@"finalPriceWithPreviousDiscount amountPreviousDiscount %@",amountPreviousDiscount);
			NSString *finalPriceWithPreviousDiscount=[self calculateDiscounts:amountPreviousDiscount];
            //finalPriceWithPreviousDiscount=[Tools calculateMultiplyValueAmount:finalPriceWithPreviousDiscount :[itemModel itemCount]];
			lastPromo.promoValue=[finalPriceWithPreviousDiscount copy];
			DLog(@"Aplicando descuento sucesivo lastpromo.promovalue:%@",lastPromo.promoValue);
		}
	}
	else {
		NSString *price= itemModel.price;
		NSString *finalPrice=[self calculateDiscounts:price];
        finalPrice=[Tools calculateMultiplyValueAmount:finalPrice :[itemModel itemCount]];
		lastPromo.promoValue=[finalPrice copy];
		DLog(@"Aplicando descuento lastpromo.promovalue:%@",lastPromo.promoValue);
		
	}
	
}
-(IBAction) discountTypeSelected
{
	switch ([ctrlDiscountType selectedSegmentIndex]) {
		case 0:
			[ctrlFixedDiscounts setHidden:NO];
			lblSign.text=@"%";
			lblSign.frame=CGRectMake(193, lblSign.frame.origin.y, lblSign.frame.size.width, lblSign.frame.size.height);
            [txtDiscount setText:@""];
			break;
		case 1:
			[ctrlFixedDiscounts setHidden:YES];
			lblSign.text=@"$";
			lblSign.frame=CGRectMake(93, lblSign.frame.origin.y, lblSign.frame.size.width, lblSign.frame.size.height);
            [txtDiscount setText:@""];

			break;
		
		default:
			break;
	}
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[self view] endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}
//----------------------------------------
//            ACTION HANDLERS
//----------------------------------------

//----------------------------------------
//            PROMO HANDLERS
//----------------------------------------
/*-(void) selectGroupOption
{

}*/
//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
-(void) startPromoRequest
{
	[Tools startActivityIndicator:self.view];
	/*LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
	NSString *barcode=itemModel.barCode;
	//NSString *barcode=@"43"; //harcode
	NSArray *pars=[NSArray arrayWithObjects:barcode,nil];
	[liverPoolRequest sendRequest:@"buscaPromocionesProducto" forParameters:pars forRequestType:findPromoRequest]; //cambiar a localized string
	[liverPoolRequest release];*/
	
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
	
	//seller
	Seller *seller=[[Seller alloc] init];
	seller.password=[Session getPassword];
	seller.userName=[Session getUserName];
	
	//Account employee
	NSString *accountEmployee=[Session getEmployeeAccount];
	DLog(@"accounemplotyee itemdisc %@", accountEmployee);
    NSMutableArray *pList = [[NSMutableArray alloc] init];
	NSArray *pars=[NSArray arrayWithObjects:productList,seller,accountEmployee,nil];
	[liverPoolRequest sendRequest:@"ticketTotalize" forParameters:pars forRequestType:totalizeRequest]; //cambiar a localized string
	[liverPoolRequest release];
	[seller release];
}

-(void) performResults:(NSData *)receivedData :(RequestType)requestType
{
	[self findPromoRequestParsing:receivedData];
}
-(void) findPromoRequestParsing:(NSData*) data
{
	PromotionListParser *promoParser=[[PromotionListParser alloc] init];
	DLog(@"antes de empezar");
	[promoParser startParser:data];
	DLog(@"termino");
	testArray=[[promoParser returnPromoList] mutableCopy];

    
 
	// fix para remover el planid de empleado de la lista
	//remove promotion employee from list
	//testArray=[Tools removePromotionFromList:testArray forPlanId:@"812"];
	//remove promotion "weeekly payment" from list until further notice
	testArray=[Tools removePromotionFromList:testArray forPlanId:@"78"];
	//remove all the coupon benefit from list until further notice
	testArray=[Tools removeCouponBenefitFromList:testArray];
	//remove all the descxprom in employee sale
	//testArray=[Tools removeDESCxPROMFromList:testArray];
   
    
    testArrayDisplay =[[NSMutableArray alloc]init];
    for (NSMutableArray *group in testArray) {
        [testArrayDisplay addObject:[[group mutableCopy]autorelease]];
    }
    testArrayDisplay=[Tools removePagoFijoFromList:testArrayDisplay];
  
    DLog(@"rev7 - testarray %i",[testArray count]);
    DLog(@"rev7 - testarray %@",testArray);
    DLog(@"rev7 - isError %i",[promoParser isError]);
    
    if ([promoParser isError]) {    //patch 1.4.5 rev2
        
        DLog(@"error message: %@",[promoParser message]);
        [Tools displayAlert:@"Error" message:[promoParser message]];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) removeDiscountScreen];
        
    }
    else if([[testArray objectAtIndex:0] count]==0){ //fix 1.4.5 rev7
        // promotionGroupSelected=[[testArray objectAtIndex:indexPath.section]copy];
        //DLog(@"promotionGroupSelected %@",promotionGroupSelected);
        //DLog(@"promotionGroupSelected testarray %@",[testArray objectAtIndex:indexPath.section]);
        //DLog(@"promotionGroupSelected testarraydisplay %@",[testArrayDisplay objectAtIndex:indexPath.section]);
        
        [Session setIndexPromoGroup:0];
        [(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) paymentScreen:productList :promotionGroupSelected];
        
        
    }
    
	// fin del fix
	[aTableView reloadData];
	[promoParser release];
	[Tools stopActivityIndicator];
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
    [testArrayDisplay release];
	DLog (@"itemdiscountview dealloc");
	[promotionGroupSelected release];
	[txtOption release];
	[testArray release];
	[aTableView release];
	[btnOk release];
	[txtDiscount release];
	[ctrlFixedDiscounts release];
	[ctrlDiscountType release];
	//itemModel=nil;	
	[lblSign release];
    [super dealloc];
}


@end
