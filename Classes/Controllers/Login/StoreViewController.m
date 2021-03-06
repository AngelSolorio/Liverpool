

#import "StoreViewController.h"

#import "Store.h"
#import "Session.h"
#import "Styles.h"

@implementation StoreViewController

@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, storeData;


#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
	self.title = @"Stores";
	
	// create a filtered list that will contain stores for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;

	UIView *back = [[[UIView alloc] init] autorelease];
	back.frame = CGRectMake(0, 0, 320, 480);
	[Styles bgGradientColorPurple:back];
	self.tableView.backgroundView = back;
}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
//	storeData=nil;
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryCheckmark;
		//UITableViewCellAccessoryDisclosureIndicator;
	}

	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	Store *store = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        store = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        store = [self.listContent objectAtIndex:indexPath.row];
    }
	NSString*  name=[store.number stringByAppendingString:@"- "];
	name=[name stringByAppendingString:store.name];
	cell.textLabel.text = name;
	[cell.textLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	cell.textLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];
	UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
	//bg.backgroundColor = UIColorFromRGBWithAlpha(0X66224F,1);
	bg.backgroundColor = UIColorFromRGBWithAlpha(0X66224F,1);
	cell.backgroundView = bg;
	cell.backgroundColor = [UIColor clearColor];
	[bg release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *detailsViewController = [[UIViewController alloc] init];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	Store *store = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        store = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        store = [self.listContent objectAtIndex:indexPath.row];
    }
	[Session setIdStore:[store number]];
	[Session setStore:[store name]];
    [Session setStorePrint:[store description]];
    DLog(@"[Session setStorePrint:[store description] : %@",[Session getStorePrint]);

//	storeData=[Store productWithType:[store number] name:[store name] description:[store description]];
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
//	detailsViewController.title = store.name;
//    
//    [[self navigationController] pushViewController:detailsViewController animated:YES];
//    [detailsViewController release];
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for stores whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Store *store in listContent)
	{
//		if ([scope isEqualToString:@"All"] || [stores.type isEqualToString:scope])
//		{
			NSComparisonResult result = [store.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
    
		if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:store];
            }
//		}
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
			[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
			[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end

