//
//  Tools.m
//  CardReader

#import "Tools.h"
#import <QuartzCore/QuartzCore.h>
#import "Base64.h"
#import "SignPrintView.h"
#import "Session.h"
#import "Promotions.h"
#import "Store.h"
#import "Warranty.h"
@implementation Tools

#define NUMBERS @"0123456789."

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(NSInteger)string:(NSString*)actual indexOf:(NSString*)buscado{
    NSInteger p=-1;
    NSRange textRange;
    textRange =[actual rangeOfString:buscado];
    
    if(textRange.location != NSNotFound)
    {
        //Does contain the substring
        p=textRange.location;
    }
    DLog(@"Index %d",p);
    return p;
}

+(UIImage*)captureScreen:(UIView*) aView
{
	//CGSize viewSize=aView.frame.size;
	//viewSize.height=416;
	UIGraphicsBeginImageContext(aView.frame.size);
	[aView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

/*+(NSMutableData*)outputPDF:(UIView*) aView
 {
 NSMutableData* outputData = [[NSMutableData alloc] init];
 CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputData);
 CFMutableDictionaryRef attrDictionary = NULL;
 attrDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
 CFDictionarySetValue(attrDictionary, kCGPDFContextTitle, @"My Awesome Document");
 CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, attrDictionary);
 CFRelease(dataConsumer);
 CFRelease(attrDictionary);
 UIImage* myUIImage = [Tools captureScreen:aView];
 CGImageRef pageImage = [myUIImage CGImage];
 CGPDFContextBeginPage(pdfContext, NULL);
 CGContextDrawImage(pdfContext, CGRectMake(200, 200, [myUIImage size].width, [myUIImage size].height), pageImage);
 CGPDFContextEndPage(pdfContext);
 CGPDFContextClose(pdfContext);
 CGContextRelease(pdfContext);
 //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 //NSString* documentsDirectory = [paths objectAtIndex:0];
 // NSString* appFile = [documentsDirectory stringByAppendingPathComponent:@"tmp.pdf"];
 // [outputData writeToFile:appFile atomically:YES];
 return outputData;
 }
 */
+(UIImage*)captureSign:(UIView*) aView
{
	SignPrintView *signView;
	for (UIView *view in [aView subviews]) {
		if ([view isKindOfClass:[SignPrintView class]])
			signView=(SignPrintView*) view;
	}
	
	[signView.clearButton setHidden:YES];
	[signView.okButton setHidden:YES];
    
	CGSize viewSize=signView.frame.size;
	UIGraphicsBeginImageContext(viewSize);
	[signView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[signView.clearButton setHidden:NO];
	[signView.okButton setHidden:NO];
    
	return viewImage;
}
+(void)displayAlert:(NSString *)title
			message:(NSString *)message
{
	[self enableApp];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:@"Aceptar"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
+(void)displayAlert:(NSString *)title
			message:(NSString *)message
       withDelegate:(id) delegate
{
	[self enableApp];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:nil
										  otherButtonTitles:@"Aceptar",nil];
	[alert show];
	[alert release];
	
}
+(void) startActivityIndicator:(UIView*) aView
{
    [self disableApp];
	bgActivity=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
	bgActivity.center=aView.center;
	bgActivity.backgroundColor=[UIColor blackColor];
	bgActivity.alpha=.8;
	[[bgActivity layer] setCornerRadius:8.0f];
	[[bgActivity layer] setMasksToBounds:YES];
	[[bgActivity layer] setBorderWidth:0.2f];
	
	UILabel *lblLoading=[[UILabel alloc] initWithFrame:CGRectMake(20, 55, 85, 20)];
	lblLoading.text=@"Procesando...";
	lblLoading.adjustsFontSizeToFitWidth=YES;
	lblLoading.backgroundColor=[UIColor clearColor];
	lblLoading.textColor=[UIColor whiteColor];
	
	[bgActivity addSubview:lblLoading];
	[aView addSubview:bgActivity];
	[lblLoading release];
	[bgActivity release];
	
	activityIndicator=[[UIActivityIndicatorView alloc]
					   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.center=aView.center;
	[aView addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[activityIndicator release];
}
+(void) stopActivityIndicator
{
	DLog(@"EJECUTANDO stopActivityIndicator");
	if (activityIndicator) {
		DLog(@"EJECUTANDO setUserInteractionEnabled para bgActivity");
		[bgActivity setUserInteractionEnabled:NO];
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[bgActivity removeFromSuperview];
		activityIndicator = nil;
		
		bgActivity = nil;
	}
	
	[self enableApp];
}
+(NSString*)convertImageToBase64String:(UIImage*) aImage
{
	NSData *imageData=UIImageJPEGRepresentation(aImage,0.5);
	NSString *encodedImageData=[Base64 encode:imageData];
	return encodedImageData;
}
+(BOOL) isValidNumber:(NSString *) string
{
	NSCharacterSet *cs;
	NSString *filtered;
	cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
	filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
	
	if ([string isEqualToString:filtered]) {
		return YES;
	}else {
		return NO;
	}
	[filtered release];
}
+(BOOL) confirmPhoneValidation:(UITextField*) txtFirstNumber :(UITextField*) txtSecondNumber
{
	NSString* fstNumber=txtFirstNumber.text;
	NSString* sndNumber=txtSecondNumber.text;
    
	if ([fstNumber isEqualToString:sndNumber])
	{
		CALayer* layer=[txtFirstNumber layer];
		layer.borderColor=[[UIColor clearColor]CGColor];
		
		layer=[txtSecondNumber layer];
		layer.borderColor=[[UIColor clearColor]CGColor];
		return YES;
	}
	else {
		CALayer* layer=[txtFirstNumber layer];
		layer.borderColor=[[UIColor redColor]CGColor];
		layer.borderWidth=2;
		layer.cornerRadius=5;
		
		layer=[txtSecondNumber layer];
		layer.borderColor=[[UIColor redColor]CGColor];
		layer.borderWidth=2;
		layer.cornerRadius=5;
		return NO;
	}
    
}

+(BOOL) isTextFieldEmpty:(UITextField*) theTextfield
{
	if ([theTextfield.text length]==0) {
		
		CALayer* layer=[theTextfield layer];
		layer.borderColor=[[UIColor redColor]CGColor];
		layer.borderWidth=2;
		layer.cornerRadius=5;
		
		return YES;
	}
	else {
		CALayer* layer=[theTextfield layer];
		layer.borderColor=[[UIColor clearColor]CGColor];
		return NO;
	}
    
}
/*+(void) loadPrinter
 {
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Printers.plist"]; NSFileManager *fileManager = [NSFileManager defaultManager];
 
 if (![fileManager fileExistsAtPath: path])
 {
 path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"Printers.plist"] ];
 }
 
 
 NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
 NSString* printer = [savedStock objectForKey:@"printer"];
 
 DLog(@"printer Selected:%@",printer);
 [Session setPrinterName:printer];
 [savedStock release];
 
 }
 */

/*+(void) savePrinter
 {
 
 NSString *printer=[Session getPrinterName];
 if (!printer)
 return;
 
 
 NSString *error;
 
 NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 
 NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Printers.plist"];
 
 NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
 
 [NSArray arrayWithObjects: [Session getPrinterName], nil]
 
 forKeys:[NSArray arrayWithObjects: @"printer", nil]];
 
 NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
 
 format:NSPropertyListXMLFormat_v1_0
 
 errorDescription:&error];
 
 if(plistData) {
 
 [plistData writeToFile:plistPath atomically:YES];
 
 }
 
 else {
 
 DLog(@"%@",error);
 
 [error release];
 
 }
 
 }
 */
+(void) loadStore
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"StoreConfigure.plist"]; NSFileManager *fileManager = [NSFileManager defaultManager];
	
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"StoreConfigure.plist"] ];
    }
	
	
	NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSString* terminal = [savedStock objectForKey:@"terminal"];
	NSString* idStore = [savedStock objectForKey:@"idStore"];
	NSString* store = [savedStock objectForKey:@"store"];
    NSString* storePrint = [savedStock objectForKey:@"storePrint"];
    NSString* server = [savedStock objectForKey:@"serverAddress"];
    NSString* storeAddress = [savedStock objectForKey:@"storeAddress"];
    NSString* bancomerAffNumber = [savedStock objectForKey:@"bancomerAffNumber"];
    NSString* amexAffNumber = [savedStock objectForKey:@"amexAffNumber"];

    if (terminal==NULL||terminal==nil)
        terminal=@"";
    
    DLog(@"loadSTORE");
	DLog(@"IdStore:%@",idStore);
	DLog(@"Store:%@",store);
    DLog(@"StorePrint:%@",storePrint);
	DLog(@"Terminal:%@",terminal);
	DLog(@"ServerAddress:%@",server);
	DLog(@"StoreAddress:%@",storeAddress);
    DLog(@"bancomerAffNumber:%@",bancomerAffNumber);
	DLog(@"amexAffNumber:%@",amexAffNumber);
    
	[Session setIdStore:idStore];
	[Session setStore:store];
    [Session setStorePrint:storePrint];
	[Session setTerminal:terminal];
    [Session SetServerAddress:server];
    [Session SetStoreAddress:storeAddress];
    [Session setBancomerAffNumber:bancomerAffNumber];
    [Session setAmexAffNumber:amexAffNumber];

	[savedStock release];
	
}
+(void) saveStore
{
	
	NSString *idStore=[Session getIdStore];
	if (!idStore)
		return;
    
	NSString *error;
	
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"StoreConfigure.plist"];
	DLog(@"plistPath %@ ", plistPath);
	DLog(@"getIDStore %@",[Session getIdStore]);
    DLog(@"getStore %@",[Session getStore]);
    DLog(@"getStorePrint %@",[Session getStorePrint]);
	DLog(@"getTerminal %@",[Session getTerminal]);
	DLog(@"getServerAddress %@",[Session getServerAddress]);
	DLog(@"getStoreAddress %@",[Session getStoreAddress]);
    DLog(@"getBancomerAffNumber %@",[Session getBancomerAffNumber]);
	DLog(@"getAmexAffNumber %@",[Session getAmexAffNumber]);


    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:

							   [NSArray arrayWithObjects: [Session getIdStore],[Session getStore],[Session getStorePrint], [Session getTerminal],[Session getServerAddress],[Session getStoreAddress],[Session getBancomerAffNumber],[Session getAmexAffNumber], nil]
														  forKeys:[NSArray arrayWithObjects: @"idStore",@"store",@"storePrint",@"terminal",@"serverAddress",@"storeAddress",@"bancomerAffNumber",@"amexAffNumber" ,nil]];
 
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
	
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
	else {
        DLog(@"%@",error);
        [error release];
    }
}
+(void) resetStore
{
	NSString *error;
	
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"StoreConfigure.plist"];
	[Session setIdStore:@""];
    [Session setStore:@""];
    [Session setStorePrint:@""];
    [Session setTerminal:@""];
    [Session SetServerAddress:@""];
    [Session SetStoreAddress:@""];
    [Session setAmexAffNumber:@""];
    [Session setBancomerAffNumber:@""];
    
    DLog(@"plistPath %@ ", plistPath);
	DLog(@"getIDStore %@",[Session getIdStore]);
    DLog(@"getStore %@",[Session getStore]);
	DLog(@"getTerminal %@",[Session getTerminal]);
	DLog(@"getServerAddress %@",[Session getServerAddress]);
	DLog(@"getStoreAddress %@",[Session getStoreAddress]);
    DLog(@"setAmexAffNumber %@",[Session getAmexAffNumber]);
	DLog(@"setBancomerAffNumber %@",[Session getBancomerAffNumber]);

    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
							   
							   [NSArray arrayWithObjects: [Session getIdStore],[Session getStore],[Session getStorePrint], [Session getTerminal],[Session getServerAddress],[Session getStoreAddress],[Session getBancomerAffNumber],[Session getAmexAffNumber], nil]
							   
														  forKeys:[NSArray arrayWithObjects: @"idStore",@"store",@"storePrint",@"terminal",@"serverAddress",@"storeAddress",@"bancomerAffNumber",@"amexAffNumber",nil]];
	
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
						 
																   format:NSPropertyListXMLFormat_v1_0
						 
														 errorDescription:&error];
	
    if(plistData) {
		
        [plistData writeToFile:plistPath atomically:YES];
		
    }
	
	else {
		
        DLog(@"%@",error);
		
        [error release];
		
    }
	
}

+(NSString*) calculateDiscountValuePercentage:(NSString*) aPrice :(NSString*)percentageDiscount
{
	float price=[aPrice floatValue];
	float discount= [percentageDiscount floatValue];
	
	float finalPrice= ((discount/100) *price);
	NSString *result=[NSString stringWithFormat:@"%.02f", finalPrice];
	DLog(@"TOOLS DISCOUNT:%f",discount);
	DLog(@"TOOLS FINAL PRICE:%f",finalPrice);
	
	if (finalPrice<=0)
		return @"";
	else
		return result;
}

+(NSString*) calculateDiscountValueAmount:(NSString*) aPrice :(NSString*)amountDiscount
{
	float price=[aPrice floatValue];
	float discount= [amountDiscount floatValue];
	DLog(@"********* TOOLS Price:%.02f discount:%.02f",price,discount);
	float finalPrice= price-discount;
	NSString *result=[NSString stringWithFormat:@"%.02f", finalPrice];
	return result;
}
+(NSString*) calculateAddUpValueAmount:(NSString*) amount1 :(NSString*)amount2
{
	float amount1Float=[amount1 floatValue];
	float amount2Float= [amount2 floatValue];
	DLog(@"********* TOOLS ADDUP Price:%.02f discount:%.02f",amount1Float,amount2Float);
	float finalPrice= amount1Float+amount2Float;
	NSString *result=[NSString stringWithFormat:@"%.02f", finalPrice];
	return result;
}
+(NSString*) calculateRestValueAmount:(NSString*) amount1 :(NSString*)amount2
{
	float amount1Float=[amount1 floatValue];
    amount1Float=fabsf(amount1Float);
	float amount2Float= [amount2 floatValue];
    amount2Float= fabsf(amount2Float);
	DLog(@"********* TOOLS REST Price:%.02f discount:%.02f",amount1Float,amount2Float);
	float finalPrice= amount1Float-amount2Float;
	NSString *result=[NSString stringWithFormat:@"%.02f", finalPrice];
	return result;
}
+(NSString*) calculateDivisionValueAmount:(NSString*) dividend :(NSString*)divisor
{
	float divisorFloat=[divisor floatValue];
	float dividendFloat= [dividend floatValue];
	DLog(@"********* TOOLS DIVID Price:%.02f discount:%.02f",divisorFloat,dividendFloat);
	float finalPrice=  divisorFloat/dividendFloat;
	NSString *result=[NSString stringWithFormat:@"%.02f", finalPrice];
	return result;
}
+(NSString*) calculateMultiplyValueAmount:(NSString*) multi1 :(NSString*)multi2
{
	float multi1Float=[multi1 floatValue];
	float multi2Float= [multi2 floatValue];
	DLog(@"********* TOOLS MULTI mut1:%.02f mut2:%.02f",multi1Float,multi2Float);
	float finalPrice=  multi1Float*multi2Float;
	NSString *result=[NSString stringWithFormat:@"%.02f", finalPrice];
	return result;
}


+(void) showViewAnimation:(UIView*) aView
{
	aView.center=CGPointMake(320+(aView.frame.size.width/2), aView.center.y);
	
	/*[UIView beginAnimations:nil context:NULL]; {
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationDuration:0.5];
     [UIView setAnimationDelegate:self];
     
     
     aView.center=CGPointMake(320-(aView.frame.size.width/2), aView.center.y);
     [aView setHidden:NO];
     
     } [UIView commitAnimations];
     */
	[aView setHidden:NO];
	[UIView animateWithDuration:0.5
						  delay:0.0
						options: UIViewAnimationCurveEaseOut
					 animations:^{
						 aView.center=CGPointMake(320-(aView.frame.size.width/2), aView.center.y);
					 }
					 completion:^(BOOL finished){
					 }];
	
}


+(void) hideViewAnimation:(UIView*) aView
{
	
	/*[UIView beginAnimations:nil context:NULL]; {
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationDuration:0.5];
     [UIView setAnimationDelegate:self];
     
     
     aView.center=CGPointMake(320+(aView.frame.size.width/2), aView.center.y);
     [UIView setAnimationDidStopSelector:@selector(setViewToHidden:)];
     } [UIView commitAnimations];*/
	
	[UIView animateWithDuration:0.5
						  delay:0.0
						options: UIViewAnimationCurveEaseOut
					 animations:^{
						 aView.center=CGPointMake(320+(aView.frame.size.width/2), aView.center.y);
					 }
					 completion:^(BOOL finished){
						 aView.hidden=YES;
					 }];
	
}

+(NSString*) trimUsernameFromCreditCardTrack:(NSString*) track1
{
	NSArray *array = [track1 componentsSeparatedByCharactersInSet:
                      [NSCharacterSet characterSetWithCharactersInString:@"^"]];
	
    NSString *username = [array count]>=2 ? [array objectAtIndex:1] : @"";
	
	username = [username stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	DLog(@"userblank count:%i",[username length]);
    
	if ([username length]==0)
		return @"Tarjeta Debito";
	else
		return username;
	
}
+(NSString*) trimComandaNumber:(NSString*) track1
{
    NSString *comanda=@"";
	if ([track1 length]>=7) {
        comanda=[track1 substringToIndex:7];
    }
	
	DLog(@"comanda trim: %@", comanda);
    
	if ([comanda length]==0)
		return @"";
	else
		return comanda;
	
}
+(NSString*) trimExpireDateCreditCardTrack:(NSString*) track1
{
	NSArray *array = [track1 componentsSeparatedByCharactersInSet:
					  [NSCharacterSet characterSetWithCharactersInString:@"^"]];
	
	
	NSString *expireDate=[array objectAtIndex:2];
	expireDate=[expireDate substringToIndex:4];
	DLog(@"expiredate: %@", expireDate);
    
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"ddMM"];
	NSDate *date = [dateFormat dateFromString:expireDate];
	
	[dateFormat setDateFormat:@"MM/d"];
	expireDate = [dateFormat stringFromDate:date];
	
	DLog(@"expiredateview: %@", expireDate);
    [dateFormat release];
    
	return expireDate;
}
+(NSString*) trimExpireDateCard:(NSString*) track1
{
	NSArray *array = [track1 componentsSeparatedByCharactersInSet:
					  [NSCharacterSet characterSetWithCharactersInString:@"^"]];
	
	
	NSString *expireDate=[array objectAtIndex:2];
	expireDate=[expireDate substringToIndex:4];
    
	DLog(@"expiredateparameter: %@", expireDate);
	return expireDate;
}
//+ (NSString*) getUniqueID{
//		return [[UIDevice currentDevice] uniqueIdentifier];
//}

+(BOOL) validatePrinterConfig
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSData* myEncodedObject = [defaults objectForKey:@"programIPAddres"];
	NSString* ipAddress = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	NSString* portSettings = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
	DLog(@"ipAddress: %@", ipAddress);
	if ([ipAddress length]==0|| [portSettings length]==0)
	{
		[Tools displayAlert:@"Advertencia: Impresion" message:@"Favor de configurar la ip de la impresora en el menu de configuracion antes de realizar una transaccion"];
		return NO;
	}
	else
		return YES;
}

+(NSString*) maskCreditCardNumber:(NSString*) cardNumber
{
	cardNumber=[cardNumber stringByReplacingCharactersInRange:NSMakeRange(0, 12) withString:@"************"];
	return	cardNumber;
}

+(NSString*) maskMonederoNumber:(NSString*) cardNumber
{
	cardNumber=[cardNumber stringByReplacingCharactersInRange:NSMakeRange(0, 9) withString:@"************"];
	return	cardNumber;
}
+(NSString*) maskQuantityFormat:(NSString*) value
{
    NSString *label;
    if ([value length]==0) {
        label=@"";
    }
    else
    {
        label=@"x";
        label=[label stringByAppendingString:value];
    }
    return label;
}
+(NSString*) maskModifierFormat:(NSString*) value
{
    NSString *label;
    if ([value length]==0) {
        label=@"";
    }
    else
    {
        label=@"x.";
        label=[label stringByAppendingString:value];
    }
    return label;
}
+(NSString*) amountCurrencyFormat:(NSString*) amount
{
	// alloc formatter
	NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
	
	// set options.
	[currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSNumber *amt = [NSNumber numberWithFloat:[amount floatValue]];
	
	// get formatted string
	NSString* formatted = [currencyStyle stringFromNumber:amt];
	
    
	//NSCharacterSet *CurrencyChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890.,$"] invertedSet];
	//formatted=[[formatted componentsSeparatedByCharactersInSet:CurrencyChars] componentsJoinedByString:@""];
	
	[currencyStyle release];
	return formatted;
	
}
+(NSString*) amountCurrencyFormatFloat:(float) amount
{
	// alloc formatter
	NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
	
	// set options.
	[currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSNumber *amt = [NSNumber numberWithFloat:amount];
	
	// get formatted string
	NSString* formatted = [currencyStyle stringFromNumber:amt];
	
	
	//NSData* asciiData =[formatted dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	//formatted=[NSString stringWithCString:[asciiData bytes] encoding:NSUTF8StringEncoding];
	
	NSCharacterSet *CurrencyChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890.,$"] invertedSet];
	formatted=[[formatted componentsSeparatedByCharactersInSet:CurrencyChars] componentsJoinedByString:@""];
	
	[currencyStyle release];
	return formatted;
	
}

+ (UIView *)inputAccessoryView:(UITextField*) aTxtField{
	
    txtField=aTxtField;
    CGRect accessFrame = CGRectMake(0.0, 0.0, 80, 30.0);
    
    UIView* inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
    
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    compButton.frame = CGRectMake(240, 0, 80, 30);
    
    [compButton setTitle: @"ok" forState:UIControlStateNormal];
    [compButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *buttonImageNormal = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"tab" ofType:@"png"]];
	
    [compButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    
    
    [compButton addTarget:self action:@selector(hideKeyboard)
     
         forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccessoryView addSubview:compButton];
    
    return inputAccessoryView;
	
}

+(void) hideKeyboard
{
    DLog(@"hideKeyboard");
	//[txtField.superview.superview endEditing:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
	
}
+(BOOL) monederoPromotionInList:(NSArray*) aProductList
{
	for (FindItemModel *item in aProductList)
	{
		for (Promotions *promo in item.discounts) {
			NSRange textRange;
			NSString* promoName=[[promo promoTypeBenefit]copy];
			DLog(@"%@",promoName);
			textRange =[promoName rangeOfString:@"factorLoyaltyBenefit" options:NSCaseInsensitiveSearch];
			
			if(textRange.location != NSNotFound&&[promoName length]!=0)
			{
				//Does contain the substring
				return YES;
			}
			[promoName release];
		}
	}
	return NO;
}

+(NSString*) calculateAmountToPay:(NSArray*) productList
{
	float total=0;
	float totalDiscounts=0;
    float totalWarranties=0;
	

    for (id item in productList){
        if ([item isKindOfClass:[FindItemModel class]]) {
            FindItemModel *itemF =item;
                for (Promotions *promo in itemF.discounts) {
                    if (promo.promoType==3) //print promotion by key with %
                    {
                        totalDiscounts+=[promo.promoValue floatValue];
                    }
                    else if(promo.promoType==4) //print promotion by key with fixed amount
                    {
                        totalDiscounts+=[promo.promoDiscountPercent floatValue];
                    }
                }
            total = itemF.isFree ? total : total + ([itemF.price floatValue]*[[itemF itemCount] floatValue]);
        } else if ([item isKindOfClass:[Warranty class]]){
            Warranty *itemW = item;
            totalWarranties += ([itemW.cost floatValue] *[itemW.quantity floatValue]);
        }
    }
	//calculate the total amount for ticket with discounts
	total=total-totalDiscounts+totalWarranties;
	DLog(@"<<<<total>>>>>:%f, products:%@",total,productList);
	NSString *totalS=[NSString stringWithFormat:@"%.02f",total];
	return totalS;
}


+(NSMutableArray*) removePromotionFromList:(NSMutableArray*)testArray forPlanId:(NSString*) planId
{
	NSMutableArray *testMutableArray=[NSMutableArray arrayWithArray:testArray];
	//NSMutableArray *testMutableArray = [[NSMutableArray alloc] initWithArray:testArray copyItems:YES];
	
	NSRange textRange;
	int optionIndex=0;
	int promoIndex=0;
	
	for (NSMutableArray *optionGroup in testArray) { //for each promo group
		
		NSMutableArray *og=[NSMutableArray arrayWithArray:optionGroup];
		for (Promotions *promo in og) {
			
			NSString* promoName=[[promo planId]copy];
			textRange =[promoName rangeOfString:planId options:NSCaseInsensitiveSearch];
			
			if (textRange.location != NSNotFound&&[promoName length]!=0) {
				
				optionIndex=[testMutableArray indexOfObjectIdenticalTo:optionGroup];
				promoIndex=[[testMutableArray objectAtIndex:optionIndex] indexOfObjectIdenticalTo:promo];
				DLog(@"REMOVIO INDEXIDENTICAL optiongroup:%i promoindex:%i",optionIndex,promoIndex);
				[[testMutableArray objectAtIndex:optionIndex] removeObjectAtIndex:promoIndex];
				
			}
			[promoName release];
		}
	}
	
	testArray=[NSMutableArray arrayWithArray:testMutableArray];
	[testArray retain];
	return testArray;
}
+(NSMutableArray*) removeCouponBenefitFromList:(NSMutableArray*)testArray;
{
	NSMutableArray *testMutableArray=[[NSMutableArray arrayWithArray:testArray] mutableCopy];
    
	NSRange textRange;
	int optionIndex=0;
	int promoIndex=0;
	
	for (NSMutableArray *optionGroup in testArray) { //for each promo group
		
		NSMutableArray *og=[NSMutableArray arrayWithArray:optionGroup];
		for (Promotions *promo in og) {
			
			NSString* promoName=[[promo promoTypeBenefit]copy];
			textRange =[promoName rangeOfString:@"couponBenefit" options:NSCaseInsensitiveSearch];
			
			if (textRange.location != NSNotFound&&[promoName length]!=0) {
                
				optionIndex=[testMutableArray indexOfObjectIdenticalTo:optionGroup];
				promoIndex=[[testMutableArray objectAtIndex:optionIndex] indexOfObjectIdenticalTo:promo];
				DLog(@"REMOVIO INDEXIDENTICAL optiongroup:%i promoindex:%i",optionIndex,promoIndex);
				[[testMutableArray objectAtIndex:optionIndex] removeObjectAtIndex:promoIndex];
                
			}
			[promoName release];
		}
	}
	
	testArray=[NSMutableArray arrayWithArray:testMutableArray];
	[testArray retain];
	return testArray;
	
}
+(NSMutableArray*) removeDESCxPROMFromList:(NSMutableArray*)testArray
{
	NSMutableArray *testMutableArray=[NSMutableArray arrayWithArray:testArray];
	
	NSRange textRange;
	NSRange textRange2;
    
	int optionIndex=0;
	int promoIndex=0;
	
	for (NSMutableArray *optionGroup in testArray) { //for each promo group
		
		NSMutableArray *og=[NSMutableArray arrayWithArray:optionGroup];
		for (Promotions *promo in og) {
			
			NSString* promoName=[[promo promoTypeBenefit]copy];
			textRange =[promoName rangeOfString:@"percentageDiscount" options:NSCaseInsensitiveSearch];
			
			NSString* promoType=[[promo promoDescription]copy];
			textRange2 =[promoType rangeOfString:@"DESC X PROM" options:NSCaseInsensitiveSearch];
			
			if (textRange.location != NSNotFound&&[promoName length]!=0 &&textRange2.location != NSNotFound&&[promoType length]!=0) {
				
				optionIndex=[testMutableArray indexOfObjectIdenticalTo:optionGroup];
				promoIndex=[[testMutableArray objectAtIndex:optionIndex] indexOfObjectIdenticalTo:promo];
				DLog(@"REMOVIO INDEXIDENTICAL optiongroup:%i promoindex:%i",optionIndex,promoIndex);
				[[testMutableArray objectAtIndex:optionIndex] removeObjectAtIndex:promoIndex];
				
			}
			[promoName release];
		}
	}
	
	testArray=[NSMutableArray arrayWithArray:testMutableArray];
	[testArray retain];
	return testArray;
	
}
+(NSMutableArray*) removePaymentPlanBenefitFromList:(NSMutableArray*)testArray
{
	
    NSMutableArray *testMutableArray=[NSMutableArray arrayWithArray:testArray];
    NSRange textRange;
    
    for (Promotions *promo in testArray) {
        NSString* promoName=[[promo promoTypeBenefit]copy];
        textRange =[promoName rangeOfString:@"paymentPlanBenefit" options:NSCaseInsensitiveSearch];
        
        if (textRange.location != NSNotFound&&[promoName length]!=0) {
            DLog(@"REMOVIO removePaymentPlanBenefitFromList INDEXIDENTICAL %i ,%@",[testMutableArray indexOfObjectIdenticalTo:promo],promoName);
            [testMutableArray removeObjectAtIndex:[testMutableArray indexOfObjectIdenticalTo:promo]];
        }
        [promoName release];
    }
	
	testArray=[NSMutableArray arrayWithArray:testMutableArray];
	[testArray retain];
	return testArray;
    
}

//this method removes all the promotion "pagos fijos employee/client" and replace it with a dummy promotion only in display
//this array is used only for display
+(NSMutableArray*) removePagoFijoFromList:(NSMutableArray*)testArray
{
	NSMutableArray *testMutableArray=[NSMutableArray arrayWithArray:testArray];
	
	NSRange textRange;
	NSRange textRange2;
    
	int optionIndex=0;
	int promoIndex=0;
    
    BOOL isRemoved=NO;
	
    DLog(@"removepagofijofromlisrt");
	for (NSMutableArray *optionGroup in testArray) { //for each promo group
        isRemoved=NO;
        
		NSMutableArray *og=[NSMutableArray arrayWithArray:optionGroup];
		for (Promotions *promo in og) {
			
			NSString* promoName=[[promo planId]copy];
			textRange =[promoName rangeOfString:@"874" options:NSCaseInsensitiveSearch];
			
			NSString* promoType=[[promo planId]copy];
			textRange2 =[promoType rangeOfString:@"875" options:NSCaseInsensitiveSearch];
			
            //DLog(@"comparando %@ %@", promoType,promoName);
			if ((textRange.location != NSNotFound&&[promoName length]!=0) ||(textRange2.location != NSNotFound&&[promoType length]!=0)) { //patch 1.4.5
				
				optionIndex=[testMutableArray indexOfObjectIdenticalTo:optionGroup];
				promoIndex=[[testMutableArray objectAtIndex:optionIndex] indexOfObjectIdenticalTo:promo];
				DLog(@"removepagofijofromlisrt REMOVIO INDEXIDENTICAL optiongroup:%i promoindex:%i",optionIndex,promoIndex);
				[[testMutableArray objectAtIndex:optionIndex] removeObjectAtIndex:promoIndex];
				
                if (!isRemoved) {
                    Promotions *insertDummyPromo=[[Promotions alloc]init];
                    insertDummyPromo.planId=@"874";
                    insertDummyPromo.promoDescription=@"PLAN DE PAGO FIJOS";
                    [[testMutableArray objectAtIndex:optionIndex] addObject:insertDummyPromo];
                    [insertDummyPromo release];
                    isRemoved=YES;
                }
                
                
			}
			[promoName release];
		}
	}
	
	testArray=[NSMutableArray arrayWithArray:testMutableArray];
	[testArray retain];
	return testArray;
    
}



+(void) applyPromotionsToTicket:(NSMutableArray*) aPromotionList :(NSMutableArray*) aProductList
{
	//if(item.department==aPromotionList.department)
	for(FindItemModel *item in aProductList)
	{
		for (Promotions *promo in aPromotionList) {
			[item.discounts addObject:promo];
		}
	}
}


+(BOOL) isMonederoPromotion:(NSMutableArray*) promotionList
{
	BOOL isMonedero=NO;
	for (Promotions *promo in promotionList) {
        NSRange textRange;
        NSString* promoName=[[promo promoTypeMonedero]copy];
        DLog(@"%@",promoName);
        textRange =[promoName rangeOfString:@"monedero" options:NSCaseInsensitiveSearch];
        
		if(textRange.location != NSNotFound&&[promoName length]!=0)
		{
			//Does contain the substring
			//MonederoCardViewController* monederoView=[[MonederoCardViewController alloc] initWithNibName:@"MonederoCardViewController" bundle:nil];
			[Session setMonederoPercent:[promo promoDiscountPercent]];
			//[self presentModalViewController:monederoView animated:YES];
			//[monederoView release];
			isMonedero=YES;
		}
        [promoName release];
    }
    return isMonedero;
}

+(BOOL) addExtraMonedero:(NSMutableArray*) promotionList :(NSString*) aFactor
{
    DLog(@"addExtraMonedero %@",aFactor);
	BOOL isMonedero=NO;
	for (Promotions *promo in promotionList) {
        NSRange textRange;
        NSString* promoName=[[promo promoTypeMonedero]copy];
        DLog(@"%@",promoName);
        textRange =[promoName rangeOfString:@"monedero" options:NSCaseInsensitiveSearch];
        
		if(textRange.location != NSNotFound&&[promoName length]!=0)
		{
			//Does contain the substring
            float factor=[aFactor floatValue];
            float monFactor=[[promo promoDiscountPercent] floatValue];
            float total=factor+monFactor;
            //monedero that is not the additional monedero for dilisa
            if (monFactor>5.00) {
                [promo setPromoDiscountPercent:[NSString stringWithFormat:@"%f",total]];
                [Session setMonederoPercent:[promo promoDiscountPercent]];
                isMonedero=YES;
                DLog(@"monedero found ADDED %f",total);
                
            }
           
		}
        [promoName release];
    }
    return isMonedero;
}
+(BOOL) removeExtraMonedero:(NSMutableArray*) promotionList
{
    DLog(@"removeExtraMonedero");
    BOOL isMonedero=NO;
	for (Promotions *promo in promotionList) {
        
        NSRange textRange;
        NSString* promoName=[[promo promoTypeMonedero]copy];
        DLog(@"%@",promoName);
        textRange =[promoName rangeOfString:@"DILISA/LPC" options:NSCaseInsensitiveSearch];
        
		if(textRange.location != NSNotFound&&[promoName length]!=0)
		{
			//Does contain the substring
			//MonederoCardViewController* monederoView=[[MonederoCardViewController alloc] initWithNibName:@"MonederoCardViewController" bundle:nil];
			
            float factor=[[promo promoDiscountPercent] floatValue];
            factor*=-1;
            [self addExtraMonedero:promotionList:[NSString stringWithFormat:@"%f",factor]];
			//[self presentModalViewController:monederoView animated:YES];
			//[monederoView release];
			isMonedero=YES;
            DLog(@"monedero found removed");

		}
        [promoName release];
    }
    return isMonedero;
}


+(BOOL) isDiscountPromotionInGroup:(NSMutableArray*) promotionList{
    //BOOL isPromoInHouse=NO;
    //BOOL isPromoDiscount=NO;
    BOOL result=NO;
    
	for (Promotions *promo in promotionList) {
        //if both discounts are in the group, desc. casa defaults to 10%
        if ([[promo promoDescriptionPrinter]isEqualToString:@"DESC X PROM"]){
            result=YES;
        }
    }
 
    return result;
}

+(void) calculateSuccesiveDiscounts:(FindItemModel *) item
{
	NSMutableArray *discountCopy=[[[NSMutableArray alloc] initWithArray:item.discounts] autorelease];
	//Promotions *lastPromo=[discountCopy lastObject];
	DLog(@"calculateSuccesiveDiscounts" );
    
	for (Promotions *promo in discountCopy) {
        
        NSInteger index=[discountCopy indexOfObjectIdenticalTo:promo];
        DLog(@"index succesive %i",index);
		
        if (index==0) {
            //percentDiscount
            if ([promo promoType]==3) {
                NSString *finalPriceWithPreviousDiscount=[self calculateDiscountValuePercentage:item.priceExtended :promo.promoDiscountPercent];
                promo.promoValue=[finalPriceWithPreviousDiscount copy];
                DLog(@"Aplicando descuento sucesivo porcentaje lastpromo.promovalue:%@",promo.promoValue);
                //float result=[[promo promoValue]floatValue] *[[item itemCount] floatValue];
                //promo.promoValue=[NSString stringWithFormat:@"%.02f",result];
                
            }
            if ([promo promoType]==4) {
                //NSString *finalPriceWithPreviousDiscount=[self calculateRestValueAmount:item.price :promo.promoDiscountPercent];
                //promo.promoValue=[finalPriceWithPreviousDiscount copy];
                promo.promoValue=[promo.promoDiscountPercent copy];
                
                DLog(@"Aplicando descuento sucesivo lastpromo.promovalue:%@",promo.promoValue);
				
            }
            //jon ver 3.1.1
            if ([promo promoType]==1) { //monedero
                promo.promoValue=[item.priceExtended copy];
            }
            // [promo setAlreadyCalculated:YES];
        }
        else {
            Promotions *previousPromo=[item.discounts objectAtIndex:(index-1)];
            DLog(@"antes de aplicar descuento sucesivo lastpromo.promovalue:%@",previousPromo.promoValue);
            NSString *amountPreviousDiscount=[Tools calculateRestValueAmount:item.priceExtended :previousPromo.promoValue];
            DLog(@"finalPriceWithPreviousDiscount amountPreviousDiscount %@",amountPreviousDiscount);
			
            //percentDiscount
            if ([promo promoType]==3) {
                NSString *finalPriceWithPreviousDiscount=[self calculateDiscountValuePercentage:amountPreviousDiscount :promo.promoDiscountPercent];
                promo.promoValue=[finalPriceWithPreviousDiscount copy];
                DLog(@"Aplicando descuento sucesivo porcentaje lastpromo.promovalue:%@",promo.promoValue);
                
            }
            if ([promo promoType]==4) {
                NSString *finalPriceWithPreviousDiscount=[self calculateRestValueAmount:item.priceExtended :promo.promoDiscountPercent];
                promo.promoValue=[finalPriceWithPreviousDiscount copy];
                DLog(@"Aplicando descuento sucesivo lastpromo.promovalue:%@",promo.promoValue);
				
            }
            //jon ver 3.1.1
            if ([promo promoType]==1) { //monedero
                promo.promoValue=[amountPreviousDiscount copy];
            }
            //[promo setAlreadyCalculated:YES];
            
        }
    }
}


+(NSString*) calculateQuantityExtendedPrice:(FindItemModel *) item
{
    //[Tools calculateSuccesiveDiscounts:item];
    float price=[[item price] floatValue]; //fix 1.4.3.2
    float quantity= [[item itemCount] floatValue];
	
    DLog(@"extended price :%f",price);
    DLog(@"normal price :%@",[item price]);
    
	float finalPrice= price*quantity;
    
	NSString *result=[NSString stringWithFormat:@"%.02f", finalPrice];
	DLog(@"TOOLS quantity:%f",quantity);
	DLog(@"TOOLS FINAL PRICE:%f",finalPrice);
	
	if (finalPrice<=0)
		return @"";
	else
		return result;
}
+(BOOL) isValidAmountToPay:(UITextField*) discount :(NSNumber*) maxAmount :(int) paymentType
{
	float discountValue=[discount.text floatValue];
	DLog(@"isValidAmountToPay %f ,%f",discountValue,[maxAmount floatValue]);
    
    if (discountValue>[maxAmount floatValue]&&paymentType!=4)
    {
        //discount.backgroundColor=[UIColor redColor];
        [self displayAlert:@"Aviso" message:@"El monto ingresado supera la cantidad a pagar"];
        return NO;
    }
    else
    {
        //discount.backgroundColor=[UIColor whiteColor];
        return YES;
    }
    
}

+(void)disableApp
{
	UIWindow* window = [[UIApplication sharedApplication] keyWindow]; // Cambio Ruben - 19/enero/2012
	DLog(@"EJECUTANDO setUserInteractionEnabled para window");
	[window setUserInteractionEnabled:NO]; // Cambio Ruben - 19/enero/2012
}

+(void)enableApp
{
	UIWindow* window = [[UIApplication sharedApplication] keyWindow]; // Cambio Ruben - 19/enero/2012
	DLog(@"EJECUTANDO setUserInteractionEnabled para window");
	[window setUserInteractionEnabled:YES]; // Cambio Ruben - 19/enero/2012
}
+(void) saveStoreToPlist:(NSMutableArray*) storeList
{
    
    if([storeList count]>0)
    {
        //Get info for plist
        
        //---------------------------
        
        DLog(@"storelist count: %i",[storeList count]);
        
        NSString *error;
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"stores.plist"];
        DLog(@"plistPath %@ ", plistPath);
        NSUInteger indexKey = 0;
        NSMutableDictionary *storeDic=[[NSMutableDictionary alloc ]init];
        NSDictionary *dic;
        for (Store *store in storeList) {
            
            //                DLog(@"storenumber %@",store.number);
            //                DLog(@"storename %@",store.name);
            
            dic=[[NSDictionary alloc]initWithObjectsAndKeys:
                 [store number],@"number",
                 [store name],@"name",
                 [store description], @"description",
                 nil];
            [storeDic setObject:dic forKey:[NSString stringWithFormat:@"item %i",indexKey]];
            indexKey++;
            
        }
        
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:storeDic
                             
                                                                       format:NSPropertyListXMLFormat_v1_0
                             
                                                             errorDescription:&error];
        
        if(plistData) {
            
            BOOL sucess=[plistData writeToFile:plistPath atomically:YES];
            
            if(sucess)
                DLog(@"escribio plist");
            else
                DLog(@"fallo plist");
        }
        
        else {
            
            DLog(@"%@",error);
            
            [error release];
            
        }
    }
}


+(void) restartVoucherNumber
{
    //restart the voucher number
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"voucherNumber"]==nil) {
        [defaults setInteger:1 forKey:@"voucherNumber"];
        
    }
    else {
        //int counter=[defaults integerForKey:@"voucherNumber"];
        int counter=1;
        [defaults setInteger:counter forKey:@"voucherNumber"];
        DLog(@"voucher counter restart");
        
    }
	[defaults synchronize];
    
}
+(void) increaseVoucherNumber
{
    //if the object for voucher counter is not created, create it
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"voucherNumber"]==nil) {
        [defaults setInteger:1 forKey:@"voucherNumber"];
        DLog(@"inicializando voucher counter");
        
    }
    else {
        int counter=[defaults integerForKey:@"voucherNumber"];
        counter++;
        [defaults setInteger:counter forKey:@"voucherNumber"];
        DLog(@"voucher counter ++");
        
    }
    
	bool sincronizo=[defaults synchronize];
    if (sincronizo) {
        DLog(@"sincronizo");
    }
    else {
        DLog(@"fallo sincronizar");
    }
    
}
+(int) getVoucherNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int counter=[defaults integerForKey:@"voucherNumber"];
    [Tools increaseVoucherNumber]; //1.4.3.2 increase voucher fix
    return counter;
    
}
////get the discount of the ticket  in question
//+(NSString*) calculateDiscountValueForTicket:(NSMutableArray*) promos
//{
//    NSString *description;
//    for (Promotions* promo in promos) {
//        //employee discount or normal discount
//        if ([promo.promoTypeBenefit isEqualToString:@"percentageDiscount"]) {
//            description =@"DESCUENTO ";
//            NSString*porcentaje= [Tools calculateDiscountValuePercentage:promo.promoBaseAmount :promo.promoDiscountPercent];
//            porcentaje=[Tools amountCurrencyFormat:porcentaje];
//            description=[description stringByAppendingString:porcentaje];
//        }
//    }
//return description;
//}

+(NSString*) calculateAmountToPayWithPromo:(NSArray*)productList :(NSMutableArray*) promos
{
	float total=0;
    float totalItems = 0;
	float itemPromoDiscounts=0;
    float itemKeyDiscounts = 0;
    float totalWarranties=0;
    float warrantyPromoDiscountsW=0;
    NSString *disc=@"";
	
	for (id item in productList) {
		
        if ([item isKindOfClass:[FindItemModel class]]) {
            FindItemModel *itemF = item;
            totalItems = [itemF.priceExtended floatValue]; //calculate includes quantity of items

            for (Promotions *promoManual in itemF.discounts) {
                if (promoManual.promoType==3) //print promotion by key with %
                {
                    itemKeyDiscounts+=[promoManual.promoValue floatValue];
                    //totalDiscounts*=[[item itemCount] floatValue]; //fix 1.4.3.2 apply discounts to all the item quantity
                }
                else if(promoManual.promoType==4) //print promotion by key with fixed amount
                {
                    itemKeyDiscounts+=[promoManual.promoDiscountPercent floatValue];
                }
            }
            //total+=[item.price floatValue];
            totalItems = itemF.isFree ? 0 : totalItems - itemKeyDiscounts;
            
            if (promos!=nil)
                for (Promotions *promo in promos) {
                    if ([promo.promoTypeBenefit isEqualToString:@"percentageDiscount"]&&![[item department]isEqualToString:@"391"]) {
                        disc=promo.promoDiscountPercent;
                        DLog(@"DISC >>>>> %@",disc);
                        
                        DLog(@"<<<<porcentaje>>>>>:%f, products:%@",total,disc);
                        NSString *pricef = [NSString stringWithFormat:@"%f",totalItems];
                        NSString*porcentaje= [Tools calculateDiscountValuePercentage:pricef :disc];
                        itemPromoDiscounts+=[porcentaje floatValue];
                    }
                }
            totalItems = totalItems - itemPromoDiscounts;
        } else if ([item isKindOfClass:[Warranty class]]){
            Warranty *itemW = item;
            totalWarranties = [itemW.quantity floatValue]*[itemW.cost floatValue];
            
            if (promos!=nil)
                for (Promotions *promo in promos) {
                    if ([promo.promoTypeBenefit isEqualToString:@"percentageDiscount"]&&![[item department]isEqualToString:@"391"]) {
                        NSLog(@"Is employee sale? %i",[Session getIsEmployeeSale]);

                        if (![promo.promoDescription isEqualToString:@"descuento casa"]) {
                            disc=promo.promoDiscountPercent;
                            DLog(@"DISC >>>>> %@",disc);
                            
                            DLog(@"<<<<porcentaje>>>>>:%f, products:%@",total,disc);
                            NSLog(@"Type benefit %@ %@ %i",promo.promoTypeBenefit,promo.promoDescription, promo.promoType);
                            NSString *priceP = [NSString stringWithFormat:@"%f",totalWarranties];
                            NSString*porcentaje= [Tools calculateDiscountValuePercentage:priceP :disc];
                            warrantyPromoDiscountsW += [porcentaje floatValue];
                            //totalS=[Tools calculateRestValueAmount:totalS :porcentaje];
                        }
                    }
                }
        }
        total += totalItems+totalWarranties-warrantyPromoDiscountsW;
        itemPromoDiscounts = 0;
        itemKeyDiscounts = 0;
        totalItems = 0;
        totalWarranties =0;
        warrantyPromoDiscountsW = 0;
    }
    

        DLog(@"<<<<total>>>>>:%f, products:%@",total,productList);
	
    NSString *totalS=[NSString stringWithFormat:@"%.02f",total];

    //depto 391
    //calculate the total amount for ticket with discounts
    //mover el orden, primero va manual.
		return totalS;
}

+(BOOL) isStringNumber:(NSString*) number
{
    //verify the input data
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setMaximumFractionDigits:2];
    [f setRoundingMode: NSNumberFormatterRoundUp];
    
    NSNumber * myNumber = [f numberFromString:number];
    [f release];
    if (myNumber==nil) {
        [Tools displayAlert:@"Error" message:@"Debe introducir una cantidad valida"];
        return NO;
    }
    else
        return YES;
}
+(NSString*) getDateFromString:(NSString*) string
{
    NSString* dateString=@"";
    
    if ([string length]>0||string!=nil) {
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        NSDate *date = [dateFormat dateFromString:string];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"EEE d/MMM/yyyy"];
        dateString = [dateFormat stringFromDate:date];
        [dateFormat release];
    }
    return dateString;
}
+(NSString*) getDateFormatRefundTicket:(NSString*) string
{
    NSString* dateString=@"";
    
    if ([string length]>0||string!=nil) {
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        NSDate *date = [dateFormat dateFromString:string];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"d/MMM/yyyy"];
        dateString = [dateFormat stringFromDate:date];
        [dateFormat release];
    }
    return dateString;
}
+(BOOL) compareStrings:(NSString*) string1 :(NSString*) string2
{
    if ([string1 length]==0 ||[string2 length]==0) {
        return YES;
    }
    else
        return [string1 isEqualToString:string2];
}
+(BOOL) compareNumbers:(NSString*) number1 :(NSString*) number2
{
    float n1=[number1 floatValue];
    float n2=[number2 floatValue];
    
    if (n1==n2)
        return YES;
    else
        return NO;
}
+(BOOL) validateManualDiscounts:(FindItemModel *) item :(int) promoToAdd
{
	NSMutableArray *discountCopy=[[[NSMutableArray alloc] initWithArray:item.discounts] autorelease];
	//Promotions *lastPromo=[discountCopy lastObject];
	DLog(@"calculateSuccesiveDiscounts" );
    BOOL isValid=YES;
    
    if ([discountCopy count]==2) {
        isValid=NO;
        DLog(@"promoManualNumber max");
    }else{
        if ([discountCopy count]==1) {
            Promotions *previousPromo=[discountCopy objectAtIndex:0];
            if (promoToAdd==4) {
                if ([previousPromo promoType]==4) {
                    isValid=NO;
                    DLog(@"[promo promoType]==4 NO");
                }
                else{
                    isValid=YES;
                    DLog(@"[promo promoType]!=4 YES");
                    
                }
            }
//            //employee only can have one manual discount
//            if ([Session getIsEmployeeSale]) {
//                isValid=NO;
//            }
        }
    }
    
    //
    //
    //	for (Promotions *promo in discountCopy) {
    //
    //		NSInteger index=[discountCopy indexOfObjectIdenticalTo:promo];
    //		DLog(@"promoManualNumber %i",index);
    //
    //        if (index==1)
    //        {
    //            isValid=NO;
    //            DLog(@"promoManualNumber max");
    //
    //        }
    //        //percentDiscount
    //        else if ([promo promoType]==3) {
    //            //if (index==1) {
    //                isValid=YES;
    //            //    DLog(@"promoManualNumber max");
    //
    //           // }
    //            DLog(@"[promo promoType]==3");
    //
    //        }
    //            //fixed amount
    //        else if ([promo promoType]==4) {
    //                Promotions *previousPromo=[discountCopy objectAtIndex:0];
    //                if ([previousPromo promoType]==4) {
    //                    isValid=NO;
    //                    DLog(@"[promo promoType]==4 NO");
    //                }
    //                else{
    //                    isValid=YES;
    //                    DLog(@"[promo promoType]!=4 YES");
    //
    //                }
    //        }
    //
    //	}
    return isValid;
}


+(NSString*) getRFCFormat:(NSString*) RFC
{
    DLog(@"getRFCFormat %@",RFC);
    //NSMutableString *rfc=[NSMutableString stringWithString:RFC];
    NSMutableString *rfc =  [[RFC mutableCopy] autorelease];
    
    [rfc insertString:@" " atIndex:5];
    [rfc insertString:@" " atIndex:11];
    [rfc insertString:@" " atIndex:17];
    
    return rfc;
    
}
+(NSString*) getMonederoBalanceFromBC:(NSString*) monederoBalance
{
    
    float balance=[monederoBalance floatValue];
	float finalBalance=balance/100;
    
	NSString *result=[NSString stringWithFormat:@"%.02f", finalBalance];
    
	if (finalBalance<=0)
		return @"";
	else
		return result;
}

+(NSString*) getRefundReasonPrintText:(NSString*) aIndex
{
    int index=[aIndex intValue];
    
    switch (index) {
        case 1:
            return @"TALLA O COLOR";
            break;
        case 2:
            return @"POR ESTILO";
            break;
        case 3:
            return @"POR DEFECTO";
            break;
        case 4:
            return @"NO LE GUSTO";
            break;
        case 5:
            return @"REGALO DUPLICADO";
            break;
        case 6:
            return @"CAMBIAR POR OTRO";
            break;
        default:
            break;
    }
    return @"";
}
+(NSString*) roundUpValue:(NSString *) value
{
    float decValue= [value floatValue];
    float roundedValue=ceil(decValue);
    
    NSString *result=[NSString stringWithFormat:@"%.02f", roundedValue];
    
    return result;
}

+(NSString*) getTypeOfSaleBCString
{
    
    //    FINISH_TRANSACTION = "FINISHTRANSACTION";
    //    FINISH_AIRTIME = "FINISHAIRTIME";
    //    FINISH_PAQUETERIA = "FINISHPAQUETERIA";
    //    FINISH_MESAREGALO = "FINISHMESAREGALO";
    //    FINISH_SOMS = "FINISHSOMS";
    //    FINISH_CANCEL = "FINISHCANCEL";
    //    FINISH_FOOD_TRANSACTION = "FINISHFOODTRANSACTION";
    //    FINISH_CLOSE_TERMINAL_ACTION = "FINISHCLOSETERMINALACTION";
    NSString *saleType;
    switch ([Session getSaleType]) {
        case NORMAL_CLIENT_TYPE:
        case NORMAL_EMPLOYEE_TYPE:
        case DULCERIA_CLIENT_TYPE:
        case REFUND_NORMAL_EMPLOYEE_TYPE:
        case REFUND_NORMAL_TYPE:
            saleType=@"FINISHTRANSACTION";
            break;
            
        case SOMS_CLIENT_TYPE:
        case SOMS_EMPLOYEE_TYPE:
            saleType=@"FINISHSOMS";
            break;
            
        case FOOD_CLIENT_TYPE:
            saleType= @"FINISHFOODTRANSACTION";
            break;
            
        case CANCEL_PAYMENT_TYPE:
        case CANCEL_TYPE:
            saleType= @"FINISHCANCEL";
            break;
            
        default:
            saleType= @"";
            break;
    }
    return saleType;
}
+(NSString*) getShortErrorMessage:(NSString*) value{
    
    NSArray *subString=[value componentsSeparatedByString:@":"];
    
    return [subString objectAtIndex:1];
}

+(NSMutableArray *)popWarrantiesFromArray:(NSArray *)productList
{
    NSMutableArray *pList = [[[NSMutableArray alloc] init] autorelease];
    for(id item in productList){
        if (![item isKindOfClass:[Warranty class]]) {
            [pList addObject:item];
        }
    }
    return pList;
}

@end
