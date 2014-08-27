//
//  PrinterConfigViewController.m
//  CardReader


#import "PrinterConfigViewController.h"
#import "Tools.h"
#import "Session.h"
#import "Styles.h"
@implementation PrinterConfigViewController
@synthesize aTableView;
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
	[self setTitle:@"Configuración"];
	//printerList=[NSArray arrayWithObjects:@"Canon",@"HP",@"Epson",@"Lexmark",@"Panasonic",nil];
	//[printerList retain];
	[aTableView setBackgroundColor:[UIColor clearColor]];
	[Styles bgGradientColorPurple:self.view];
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
	[self startRequest];

}
-(void) viewWillDisappear:(BOOL)animated
{
	//[Tools savePrinter];
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
	[cell.textLabel setText:[printerList objectAtIndex:indexPath.row]];
	
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
	//return [tableData count];
	return [printerList count];
}
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel *header=[[[UILabel alloc] init]autorelease];
	header.frame=CGRectMake(20, 0, 200, 45);
	header.backgroundColor=[UIColor clearColor];
	header.text=@"Impresoras Disponibles";
	header.textColor=[UIColor whiteColor];
	
	UIView *aView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 45)] autorelease];
	[aView addSubview:header];
	return aView;

}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}
/*
-(NSString *)tableView:(UITableView *)tableView 
titleForFooterInSection:(NSInteger)section
{
	return @"Impresoras Disponibles";
}*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (previousIndex) {		
		[tableView deselectRowAtIndexPath:previousIndex animated:YES];
		[[tableView cellForRowAtIndexPath:previousIndex] setAccessoryType:UITableViewCellAccessoryNone];
	}
		UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
		selectedCell.accessoryType=UITableViewCellAccessoryCheckmark;
		
		previousIndex=[indexPath copy]; //  Ruben
	
	[self selectedPrinter:indexPath.row];
}

-(void) selectedPrinter:(int) printerIndex
{
	NSString *printer=[printerList objectAtIndex:printerIndex];
	[Session setPrinterName:printer];
 
}
//----------------------------------------
//            REQUEST HANDLERS
//----------------------------------------
#pragma mark -
#pragma mark REQUEST HANDLERS
-(void) startRequest
{
	[Tools startActivityIndicator:self.view];
	LiverPoolRequest *liverPoolRequest=[[LiverPoolRequest alloc] init];
	liverPoolRequest.delegate=self;
	NSArray *pars=[NSArray arrayWithObjects:nil];
	[liverPoolRequest sendRequest:@"buscaImpresorasExistentes" forParameters:pars forRequestType:findPrinters];
	[liverPoolRequest release];
}
-(void) performResults:(NSData *)receivedData :(RequestType)requestType
{
	[self findPrinterRequestParsing:receivedData];
}
-(void) findPrinterRequestParsing:(NSData*) data
{
	[printerList release];
	PrinterListParser *printerListParser=[[PrinterListParser alloc] init];
	[printerListParser startParser:data];
	printerList=[[printerListParser returnPrinterList]copy];
	[aTableView reloadData];
	[printerListParser release];
	[Tools stopActivityIndicator];

}
- (void)dealloc {
    [super dealloc];
	[aTableView release],aTableView=nil;
	[printerList release];
}
@end
