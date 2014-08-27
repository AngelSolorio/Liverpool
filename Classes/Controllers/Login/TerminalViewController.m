//
//  SynchonizeViewController.m
//  CardReader
//


#import "TerminalViewController.h"
#import "Tools.h"
#import "StoreViewController.h"
#import "Store.h"
#import "Styles.h"
#import "Session.h"
#import "LoginParser.h"
#import "Tools.h"
#import "Store.h"
#import "AffiliationCodes.h"
@implementation TerminalViewController
@synthesize btnStore,btnSave,txtTerminal,delegate, storeData,txtServer;
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[Styles bgGradientColorPurple:self.view];
	txtTerminal.inputAccessoryView=[Tools inputAccessoryView:txtTerminal];

}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
-(void) resetLabels
{
    txtTerminal.text=@"";
    txtServer.text=@"";
}

- (void)dealloc {
    [txtServer release], txtServer=nil;
	[btnStore release],btnStore=nil;
	[btnSave release],btnSave=nil;
	[txtTerminal release], txtTerminal=nil;
	[storeData release], storeData=nil;
	/*[delegate release],*/delegate=nil;
	[storeViewController release];
    [super dealloc];
}
//----------------------------------------
//            ACTIONS 
//----------------------------------------
-(void) storeSelection:(id)sender{
	
	if ((txtTerminal.text==nil||[txtTerminal.text length]==0)||(txtServer.text==nil||[txtServer.text length]==0)) {
		[Tools displayAlert:@"Aviso" message:@"Favor de introducir el ip del servidor y el numero de terminal para continuar"];
	}
    else {
        //try  stablish a connection with the server and request the store list
        [self startRequestGetStoreList];
    }
}
-(void) showStoreListView
{
    /**/
	if (storeViewController==nil) {
       
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = [paths objectAtIndex:0]; 
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"stores.plist"]; NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: filePath]) 
        {
            filePath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"stores.plist"] ];
        }
        
        NSMutableDictionary *storeDic = [[NSMutableDictionary alloc] initWithContentsOfFile: filePath];
		NSMutableArray *listStore= [[NSMutableArray alloc] init];
        DLog(@"FILEPATH 2 : %@",filePath);
    
		// Show the string values  
   		DLog(@"Dictionary size :%i , %@",[storeDic count],storeDic);
        for (id key in storeDic){
            
            NSDictionary *dictio=[storeDic objectForKey:key];
			DLog(@"Dictio %@", dictio);
			Store* aStore=[Store productWithType:((NSString*)[dictio objectForKey:@"number"]) 
											name:((NSString*)[dictio objectForKey:@"name"]) 
									 description:((NSString*)[dictio objectForKey:@"description"])];
			
			[listStore addObject:aStore];
		}
		//Create new instance of StoreViewController
		storeViewController = [[StoreViewController alloc] initWithNibName:@"StoreView" bundle:nil];
		
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"number"  ascending:YES];
        [listStore sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];

		storeViewController.listContent = listStore;
		[storeViewController setStoreData:storeData];
		[listStore release];
        [storeDic release];
	}
	
	[delegate showModal:storeViewController];
	//[storeViewController release];
}
-(void) save:(id)sender{
	DLog(@"storeData id %@ ", [Session getIdStore]);
	DLog(@"storeData store %@ ", [Session getStore]);
	DLog(@"valor %@ ",txtTerminal.text);
	DLog(@" terminal %d ", [txtTerminal.text length]);
    DLog(@"server address %@",[txtServer text]);
	if ((([Session getIdStore]==nil)||([Session getStore]==nil))||(txtTerminal.text==nil||[txtTerminal.text length]==0)||(txtServer.text==nil||[txtServer.text length]==0)) {
		[Tools displayAlert:@"Error" message:@"Favor de introducir ip, terminal y tienda antes de continuar"];
	}else {
        
		//NSString *uuid = [Tools getUniqueID];
        
        [self startRequestGetStoreAddress];

	}
	
}
//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS
-(void) startRequestGetStoreAddress
{
	//*** address request code ***/
    [Session SetServerAddress:[txtServer text]];

	[Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
    NSString *terminal=[txtTerminal text];
	NSMutableArray *pars=[NSMutableArray arrayWithObjects:terminal,nil];
    
	liverPoolRequest.delegate=self;
	[liverPoolRequest sendRequest:@"storeAddress" forParameters:pars forRequestType:addressRequest];  
	[liverPoolRequest release];
}

-(void) startRequestGetStoreList
{
	//*** address request code ***/
    [Session SetServerAddress:[txtServer text]];
    
	[Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
  
	liverPoolRequest.delegate=self;
	[liverPoolRequest sendRequest:@"storeList" forParameters:nil forRequestType:storeListRequest];  
	[liverPoolRequest release];
}
-(void) performResults:(NSData *)receivedData :(RequestType) requestType
{
	if (requestType==addressRequest) 
		[self addressRequestParsing:receivedData];
    if (requestType==storeListRequest) 
		[self storeListRequestParsing:receivedData];
}
-(void) addressRequestParsing:(NSData*) data
{
	LoginParser *loginParser=[[LoginParser alloc]init];
    [loginParser startParser:data];
    
    if ([loginParser isLoginSuccesful])
    {
        //banknames are fixed, no need to read the names from the parser
        AffiliationCodes *aff=[[loginParser affiliationsNumbers] objectAtIndex:0];
        NSString *bancomer=[[aff affiliationNumber] copy];
        
        
        aff=[[loginParser affiliationsNumbers] objectAtIndex:1];
       NSString *amex=[[aff affiliationNumber] copy];

        [Session SetStoreAddress:[loginParser getStoreAddress]];
        [Session setTerminal:[txtTerminal text]];
        [Session setBancomerAffNumber:bancomer];
        [Session setAmexAffNumber:amex];
        [Tools saveStore];
        [delegate isShowConfigView];
        [delegate showViewsForStoreData];
        [delegate evaluationActivePOS];
        [amex release];
        [bancomer release];
        [self resetLabels];
    }
    else
        [Tools displayAlert:@"Aviso" message:[loginParser returnName]];
            
    
    [loginParser release];
	[Tools stopActivityIndicator];
}
-(void) storeListRequestParsing:(NSData*) data
{
	LoginParser *loginParser=[[LoginParser alloc]init];
    [loginParser startParser:data];
    
    if ([loginParser isLoginSuccesful])
    {
        DLog(@"store sucess");
        [Tools saveStoreToPlist:loginParser.storeList];
        [self showStoreListView];
        
    }
    else
        [Tools displayAlert:@"Aviso" message:[loginParser returnName]];
    
    
    [loginParser release];
	[Tools stopActivityIndicator];
}
//----------------------------------------
//            TEXTFIELD DELEGATE
//----------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	textField.inputAccessoryView=[Tools inputAccessoryView:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}


@end
