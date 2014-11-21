//
//  ConsultSKUViewController.m
//  CardReader
//

#import "ConsultSKUViewController.h"
#import "CardReaderAppDelegate.h"
#import "FindItemModel.h"
#import "FindItemParser.h"
#import "ItemDetailViewController.h"
#import "ItemDiscountsViewController.h"
#import "Tools.h"
#import "Styles.h"
#import "Session.h"
#import "VFDevice.h"


@implementation ConsultSKUViewController
@synthesize itemModel,itemDetailView,itemDiscountView,productSearch,txtBarcode,btnRegister;

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

    [[VFDevice barcode] setDelegate:self];
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
	[Styles scanReaderViewStyle:productSearch];
	txtBarcode.inputAccessoryView=[Tools inputAccessoryView:txtBarcode];
	[super viewDidLoad];
	[Styles bgGradientColorPurple:self.view];
	[Styles silverButtonStyle:btnRegister];
    NSLog(@"View did load");
}

-(void)viewDidAppear:(BOOL)animated
{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                               target:self
                                             selector:@selector(targetMethod:)
                                             userInfo:nil
                                              repeats:NO];
    NSLog(@"View did appear");
    
}

-(void) targetMethod:(NSTimer *) theTimer {
    [[VFDevice barcode] setDelegate:self];
    BOOL vmfGen3Flag = [VFDevice barcode].isGen3;
    if (vmfGen3Flag == true) [VFDevice setBarcodeInitialization];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[VFDevice barcode] abortScan];
}
//-(void)viewDidUnload
//{
//	[scanDevice removeDelegate:self];
//	[scanDevice disconnect];
//	scanDevice = nil;
//    [super viewDidUnload];
//}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(IBAction) scanCode
{	
	if ([txtBarcode.text length]==0) {
		[Tools displayAlert:@"Aviso" message:@"Favor de introducir un SKU valido"];
		return;
	}
	//[Tools hideViewAnimation:productSearch];
	[self startRequest:txtBarcode.text];
	[self.view endEditing:YES];
	//[productSearch setHidden:YES];

}
-(IBAction) showBarcodeTextfield
{
	//[Tools showViewAnimation:productSearch];
	//[productSearch setHidden:NO];
	//[txtBarcode becomeFirstResponder];
	
}

//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark - Request Handlers
-(void) startRequest:(NSString*) barCode
{
	// find item request code 
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
    NSString *terminal=[Session getTerminal];
    warrantiesEnabled= [NSNumber numberWithBool:NO];
	NSArray *pars=[NSArray arrayWithObjects:barCode,@"",terminal,warrantiesEnabled, nil];
	[liverPoolRequest sendRequest:@"buscaProducto" forParameters:pars forRequestType:consultSKURequest]; //cambiar a localized string
	[liverPoolRequest release];
	//[Tools startActivityIndicator:self.view];
}

-(void) performResults:(NSData *)receivedData :(RequestType)requestType
{
	[self findItemRequestParsing:receivedData];
}

-(void) findItemRequestParsing:(NSData*) data
{
	FindItemParser *findParser=[[FindItemParser alloc] init];
	DLog(@"antes de empezar");
	[findParser startParser:data];
	DLog(@"termino");
	/*if (itemModel) {
		[itemModel release];
	}*/
	itemModel=findParser.findItemModel;
	[itemDetailView displayItemInfo:itemModel];
	[itemDiscountView setItemModel:itemModel];
	[self validateResponse];
	[findParser release];
	//[Tools stopActivityIndicator];
}

-(void) validateResponse
{
	if(itemModel.barCode ==nil)
		[Tools displayAlert:@"Error" message:@"Articulo no encontrado"];
	else
		[itemDiscountView startPromoRequest];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



//----------------------------------------
//            BARCODE ANALYSIS
//----------------------------------------
#pragma mark -
#pragma mark BARCODE ANALYSIS

-(void)barcodeData:(NSString *)barcode 
			  type:(int)type
{
	[self startRequest:barcode];
}

#pragma mark VFIBarcodeDelegate
-(void)barcodeScanData:(NSData *)data barcodeType:(int)thetype
{
    NSString* barcode = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    [self startRequest:barcode];
    [[VFDevice barcode] beepOnParsedScan:YES];
}

-(void)barcodeInitialized:(BOOL)isInitialized
{
    if (isInitialized) {
        [VFDevice setBarcodeInitialization];
    } else{
        NSLog(@"Is not initialized");
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	[productSearch endEditing:YES];
//	[super touchesBegan:touches withEvent:event];
}
- (void)dealloc {
	[itemDetailView release];
	[productSearch release];
	[itemDiscountView release];	//[itemModel release];
	[txtBarcode release];
	[btnRegister release], btnRegister = nil;
    [super dealloc];
}


@end
