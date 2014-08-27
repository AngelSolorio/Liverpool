
@class Store;
@interface StoreViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
	Store			*storeData;
}

@property (nonatomic, retain)	NSArray *listContent;
@property (nonatomic, retain)	NSMutableArray *filteredListContent;
@property (nonatomic, copy)		NSString *savedSearchTerm;
@property (nonatomic, assign)	Store *storeData;
@property (nonatomic)			NSInteger savedScopeButtonIndex;
@property (nonatomic)			BOOL searchWasActive;

@end
