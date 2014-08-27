//
//  PrinterConfigViewController.h
//  CardReader


#import <UIKit/UIKit.h>
#import "LiverPoolRequest.h"
#import "PrinterListParser.h"
@interface PrinterConfigViewController : UIViewController <UITableViewDelegate,WsCompleteDelegate> {
	UITableView		*aTableView;
	NSArray			*printerList;
	NSIndexPath		*previousIndex;
}
@property (nonatomic, retain) IBOutlet 	UITableView *aTableView;
-(void) startRequest;
-(void) findPrinterRequestParsing:(NSData*) data;
-(void) selectedPrinter:(int) printerIndex;

@end
