    //
//  AmountsViewController.m
//  CardReader
//

#import "AmountsViewController.h"
#import "Styles.h"

@implementation AmountsViewController
@synthesize amountsTable,amountSelectedIndex;
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
	[self loadAmounts];
	
	amountsTable.backgroundColor=[UIColor clearColor];
	[amountsTable reloadData];
	[amountsTable setDelegate:self];
	[amountsTable setDataSource:self];	
}
-(void) viewWillAppear:(BOOL)animated
{


	[amountsTable reloadData];
	
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


- (void)dealloc {
	[amountsTable release],amountsTable=nil;
	[amounts release];	amounts=nil;
    [super dealloc];
}

-(void) loadAmounts{
	if (amounts==nil) {
		// Path to the plist (in the application bundle)
		NSString *path = [[NSBundle mainBundle] pathForResource:
						  @"amounts" ofType:@"plist"];
		
		// Build the array from the plist  
		amounts = [[NSMutableArray alloc] initWithContentsOfFile:path];
		
	}
}
-(BOOL) isAmountSelected
{
	if (amountSelectedIndex==nil) 
		return NO;
	else
		return YES;
}	
-(NSString*) getAmountSelected
{
	return [amounts objectAtIndex:amountSelectedIndex.row];
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
	}else{
        for (UIView* subview in [cell.contentView subviews]) {
		
			[subview removeFromSuperview];
        
        }
    }
	
	NSString *amount=[amounts objectAtIndex:indexPath.row];
	cell.textLabel.textColor=[UIColor whiteColor];
	cell.textLabel.backgroundColor=[UIColor clearColor];
	[cell.textLabel setText:amount];
	
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	return [amounts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	amountSelectedIndex=[indexPath copy];  // Ruben
}

@end
